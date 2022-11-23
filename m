Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D236C6358CB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiKWKCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbiKWKB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1232151C01
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A5F61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98022C433D6;
        Wed, 23 Nov 2022 09:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197219;
        bh=OP3xTZtj9CsnyaQHPQQEnLm1yDzvAH7Qbs7EJ4k81+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKas4QZYhpSMZwOMU1440KY4iGSsEeFO0ePqpz5icgq25hW0Xd0YxdG5P+ikS7JWX
         wx8hDUi3rpYicGImVQBcNIGqeIX9LI+U5XJIivt1cksfsbwjwW5QV+Ivruq/Zx6FZr
         Z1bwfjLJ3VDFLbQnhXvzREBJwpGKT/J0R2lOqfSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Mushahid Hussain <mushi.shar@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.0 231/314] speakup: fix a segfault caused by switching consoles
Date:   Wed, 23 Nov 2022 09:51:16 +0100
Message-Id: <20221123084635.974943948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Mushahid Hussain <mushi.shar@gmail.com>

commit 0fc801f8018000c8e64a275a20cb1da7c54e46df upstream.

This patch fixes a segfault by adding a null check on synth in
speakup_con_update(). The segfault can be reproduced as follows:

	- Login into a text console

	- Load speakup and speakup_soft modules

	- Remove speakup_soft

	- Switch to a graphics console

This is caused by lack of a null check on `synth` in
speakup_con_update().

Here's the sequence that causes the segfault:

	- When we remove the speakup_soft, synth_release() sets the synth
	  to null.

	- After that, when we change the virtual console to graphics
	  console, vt_notifier_call() is fired, which then calls
	  speakup_con_update().

	- Inside speakup_con_update() there's no null check on synth,
	  so it calls synth_printf().

	- Inside synth_printf(), synth_buffer_add() and synth_start(),
	  both access synth, when it is null and causing a segfault.

Therefore adding a null check on synth solves the issue.

Fixes: 2610df41489f ("staging: speakup: Add pause command used on switching to graphical mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Mushahid Hussain <mushi.shar@gmail.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20221010165720.397042-1-mushi.shar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -1778,7 +1778,7 @@ static void speakup_con_update(struct vc
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */


