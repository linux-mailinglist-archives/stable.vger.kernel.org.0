Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E3F6354AA
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbiKWJJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiKWJJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:09:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3628415FF4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C698261B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40DDC433B5;
        Wed, 23 Nov 2022 09:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194554;
        bh=j0Q7W8nBJpRZPClb33Ok8jHJKZZVzMLWRuNlgwAb0Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt2OcAf0y+y1LVgUuEWC9DQCJqGqMLCrjxVkQomU2T5aB5O3az/oH9O351drBkcR3
         XadLdaP2oFM4i4l0OgjTvYdGwDvDF29WQ26igd6KoelcDg4YA8wIfGTnr9zE501yDr
         mFHrReAAXEtK31YyYRfJBrirmtA7AZoOdtHWydZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Mushahid Hussain <mushi.shar@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 4.19 081/114] speakup: fix a segfault caused by switching consoles
Date:   Wed, 23 Nov 2022 09:51:08 +0100
Message-Id: <20221123084555.095281547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
 drivers/staging/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1778,7 +1778,7 @@ static void speakup_con_update(struct vc
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */


