Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A095AEC79
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiIFOA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiIFN7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7022832DC;
        Tue,  6 Sep 2022 06:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87923B818DF;
        Tue,  6 Sep 2022 13:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0EEC433D6;
        Tue,  6 Sep 2022 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471730;
        bh=ZBs+Pnl56LuP62f2/5Od+2i6/C2P4iDjFoXFcwde8iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyXfILC33i17tbtc6cDK6sy2SueOvyiPV1fnmaQWUeVyjpBGi2OBKkXjxX/bFCr6t
         /tfdwSrvHiqK974cZYdn3Ou9HWBKQG+EKxHxiODTnmYHHsfzjRGPycBtRpLWqyB8N6
         +PvPL9Rb5bmJJYCrE6sp43q27qaZdm55WlL57iN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 019/155] bpf: Fix a data-race around bpf_jit_limit.
Date:   Tue,  6 Sep 2022 15:29:27 +0200
Message-Id: <20220906132830.235883991@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 0947ae1121083d363d522ff7518ee72b55bd8d29 ]

While reading bpf_jit_limit, it can be changed concurrently via sysctl,
WRITE_ONCE() in __do_proc_doulongvec_minmax(). The size of bpf_jit_limit
is long, so we need to add a paired READ_ONCE() to avoid load-tearing.

Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220823215804.2177-1-kuniyu@amazon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index fb6bd57228a84..cf44ff50b1f23 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1005,7 +1005,7 @@ pure_initcall(bpf_jit_charge_init);
 
 int bpf_jit_charge_modmem(u32 size)
 {
-	if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
+	if (atomic_long_add_return(size, &bpf_jit_current) > READ_ONCE(bpf_jit_limit)) {
 		if (!bpf_capable()) {
 			atomic_long_sub(size, &bpf_jit_current);
 			return -EPERM;
-- 
2.35.1



