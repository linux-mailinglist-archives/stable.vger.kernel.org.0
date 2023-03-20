Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D10C6C1277
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 13:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjCTM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 08:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjCTM5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 08:57:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A6515154
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 05:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71660B80D5B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 12:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEADC433A0;
        Mon, 20 Mar 2023 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679317048;
        bh=7/X6PRwUdby+TbrwGZuTM9/QGRNALIimXNczN2m49w4=;
        h=Subject:To:From:Date:From;
        b=nsc9iJuXGrtjr3JPLtXsiHVX82ZkKCKDgnka5RGFo/p5+Ga1meFCuWkUMVLUzns2h
         fEZBMk223b/DchMlpRql02CfKGJT2dSZ1UdnsmL+f47sNXw8DbK05Ssfc5t0FZFYSx
         zhKDQ40nJidduq8WKjCAFUuM0TclfrPABJm7BRH4=
Subject: patch "counter: 104-quad-8: Fix Synapse action reported for Index signals" added to char-misc-linus
To:     william.gray@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 13:57:17 +0100
Message-ID: <167931703787245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    counter: 104-quad-8: Fix Synapse action reported for Index signals

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 00f4bc5184c19cb33f468f1ea409d70d19f8f502 Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <william.gray@linaro.org>
Date: Thu, 16 Mar 2023 16:34:26 -0400
Subject: counter: 104-quad-8: Fix Synapse action reported for Index signals

Signal 16 and higher represent the device's Index lines. The
priv->preset_enable array holds the device configuration for these Index
lines. The preset_enable configuration is active low on the device, so
invert the conditional check in quad8_action_read() to properly handle
the logical state of preset_enable.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230316203426.224745-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index d59e4f34a680..d9cb937665cf 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -368,7 +368,7 @@ static int quad8_action_read(struct counter_device *counter,
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
+		if (!priv->preset_enable[count->id])
 			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
 			*action = COUNTER_SYNAPSE_ACTION_NONE;
-- 
2.40.0


