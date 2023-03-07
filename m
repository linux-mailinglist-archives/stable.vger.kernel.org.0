Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80C6AEB8D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjCGRp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjCGRpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82CA9AA2E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2677561514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3383BC433D2;
        Tue,  7 Mar 2023 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210835;
        bh=wMi2a0WKqUldrCc+nA+LrQqr1QiIr01Eud08unr5RWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zj6XvwrnGmkDzsPl6d0bBXcNyhiC22eOxLWbQO7OxRDrF70tTwiuz/nUdNno4DSeb
         avMeL6KuJ5+esKAz8ipT3L4iyvH4nZrBCFXd5o6Se5B2pXBOfjWNbBOFkJUix9jhSI
         DYBSyQr0YjFsAsgcb1KO78SWwNBxi6YCUVEiasmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0670/1001] ACPI: video: Fix Lenovo Ideapad Z570 DMI match
Date:   Tue,  7 Mar 2023 17:57:22 +0100
Message-Id: <20230307170050.677588586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2d11eae42d52a131f06061015e49dc0f085c5bfc ]

Multiple Ideapad Z570 variants need acpi_backlight=native to force native
use on these pre Windows 8 machines since acpi_video backlight control
does not work here.

The original DMI quirk matches on a product_name of "102434U" but other
variants may have different product_name-s such as e.g. "1024D9U".

Move to checking product_version instead as is more or less standard for
Lenovo DMI quirks for similar reasons.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index a8c02608dde45..710ac640267dd 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -434,7 +434,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 /* Lenovo Ideapad Z570 */
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
-- 
2.39.2



