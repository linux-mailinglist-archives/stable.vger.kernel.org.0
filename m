Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAA864FA17
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLQP3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLQP2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:28:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC802164AC;
        Sat, 17 Dec 2022 07:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F92460C14;
        Sat, 17 Dec 2022 15:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4FCC433F2;
        Sat, 17 Dec 2022 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290869;
        bh=0Dowszw+M3xbVXpxd9r+vcp2wE7GhUHIdP1j3o9nBQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj8n2IUs6gvPSj28oqzUlO4fRewyRBox5VjKsJRvLr/pjaxiF/hRHosNuhKFdosvQ
         yW3ULnBxzV72egnLMincmLLF9KA7rJi9sLNUm6jwG70hlDMU6v+3TCNXEc/uzMRsdD
         q+RvkqUx7n9VyqakzrzEZb5SLZdvorJqCiVcSkbR5Q+9yElxHw5frWfqng9/rjwiJg
         fvw+eHCSl/GYSR6Iu/8SQ7aT52IbyXz77HF8qgoOd7DZXvJmd1pdjlCB//YZoSypIY
         /LYN2BF5uncQSQqV4SXBsMUc9vt+UfCMy3hbr56j2vMWxc2k9eDSV7WAvgQPK+fQi6
         vqvJoAPGq5K1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Stefan Joosten <stefan@atcomputing.nl>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/22] ACPI: video: Add force_native quirk for Sony Vaio VPCY11S1E
Date:   Sat, 17 Dec 2022 10:27:13 -0500
Message-Id: <20221217152727.98061-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit f5a6ff923d4a1d639da36228d00e95ff67d417f0 ]

The Sony Vaio VPCY11S1E advertises both native and ACPI video backlight
control interfaces, but only the native interface works and the default
heuristics end up picking ACPI video on this model.

Add a video_detect_force_native DMI quirk for this.

Reported-by: Stefan Joosten <stefan@atcomputing.nl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 8e8b435b4c8c..ffa19d418847 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -619,6 +619,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Sony Vaio VPCY11S1E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCY11S1E"),
+		},
+	},
 
 	/*
 	 * These Toshibas have a broken acpi-video interface for brightness
-- 
2.35.1

