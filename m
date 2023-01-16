Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0032966C580
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjAPQG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjAPQGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E84925E06
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C25C3B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABC8C433D2;
        Mon, 16 Jan 2023 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885081;
        bh=cDCDn0yEcA74wtNVKBqIHMJ71cFXTL7g1ZbRku/yda4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlWjxUhLRT8FA3yElq9U5vbCuQ2SIO0lYpDj9MIL1reSFenhIUh3RyF67pHIFYzt2
         3AcS1oqKEP8rmQhGAYi8hSF07LxmUi5TQMHwiGXsqBDFeCisEEafL19MnSRt1MSlu9
         zPdrLvXfAJKnGGAp7H/aCD7ZB+MNUKufqr+BjQiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 28/86] platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]
Date:   Mon, 16 Jan 2023 16:51:02 +0100
Message-Id: <20230116154748.278872635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit f4b7f8febd4d9b615fbec2a06bf352b9c3729b11 upstream.

The Lenovo Legion 5 15ARH05 needs ideapad-laptop to call SALS_FNLOCK_ON /
SALS_FNLOCK_OFF on Fn-lock state change to get the LED in the Fn key to
correctly reflect the Fn-lock state.

Add a DMI match for the Legion 5 15ARH05 to the set_fn_lock_led_list[]
table for this.

Fixes: 81a5603a0f50 ("platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221215154357.123876-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1493,6 +1493,12 @@ static const struct dmi_system_id set_fn
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion R7000P2020H"),
 		}
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion 5 15ARH05"),
+		}
+	},
 	{}
 };
 


