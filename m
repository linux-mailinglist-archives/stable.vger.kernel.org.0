Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC3D69CD31
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjBTNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjBTNrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:47:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E0B1E1EC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FB64B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2964C433D2;
        Mon, 20 Feb 2023 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900822;
        bh=ep643o6owxTcqb5col+8TTJuDH0Kmi1U8qOUMaF+nCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcUtsNO6sJ0xUdJ10UVSZb2hBcmu+8JaomorGWcxWjhYkTnX8LMExAZ5PEQFs7PQY
         6npM1H5WeFhHIcltcNvJBzucOdaLhp+qalqa7c1d+FdQ3aAISeaykDgfJFh/GR+Z4z
         9PYrPRh5bHr6lMJQaJkm0qqvl0hKrNAjOztG1qek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        Mark Pearson <mpearson-lenovo@squebb.ca>
Subject: [PATCH 5.4 081/156] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Date:   Mon, 20 Feb 2023 14:35:25 +0100
Message-Id: <20230220133605.797468693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit 303e724d7b1e1a0a93daf0b1ab5f7c4f53543b34 upstream.

The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
doesn't work. If LPM is enabled the reader will provide an invalid
usb config descriptor. Added quirk to disable LPM.

Verified fix on Lenovo P16 G1 and T14 G3

Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230208181223.1092654-1-mpearson-lenovo@squebb.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -527,6 +527,9 @@ static const struct usb_device_id usb_qu
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


