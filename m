Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE3604878
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJSN4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiJSNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1761C5A58;
        Wed, 19 Oct 2022 06:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C73B82327;
        Wed, 19 Oct 2022 08:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A8FC433C1;
        Wed, 19 Oct 2022 08:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169354;
        bh=7MyABJGgUTVSou116WehLBxh9mUqA3bxD8cDImHoQxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stb10XTR6pKiPLDL1ovNwS9eXeOjWHggtwkTTPyljPfT3uYkCpivsOp4HKM9Ory3s
         uvqalHwHbFI14xUTT60wBGnq9j262L2CHnHRT1aHQY2AEbpUar7AtjMKPITb8VIM0+
         pF9YH8TBPmUqeYMc4bwYlZTzqyccSZ1j7OWaPHjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 246/862] audit: explicitly check audit_context->context enum value
Date:   Wed, 19 Oct 2022 10:25:33 +0200
Message-Id: <20221019083300.892749573@linuxfoundation.org>
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

[ Upstream commit 3ed66951f952ed8f1a5d03e171722bf2631e8d58 ]

Be explicit in checking the struct audit_context "context" member enum
value rather than assuming the order of context enum values.

Fixes: 12c5e81d3fd0 ("audit: prepare audit_context for use in calling contexts beyond syscalls")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/auditsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 79a5da1bc5bb..0ee09447ad04 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2069,7 +2069,7 @@ void __audit_syscall_exit(int success, long return_code)
 	/* run through both filters to ensure we set the filterkey properly */
 	audit_filter_syscall(current, context);
 	audit_filter_inodes(current, context);
-	if (context->current_state < AUDIT_STATE_RECORD)
+	if (context->current_state != AUDIT_STATE_RECORD)
 		goto out;
 
 	audit_log_exit();
-- 
2.35.1



