Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6860A6432D2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiLETaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiLET35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:29:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29183FD0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18A75CE13A4
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB26C433D7;
        Mon,  5 Dec 2022 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268369;
        bh=zGWXVMbwGt+8aEr9m6MBhI4HRYfxwTVEDASu2nHH07w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMv5YMyNhJjKCa8g8ob/Yzf7ICB+5EN17swBM06Rga4oJd30vhGSWqYuNexdhfmK2
         X5RKfv5zusBpf6NfZbfl+kDlUyQAxwRb1oe+6aKlobnJyPQCPTShmM3k0Fq1k4TIpG
         /0dt5AZ/HL28Nb2MRPoNcupxAWJL7Doy7NfLAIGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 077/124] ALSA: dice: fix regression for Lexicon I-ONIX FW810S
Date:   Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190810.605879611@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 9b84f0f74d0d716e3fd18dc428ac111266ef5844 upstream.

For Lexicon I-ONIX FW810S, the call of ioctl(2) with
SNDRV_PCM_IOCTL_HW_PARAMS can returns -ETIMEDOUT. This is a regression due
to the commit 41319eb56e19 ("ALSA: dice: wait just for
NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation"). The device
does not emit NOTIFY_CLOCK_ACCEPTED notification when accepting
GLOBAL_CLOCK_SELECT operation with the same parameters as current ones.

This commit fixes the regression. When receiving no notification, return
-ETIMEDOUT as long as operating for any change.

Fixes: 41319eb56e19 ("ALSA: dice: wait just for NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20221130130604.29774-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-stream.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -59,7 +59,7 @@ int snd_dice_stream_get_rate_mode(struct
 
 static int select_clock(struct snd_dice *dice, unsigned int rate)
 {
-	__be32 reg;
+	__be32 reg, new;
 	u32 data;
 	int i;
 	int err;
@@ -83,15 +83,17 @@ static int select_clock(struct snd_dice
 	if (completion_done(&dice->clock_accepted))
 		reinit_completion(&dice->clock_accepted);
 
-	reg = cpu_to_be32(data);
+	new = cpu_to_be32(data);
 	err = snd_dice_transaction_write_global(dice, GLOBAL_CLOCK_SELECT,
-						&reg, sizeof(reg));
+						&new, sizeof(new));
 	if (err < 0)
 		return err;
 
 	if (wait_for_completion_timeout(&dice->clock_accepted,
-			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0)
-		return -ETIMEDOUT;
+			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0) {
+		if (reg != new)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }


