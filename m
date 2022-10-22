Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9814E6086AD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiJVHwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiJVHue (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6212C2ACB;
        Sat, 22 Oct 2022 00:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11F760B0A;
        Sat, 22 Oct 2022 07:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B056FC433D6;
        Sat, 22 Oct 2022 07:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424611;
        bh=Kb5ALKjzG/7/M7Lz6XgmAsT3pLBjYGXRI1M5hmOz0JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzLBwBKJ4iPKUL08UjWCyk26IRBISe+M0sWWXsApXSOv9t+sSa0qSqDOOSbPuMfSI
         fdWRYFT8QFrZdIML88eGOdgWxlI7vTIVvrE5qd58iUN2l8vt0BjR1Ynnhu3A3Zzc51
         F+Z4gtMYaiK7jChWCOc0l4LUJjlIpcBkolRgBQps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 211/717] audit: explicitly check audit_context->context enum value
Date:   Sat, 22 Oct 2022 09:21:30 +0200
Message-Id: <20221022072452.598694575@linuxfoundation.org>
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
index 0c33e04c293a..65d816cda5df 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2094,7 +2094,7 @@ void __audit_syscall_exit(int success, long return_code)
 	/* run through both filters to ensure we set the filterkey properly */
 	audit_filter_syscall(current, context);
 	audit_filter_inodes(current, context);
-	if (context->current_state < AUDIT_STATE_RECORD)
+	if (context->current_state != AUDIT_STATE_RECORD)
 		goto out;
 
 	audit_log_exit();
-- 
2.35.1



