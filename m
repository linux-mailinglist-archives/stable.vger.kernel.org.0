Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7696E53D11F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbiFCSQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348048AbiFCSQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:16:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A635662CEB;
        Fri,  3 Jun 2022 11:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09E7DB82435;
        Fri,  3 Jun 2022 17:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38258C385A9;
        Fri,  3 Jun 2022 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279123;
        bh=sO/fkfrAJ5blRicrhVjpzLcwBfyTi7/AnGJfvCfo6Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRcBTePm7ERn55Dq8+oe8MSZeUlwSjKF40P06u3f7NxCX23VuC5E3NJ7D+XXa8RtD
         ie1bi1KI6GUmabxpqwpkIgb+FcLAHCwvBpbMHbCkmWqCTihkiM6G8wSgbxPmcaSXxB
         hW2FNEMjUlwU8vQWwo6jXYfcmdT5fFPsEzS+fSdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.18 60/67] bpf: Fix potential array overflow in bpf_trampoline_get_progs()
Date:   Fri,  3 Jun 2022 19:44:01 +0200
Message-Id: <20220603173822.448594205@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuntao Wang <ytcoode@gmail.com>

commit a2aa95b71c9bbec793b5c5fa50f0a80d882b3e8d upstream.

The cnt value in the 'cnt >= BPF_MAX_TRAMP_PROGS' check does not
include BPF_TRAMP_MODIFY_RETURN bpf programs, so the number of
the attached BPF_TRAMP_MODIFY_RETURN bpf programs in a trampoline
can exceed BPF_MAX_TRAMP_PROGS.

When this happens, the assignment '*progs++ = aux->prog' in
bpf_trampoline_get_progs() will cause progs array overflow as the
progs field in the bpf_tramp_progs struct can only hold at most
BPF_MAX_TRAMP_PROGS bpf programs.

Fixes: 88fd9e5352fe ("bpf: Refactor trampoline update code")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Link: https://lore.kernel.org/r/20220430130803.210624-1-ytcoode@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/trampoline.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -411,7 +411,7 @@ int bpf_trampoline_link_prog(struct bpf_
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
-	int cnt;
+	int cnt = 0, i;
 
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
@@ -422,7 +422,10 @@ int bpf_trampoline_link_prog(struct bpf_
 		err = -EBUSY;
 		goto out;
 	}
-	cnt = tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT];
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		cnt += tr->progs_cnt[i];
+
 	if (kind == BPF_TRAMP_REPLACE) {
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt) {
@@ -500,16 +503,19 @@ out:
 
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
+	int i;
+
 	if (!tr)
 		return;
 	mutex_lock(&trampoline_mutex);
 	if (!refcount_dec_and_test(&tr->refcnt))
 		goto out;
 	WARN_ON_ONCE(mutex_is_locked(&tr->mutex));
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
-		goto out;
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
-		goto out;
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[i])))
+			goto out;
+
 	/* This code will be executed even when the last bpf_tramp_image
 	 * is alive. All progs are detached from the trampoline and the
 	 * trampoline image is patched with jmp into epilogue to skip


