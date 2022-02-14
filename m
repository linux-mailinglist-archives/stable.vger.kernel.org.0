Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD77F4B4700
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244565AbiBNJmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245299AbiBNJlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ED2652FE;
        Mon, 14 Feb 2022 01:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A38B7B80DCC;
        Mon, 14 Feb 2022 09:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D8C340E9;
        Mon, 14 Feb 2022 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831436;
        bh=wDqnvc6CLUgfoEy20HXPoeHFbVA62YBNGu44nsE+AWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHBy7WCJhS/wCGxImxuLoeAAhCtPcEU6tjtG/YWeZrVGXRRvagqbnGMXdIGh90xA/
         g3Ii57gzZIc5mxG0N7mLSMxhjtyTgllcBV8PJPUtK/D0qDn6VVqQ9I0mq9/unOvOqI
         QD/iW810+4/MnUzaLojut5fBt0Ox9vpxYKh5QDjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jonas Malaco <jonas@protocubo.io>
Subject: [PATCH 5.4 53/71] eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX
Date:   Mon, 14 Feb 2022 10:26:21 +0100
Message-Id: <20220214092453.828207928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Malaco <jonas@protocubo.io>

commit c0689e46be23160d925dca95dfc411f1a0462708 upstream.

Commit effa453168a7 ("i2c: i801: Don't silently correct invalid transfer
size") revealed that ee1004_eeprom_read() did not properly limit how
many bytes to read at once.

In particular, i2c_smbus_read_i2c_block_data_or_emulated() takes the
length to read as an u8.  If count == 256 after taking into account the
offset and page boundary, the cast to u8 overflows.  And this is common
when user space tries to read the entire EEPROM at once.

To fix it, limit each read to I2C_SMBUS_BLOCK_MAX (32) bytes, already
the maximum length i2c_smbus_read_i2c_block_data_or_emulated() allows.

Fixes: effa453168a7 ("i2c: i801: Don't silently correct invalid transfer size")
Cc: stable@vger.kernel.org
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jonas Malaco <jonas@protocubo.io>
Link: https://lore.kernel.org/r/20220203165024.47767-1-jonas@protocubo.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/ee1004.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/eeprom/ee1004.c
+++ b/drivers/misc/eeprom/ee1004.c
@@ -82,6 +82,9 @@ static ssize_t ee1004_eeprom_read(struct
 	if (unlikely(offset + count > EE1004_PAGE_SIZE))
 		count = EE1004_PAGE_SIZE - offset;
 
+	if (count > I2C_SMBUS_BLOCK_MAX)
+		count = I2C_SMBUS_BLOCK_MAX;
+
 	status = i2c_smbus_read_i2c_block_data_or_emulated(client, offset,
 							   count, buf);
 	dev_dbg(&client->dev, "read %zu@%d --> %d\n", count, offset, status);


