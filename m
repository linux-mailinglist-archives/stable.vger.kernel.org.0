Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89FA60AB21
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiJXNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiJXNmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:42:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A35B6402;
        Mon, 24 Oct 2022 05:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742B9612E3;
        Mon, 24 Oct 2022 12:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F7C433D6;
        Mon, 24 Oct 2022 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614625;
        bh=CZYsMphJMpaNrKDew+OX76nRYFASQeGDTo1/8Np2474=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reOId/jhJT0uNI3zm+XUXLFy8mp4RpLB5OHaCIVsIHGnuM0ol5mcoLnUAd7XSLnf6
         +ZSC1e4vq/c+iyptYQK4OaJ/ticu+L/zgfGiGXfigSXlguHOhs8SYEuS904zoe3qxv
         5jF58WHoe2yBUXpAIQCMQQRGz3SWZ1GySM7Xv4V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Matuszczyk <maccraft123mc@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/390] drm: panel-orientation-quirks: Add quirk for Anbernic Win600
Date:   Mon, 24 Oct 2022 13:32:10 +0200
Message-Id: <20221024113037.180598584@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

From: Maya Matuszczyk <maccraft123mc@gmail.com>

[ Upstream commit 770e19076065e079a32f33eb11be2057c87f1cde ]

This device is another x86 gaming handheld, and as (hopefully) there is
only one set of DMI IDs it's using DMI_EXACT_MATCH

Signed-off-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220803182402.1217293-1-maccraft123mc@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f5ab891731d0..083273736c83 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -128,6 +128,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Anbernic Win600 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Anbernic"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Win600"),
+		},
+		.driver_data = (void *)&lcd720x1280_rightside_up,
 	}, {	/* Asus T100HA */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.35.1



