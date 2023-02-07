Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0066468D768
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjBGM7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjBGM7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711107EE4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F014613F9
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9C5C433EF;
        Tue,  7 Feb 2023 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774766;
        bh=65hwGgIvCMkExfJRsYVu7I5nLGI+k6SS/gP9hroCNis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wW+eQmzh1XC7ZWAhRW2ugEbO5vFdE7vMCRqbm952AwTc64oUbLPkX7IEyjCfg21C4
         KNuhBVRVRdJ/uEXZxYtvVXa8y0hKnazkxo3IlIEk4aQeeEq0a0tmxPxkURwKWlOT8L
         mOkbkD+l1vQv58LdQudR38Hv1FHmh5yvdVWMxprw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/208] bpf: Add missing btf_put to register_btf_id_dtor_kfuncs
Date:   Tue,  7 Feb 2023 13:54:33 +0100
Message-Id: <20230207125635.190907823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 74bc3a5acc82f020d2e126f56c535d02d1e74e37 ]

We take the BTF reference before we register dtors and we need
to put it back when it's done.

We probably won't se a problem with kernel BTF, but module BTF
would stay loaded (because of the extra ref) even when its module
is removed.

Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Fixes: 5ce937d613a4 ("bpf: Populate pairs of btf_id and destructor kfunc in btf")
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230120122148.1522359-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index efdbba2a0230..a7c2f0c3fc19 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7607,9 +7607,9 @@ int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_c
 
 	sort(tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func, NULL);
 
-	return 0;
 end:
-	btf_free_dtor_kfunc_tab(btf);
+	if (ret)
+		btf_free_dtor_kfunc_tab(btf);
 	btf_put(btf);
 	return ret;
 }
-- 
2.39.0



