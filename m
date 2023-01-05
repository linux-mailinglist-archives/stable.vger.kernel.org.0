Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42165EB53
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjAEM6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjAEM6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:58:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942A35B172
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1140E61A10
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D421C433D2;
        Thu,  5 Jan 2023 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923486;
        bh=oUMcD5Ler3uMEvfSroYxl8tyOmTk2bvAPexaQohh0GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yALVDmICNFQV81Dk65G7oDJaIlCRRcGJWTeR2xCXzyv2NIT9vPwosMuuraxs4SjX0
         ucz9KkY04XArryjXLgOohDMXok6ci9WYewx6awyyI+ole/3aShs5M6HdxK+cQ72jH9
         O8EWJGbGUPtYeUFwcDmxuKVTxZnRMTqlyuzVnxvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 028/251] alpha: fix syscall entry in !AUDUT_SYSCALL case
Date:   Thu,  5 Jan 2023 13:52:45 +0100
Message-Id: <20230105125336.056814235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit f7b2431a6d22f7a91c567708e071dfcd6d66db14 ]

We only want to take the slow path if SYSCALL_TRACE or SYSCALL_AUDIT is
set; on !AUDIT_SYSCALL configs the current tree hits it whenever _any_
thread flag (including NEED_RESCHED, NOTIFY_SIGNAL, etc.) happens to
be set.

Fixes: a9302e843944 "alpha: Enable system-call auditing support"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/entry.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 98703d99b565..d752ccc53b24 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -468,8 +468,10 @@ entSys:
 #ifdef CONFIG_AUDITSYSCALL
 	lda     $6, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
 	and     $3, $6, $3
-#endif
 	bne     $3, strace
+#else
+	blbs    $3, strace		/* check for SYSCALL_TRACE in disguise */
+#endif
 	beq	$4, 1f
 	ldq	$27, 0($5)
 1:	jsr	$26, ($27), alpha_ni_syscall
-- 
2.35.1



