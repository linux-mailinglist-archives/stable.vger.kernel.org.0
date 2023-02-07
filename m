Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D84368D7D2
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBGNDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjBGND3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3380D7D8F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C350661358
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7124C433D2;
        Tue,  7 Feb 2023 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775007;
        bh=fr2XPEu3yfYvYpqkODr4s7iX4TyA41IU475et1m4cf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWvAx38NhCjR/bpe3PXeU+A5w4QPLPWVW2KZfMF5ytc41Rt0Qpiw4qzhqkdQJQlT2
         0kvkq8V33t5Qt8JAWTow/A3YwqIltaF7vHxk+VvGyt3HNRfLWUYguyz01MtZ+NzDTe
         Pw0T5IXuTKpA0TCY6BXPUYFLh+oDj9ggwze/FMbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kevin Kuriakose <kevinmkuriakose@gmail.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/208] platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF
Date:   Tue,  7 Feb 2023 13:56:00 +0100
Message-Id: <20230207125639.154672683@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Kevin Kuriakose <kevinmkuriakose@gmail.com>

[ Upstream commit a410429a3b7e748a9db9f357e71e2e085a21c902 ]

To the best of my knowledge this is the same board as the B450M DS3H-CF,
but with an added WiFi card. Name obtained using dmidecode, tested
with force_load on v6.1.6

Signed-off-by: Kevin Kuriakose <kevinmkuriakose@gmail.com>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230119150925.31962-1-kevinmkuriakose@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 5e7e6659a849..322cfaeda17b 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
-- 
2.39.0



