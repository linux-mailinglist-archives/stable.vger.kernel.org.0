Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2880B4C752E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbiB1RwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiB1RvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:51:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ABEA647B;
        Mon, 28 Feb 2022 09:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D896C61545;
        Mon, 28 Feb 2022 17:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE057C340E7;
        Mon, 28 Feb 2022 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069962;
        bh=CHBTQVhMAnW3Sp0x6Fd7Ta9G5gSlr9kt0uqjKa04OJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlUUMSYbaczW9syMrOqsqU6TnBZHtsRpR2J7Z8yQfGHsE3NQ7VgZBb2OPiq974aMb
         9Wt2D5W8LaKSPq/MhXh+/9gSggujQVp9lgMZCQnCZzQoBBPTmkRx/AYd+CYS5QnZWM
         tMi7/s5+xQN5AFvKS6+zzydiUOHdP8YAgA3T7d6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 074/139] surface: surface3_power: Fix battery readings on batteries without a serial number
Date:   Mon, 28 Feb 2022 18:24:08 +0100
Message-Id: <20220228172355.508600289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 21d90aaee8d5c2a097ef41f1430d97661233ecc6 upstream.

The battery on the 2nd hand Surface 3 which I recently bought appears to
not have a serial number programmed in. This results in any I2C reads from
the registers containing the serial number failing with an I2C NACK.

This was causing mshw0011_bix() to fail causing the battery readings to
not work at all.

Ignore EREMOTEIO (I2C NACK) errors when retrieving the serial number and
continue with an empty serial number to fix this.

Fixes: b1f81b496b0d ("platform/x86: surface3_power: MSHW0011 rev-eng implementation")
BugLink: https://github.com/linux-surface/linux-surface/issues/608
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220224101848.7219-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/surface3_power.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/platform/surface/surface3_power.c
+++ b/drivers/platform/surface/surface3_power.c
@@ -233,14 +233,21 @@ static int mshw0011_bix(struct mshw0011_
 	}
 	bix->last_full_charg_capacity = ret;
 
-	/* get serial number */
+	/*
+	 * Get serial number, on some devices (with unofficial replacement
+	 * battery?) reading any of the serial number range addresses gets
+	 * nacked in this case just leave the serial number empty.
+	 */
 	ret = i2c_smbus_read_i2c_block_data(client, MSHW0011_BAT0_REG_SERIAL_NO,
 					    sizeof(buf), buf);
-	if (ret != sizeof(buf)) {
+	if (ret == -EREMOTEIO) {
+		/* no serial number available */
+	} else if (ret != sizeof(buf)) {
 		dev_err(&client->dev, "Error reading serial no: %d\n", ret);
 		return ret;
+	} else {
+		snprintf(bix->serial, ARRAY_SIZE(bix->serial), "%3pE%6pE", buf + 7, buf);
 	}
-	snprintf(bix->serial, ARRAY_SIZE(bix->serial), "%3pE%6pE", buf + 7, buf);
 
 	/* get cycle count */
 	ret = i2c_smbus_read_word_data(client, MSHW0011_BAT0_REG_CYCLE_CNT);


