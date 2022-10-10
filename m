Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2E45F9912
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJJHGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiJJHFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89924631E;
        Mon, 10 Oct 2022 00:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E13260E8D;
        Mon, 10 Oct 2022 07:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543CEC433D6;
        Mon, 10 Oct 2022 07:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385482;
        bh=Jq8qMOMnQ5EYQxwRItUaZQpYLQUALXFqrahrT5nE/nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wivghXBt3Z3xCsTW92eiq2xH5FXOuAQZqnutUAJ4QdKThlW45KNlxMT1TBQXItOxY
         mtiUMb2/TsOZRS9/cnVqOzVL8Q5hO2LDlYQWBR8h7PT6t7BdM37S2nCHScXF9A6Q0V
         T2txNCbUTahGFz7o6BTj5JHRPzyd0O7TEpxqXS7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Savic <savicaleksa83@gmail.com>,
        stable@vger.kenrel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.0 08/17] hwmon: (aquacomputer_d5next) Fix Quadro fan speed offsets
Date:   Mon, 10 Oct 2022 09:04:31 +0200
Message-Id: <20221010070330.443889502@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
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

From: Aleksa Savic <savicaleksa83@gmail.com>

commit b7f3e9650f12d1e06b94a0257bcb90279f691bf5 upstream.

The offsets for setting speeds of fans connected to Quadro are off by one.
Set them to their correct values.

The offsets as shown point to registers for setting the fan control mode,
which will be explored in future patches, but slipped in here. When
setting fan speeds, the resulting values were overlapping, which made the
fans still run in my initial testing.

Fixes: cdbe34da01e3 ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer Quadro fan controller")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Link: https://lore.kernel.org/r/20220914114327.6941-1-savicaleksa83@gmail.com
Cc: stable@vger.kenrel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aquacomputer_d5next.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -110,7 +110,7 @@ static u16 octo_ctrl_fan_offsets[] = { 0
 static u8 quadro_sensor_fan_offsets[] = { 0x70, 0x7D, 0x8A, 0x97 };
 
 /* Fan speed registers in Quadro control report (from 0-100%) */
-static u16 quadro_ctrl_fan_offsets[] = { 0x36, 0x8b, 0xe0, 0x135 };
+static u16 quadro_ctrl_fan_offsets[] = { 0x37, 0x8c, 0xe1, 0x136 };
 
 /* Labels for D5 Next */
 static const char *const label_d5next_temp[] = {


