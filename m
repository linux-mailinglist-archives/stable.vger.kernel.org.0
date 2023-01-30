Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76521681104
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjA3OJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbjA3OJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1CE3B0EE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 320A2B8117B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB45C433EF;
        Mon, 30 Jan 2023 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087773;
        bh=22vqKdte5+ZuoITYXeS0JfPR8v7M/2G5VV2jnLBEAhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryjP8mhiVzrqaicJ6P67jk97frgd5z1wf605ioMm6vkGJTlE6uTWNRFU0FN1vuaks
         dNvredZbv+v1Y+B1EjqfKB5f802c+tC56ArqRT3xC41nAP+m6ERSs9XDBEm99oZ8OR
         ssghkPuc7wWyq9X9p5adUkcMKYKQPs/+pAss9Z3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 305/313] Input: i8042 - add Clevo PCX0DX to i8042 quirk table
Date:   Mon, 30 Jan 2023 14:52:20 +0100
Message-Id: <20230130134350.952521547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9c445d2637c938a800fcc8b5f0b10e60c94460c7 upstream.

The Clevo PCX0DX/TUXEDO XP1511, need quirks for the keyboard to not be
occasionally unresponsive after resume.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20230110134524.553620-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1240,6 +1240,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PCX0DX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "X170SM"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


