Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512155A4AAC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiH2Lqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiH2Lqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3D255A7;
        Mon, 29 Aug 2022 04:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8747C6124C;
        Mon, 29 Aug 2022 11:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ACBC433B5;
        Mon, 29 Aug 2022 11:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771836;
        bh=3ZJ55aFjljXhDNzP5PC35zGb7thw45TdC+48KtP1bZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+YdrDVJZ/FQL2QtGzZfMpTUPf2QQmhExb+LbU6s4GVTDIFnq60et9YFLo61WU8lv
         yi0CdqwTiGml7LSZCRtnnE1Zak6Nj0mGWnKm+PCX8hS5/xcDjq3+hSDhZSbX0+PuXF
         mtg5iQ5VdFAUyijoAI0oaOgw/c8KVEhdxGj/5LJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.19 112/158] audit: move audit_return_fixup before the filters
Date:   Mon, 29 Aug 2022 12:59:22 +0200
Message-Id: <20220829105813.797371125@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Richard Guy Briggs <rgb@redhat.com>

commit d4fefa4801a1c2f9c0c7a48fbb0fdf384e89a4ab upstream.

The success and return_code are needed by the filters.  Move
audit_return_fixup() before the filters.  This was causing syscall
auditing events to be missed.

Link: https://github.com/linux-audit/audit-kernel/issues/138
Cc: stable@vger.kernel.org
Fixes: 12c5e81d3fd0 ("audit: prepare audit_context for use in calling contexts beyond syscalls")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
[PM: manual merge required]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1965,6 +1965,7 @@ void __audit_uring_exit(int success, lon
 		goto out;
 	}
 
+	audit_return_fixup(ctx, success, code);
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
 		/*
 		 * NOTE: See the note in __audit_uring_entry() about the case
@@ -2006,7 +2007,6 @@ void __audit_uring_exit(int success, lon
 	audit_filter_inodes(current, ctx);
 	if (ctx->current_state != AUDIT_STATE_RECORD)
 		goto out;
-	audit_return_fixup(ctx, success, code);
 	audit_log_exit();
 
 out:
@@ -2090,13 +2090,13 @@ void __audit_syscall_exit(int success, l
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(context);
 
+	audit_return_fixup(context, success, return_code);
 	/* run through both filters to ensure we set the filterkey properly */
 	audit_filter_syscall(current, context);
 	audit_filter_inodes(current, context);
 	if (context->current_state < AUDIT_STATE_RECORD)
 		goto out;
 
-	audit_return_fixup(context, success, return_code);
 	audit_log_exit();
 
 out:


