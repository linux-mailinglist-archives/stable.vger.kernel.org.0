Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DD96B45BF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjCJOgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbjCJOgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:36:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B3011C8C1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7430861965
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DEAC4339B;
        Fri, 10 Mar 2023 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458977;
        bh=5nBtOqBX7CELuTjsU21MbpUa4HYnMjtHkG7giifslIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sezu0hBXOAiejCGWPfc2Q1sX9AKdKapS5lOJV2iDzVlDE9nUCVXTe7tKhRJFmjyUE
         d259N7o8yhzRk7CmWUB4cfn9d79rV9x6met++Hh15b358hggSnuggzdbeWx4sO+zuc
         4e5TvB+87TiFBIbzuTcFsVgX4Om+OTDmUSOdCt5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Darrell Kavanagh <darrell.kavanagh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/357] drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5
Date:   Fri, 10 Mar 2023 14:38:16 +0100
Message-Id: <20230310133743.842176978@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Darrell Kavanagh <darrell.kavanagh@gmail.com>

[ Upstream commit 38b2d8efd03d2e56431b611e3523f0158306451d ]

Another Lenovo convertable where the panel is installed landscape but is
reported to the kernel as portrait.

Signed-off-by: Darrell Kavanagh <darrell.kavanagh@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230214164659.3583-1-darrell.kavanagh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index ce739ba45c551..8768073794fbf 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -278,6 +278,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Lenovo IdeaPad Duet 3 10IGL5 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
 		.matches = {
 		  /* Non exact match to match all versions */
-- 
2.39.2



