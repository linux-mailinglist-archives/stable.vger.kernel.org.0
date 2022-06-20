Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31B4551A78
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbiFTNGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiFTNEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB1193F4;
        Mon, 20 Jun 2022 06:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A1516153E;
        Mon, 20 Jun 2022 13:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5067FC3411C;
        Mon, 20 Jun 2022 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730005;
        bh=pSRUrrJVSkmqn3e99bE13Jtw6ybKL9gmtfLgF359Uqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBjg27uku6aTBxmhfz3UkgfyfwxYcjCqEM3ODMona/WDj2ASTs1rekzLsVKJW8hqB
         l+12x3B+Ce9xZuO07nZFvkT/ZBmsWn36zXCG8011ppeRF/eduBTF1Tm5v2Kh+M1h5F
         L0QRatGImbJXKvBnyQkU9fSFHdJzXS5svKKku9pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.18 123/141] audit: free module name
Date:   Mon, 20 Jun 2022 14:51:01 +0200
Message-Id: <20220620124733.188036063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

commit ef79c396c664be99d0c5660dc75fe863c1e20315 upstream.

Reset the type of the record last as the helper `audit_free_module()`
depends on it.

    unreferenced object 0xffff888153b707f0 (size 16):
      comm "modprobe", pid 1319, jiffies 4295110033 (age 1083.016s)
      hex dump (first 16 bytes):
        62 69 6e 66 6d 74 5f 6d 69 73 63 00 6b 6b 6b a5  binfmt_misc.kkk.
      backtrace:
        [<ffffffffa07dbf9b>] kstrdup+0x2b/0x50
        [<ffffffffa04b0a9d>] __audit_log_kern_module+0x4d/0xf0
        [<ffffffffa03b6664>] load_module+0x9d4/0x2e10
        [<ffffffffa03b8f44>] __do_sys_finit_module+0x114/0x1b0
        [<ffffffffa1f47124>] do_syscall_64+0x34/0x80
        [<ffffffffa200007e>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Cc: stable@vger.kernel.org
Fixes: 12c5e81d3fd0 ("audit: prepare audit_context for use in calling contexts beyond syscalls")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1014,10 +1014,10 @@ static void audit_reset_context(struct a
 	ctx->target_comm[0] = '\0';
 	unroll_tree_refs(ctx, NULL, 0);
 	WARN_ON(!list_empty(&ctx->killed_trees));
-	ctx->type = 0;
 	audit_free_module(ctx);
 	ctx->fds[0] = -1;
 	audit_proctitle_free(ctx);
+	ctx->type = 0; /* reset last for audit_free_*() */
 }
 
 static inline struct audit_context *audit_alloc_context(enum audit_state state)


