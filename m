Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623A76086A4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiJVHvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiJVHtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8B2C2ADD;
        Sat, 22 Oct 2022 00:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 472CD60B4A;
        Sat, 22 Oct 2022 07:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581ACC433D7;
        Sat, 22 Oct 2022 07:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424613;
        bh=lRLnCd09qU2Pnvqe8b6Dy8rpdc/eTMoFLE3OYWFRwVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTvD6MVnHvgXAfVpJmNCkGIqjRTckiI5JCurOJDn++ec5SbsJLhvVNJevtijf7jhQ
         5HGOUrcpCpgFg2vFEop1E3dA2NjC8FB8P3zUh598EOH+7j2hxV12EN08a0dVnXvozh
         gYEmFrd/3Mut9pG3669kzs0ppuCu2IoGCqREVMUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 212/717] audit: free audit_proctitle only on task exit
Date:   Sat, 22 Oct 2022 09:21:31 +0200
Message-Id: <20221022072452.771100731@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 65d816cda5df..73121c0185ce 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1016,7 +1016,6 @@ static void audit_reset_context(struct audit_context *ctx)
 	WARN_ON(!list_empty(&ctx->killed_trees));
 	audit_free_module(ctx);
 	ctx->fds[0] = -1;
-	audit_proctitle_free(ctx);
 	ctx->type = 0; /* reset last for audit_free_*() */
 }
 
@@ -1102,6 +1101,7 @@ static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */
 	audit_reset_context(context);
+	audit_proctitle_free(context);
 	free_tree_refs(context);
 	kfree(context->filterkey);
 	kfree(context);
-- 
2.35.1



