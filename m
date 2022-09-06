Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB935AEC16
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiIFOAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiIFN5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0F78BC5;
        Tue,  6 Sep 2022 06:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA6FB81636;
        Tue,  6 Sep 2022 13:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F4CC433D7;
        Tue,  6 Sep 2022 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471715;
        bh=zkfqekhPS+p6+BJUAlqNpuJtYBlshZ7oJ2takpsDA30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ8en1cwBCvULkCO0x553E+tRYNNHnJSNmwLyDFsEVYotjbcOzMInY/4/PZo3GU7V
         IpOZApQegVooNcwqSkMbgJOhAtBz4UM3UWXKid6jX2WIJSUFSq/S8qeB1oqY6SN4oY
         rJQ0jpP27DnPwut9p4iatSLcXAfDKdcEoKa7kxAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YiFei Zhu <zhuyifei@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 014/155] bpf: Restrict bpf_sys_bpf to CAP_PERFMON
Date:   Tue,  6 Sep 2022 15:29:22 +0200
Message-Id: <20220906132830.033423812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

[ Upstream commit 14b20b784f59bdd95f6f1cfb112c9818bcec4d84 ]

The verifier cannot perform sufficient validation of any pointers passed
into bpf_attr and treats them as integers rather than pointers. The helper
will then read from arbitrary pointers passed into it. Restrict the helper
to CAP_PERFMON since the security model in BPF of arbitrary kernel read is
CAP_BPF + CAP_PERFMON.

Fixes: af2ac3e13e45 ("bpf: Prepare bpf syscall to be used from kernel and user space.")
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220816205517.682470-1-zhuyifei@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82e83cfb4114a..dd0fc2a86ce17 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5153,7 +5153,7 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 	case BPF_FUNC_sys_bpf:
-		return &bpf_sys_bpf_proto;
+		return !perfmon_capable() ? NULL : &bpf_sys_bpf_proto;
 	case BPF_FUNC_btf_find_by_name_kind:
 		return &bpf_btf_find_by_name_kind_proto;
 	case BPF_FUNC_sys_close:
-- 
2.35.1



