Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA00604843
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiJSNxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiJSNwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F48E1B8674;
        Wed, 19 Oct 2022 06:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3926B8232B;
        Wed, 19 Oct 2022 08:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35591C433C1;
        Wed, 19 Oct 2022 08:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169357;
        bh=Fq5bDuSWq61AfBRYdgTC2qpoeoE4a3r+TcYud3nUcGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsa9TLmI8Pzy69uyDQOgF21mloreix7/MUM9hWD5sCYs7nWno6mvdeA+U/2JZo59y
         qVwilClv8uwvKLIcnpJTOXqdeXEgEohnO3iAS/cDK669alt/YCFzAVW4MseEgf/NQ3
         sgPfhz0vy5Q0xQG6HXBgxMIKwYtLN+EIuTQ/Kyv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 247/862] audit: free audit_proctitle only on task exit
Date:   Wed, 19 Oct 2022 10:25:34 +0200
Message-Id: <20221019083300.942268675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit c3f3ea8af44d0c5fba79fe8b198087342d0c7e04 ]

Since audit_proctitle is generated at syscall exit time, its value is
used immediately and cached for the next syscall.  Since this is the
case, then only clear it at task exit time.  Otherwise, there is no
point in caching the value OR bearing the overhead of regenerating it.

Fixes: 12c5e81d3fd0 ("audit: prepare audit_context for use in calling contexts beyond syscalls")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/auditsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 0ee09447ad04..63a6fe99aa3a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1016,7 +1016,6 @@ static void audit_reset_context(struct audit_context *ctx)
 	WARN_ON(!list_empty(&ctx->killed_trees));
 	audit_free_module(ctx);
 	ctx->fds[0] = -1;
-	audit_proctitle_free(ctx);
 	ctx->type = 0; /* reset last for audit_free_*() */
 }
 
@@ -1077,6 +1076,7 @@ static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */
 	audit_reset_context(context);
+	audit_proctitle_free(context);
 	free_tree_refs(context);
 	kfree(context->filterkey);
 	kfree(context);
-- 
2.35.1



