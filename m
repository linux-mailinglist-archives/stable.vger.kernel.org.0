Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF260A447
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiJXMH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiJXMFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB627D780;
        Mon, 24 Oct 2022 04:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9014E612BB;
        Mon, 24 Oct 2022 11:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54F5C433D6;
        Mon, 24 Oct 2022 11:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612287;
        bh=8veHvggDsF0H695N4ZaRHLld1XJTkiSOIyJfY6Uu+i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbcjQWI7IiQj4m55vOPeE3ZFPsHEB5jYgXE8JWdmD6v7ssDUu63kmo+K3KZT9J9Ti
         +4CHlDxL6/mAnBLm8Vwy4sOB7BCzcglTNmDHHkyyTN6Dp+kO8BxZP/mF5Q8eS5AGUw
         XYLqVRdcbFbovmF27OXbM3iye/NciAJdKl8aQpKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/210] platform/x86: msi-laptop: Fix old-ec check for backlight registering
Date:   Mon, 24 Oct 2022 13:30:16 +0200
Message-Id: <20221024113000.237096348@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 83ac7a1c2ed5f17caa07cbbc84bad3c05dc3bf22 ]

Commit 2cc6c717799f ("msi-laptop: Port to new backlight interface
selection API") replaced this check:

	if (!quirks->old_ec_model || acpi_video_backlight_support())
		pr_info("Brightness ignored, ...");
	else
		do_register();

With:

	if (quirks->old_ec_model ||
	    acpi_video_get_backlight_type() == acpi_backlight_vendor)
		do_register();

But since the do_register() part was part of the else branch, the entire
condition should be inverted.  So not only the 2 statements on either
side of the || should be inverted, but the || itself should be replaced
with a &&.

In practice this has likely not been an issue because the new-ec models
(old_ec_model==false) likely all support ACPI video backlight control,
making acpi_video_get_backlight_type() return acpi_backlight_video
turning the second part of the || also false when old_ec_model == false.

Fixes: 2cc6c717799f ("msi-laptop: Port to new backlight interface selection API")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220825141336.208597-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-laptop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index d5bfcc602090..7279390a2d54 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -1061,8 +1061,7 @@ static int __init msi_init(void)
 		return -EINVAL;
 
 	/* Register backlight stuff */
-
-	if (quirks->old_ec_model ||
+	if (quirks->old_ec_model &&
 	    acpi_video_get_backlight_type() == acpi_backlight_vendor) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
-- 
2.35.1



