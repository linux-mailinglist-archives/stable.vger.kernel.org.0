Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF3548EFC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349261AbiFMK5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbiFMKyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3C5E019;
        Mon, 13 Jun 2022 03:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F6AB80E90;
        Mon, 13 Jun 2022 10:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0ABC34114;
        Mon, 13 Jun 2022 10:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116173;
        bh=cefGdlLahZht4DCk4W/uEms6OKiLdtZrYlYbfZNw/Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5lXW9WNcnv4GSRgoCD8YSXcd0jRiZJkAZA8TuSA+DWqnh8gl+9xKNdntjtgwoIk4
         bYaiW5gqCTIrYzXuQziMPISmwxnh+tQre5HGsuSm3u301/DXw9vHQ4V5H5S9Z8JbzY
         duaoodvrLWdXbCoyse1IvuNGQeJvKu+RNbB7tTio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Niels Dossche <dossche.niels@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 144/218] usb: usbip: add missing device lock on tweak configuration cmd
Date:   Mon, 13 Jun 2022 12:10:02 +0200
Message-Id: <20220613094924.957242447@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit d088fabace2ca337b275d1d4b36db4fe7771e44f ]

The function documentation of usb_set_configuration says that its
callers should hold the device lock. This lock is held for all
callsites except tweak_set_configuration_cmd. The code path can be
executed for example when attaching a remote USB device.
The solution is to surround the call by the device lock.

This bug was found using my experimental own-developed static analysis
tool, which reported the missing lock on v5.17.2. I manually verified
this bug report by doing code review as well. I runtime checked that
the required lock is not held. I compiled and runtime tested this on
x86_64 with a USB mouse. After applying this patch, my analyser no
longer reports this potential bug.

Fixes: 2c8c98158946 ("staging: usbip: let client choose device configuration")
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Link: https://lore.kernel.org/r/20220412165055.257113-1-dossche.niels@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/stub_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index cb24b22252e4..bf4a6dca95c6 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -152,7 +152,9 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 	config = le16_to_cpu(req->wValue);
 
+	usb_lock_device(sdev->udev);
 	err = usb_set_configuration(sdev->udev, config);
+	usb_unlock_device(sdev->udev);
 	if (err && err != -ENODEV)
 		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
 			config, err);
-- 
2.35.1



