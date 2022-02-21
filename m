Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C824BE956
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiBUJuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352928AbiBUJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE42264;
        Mon, 21 Feb 2022 01:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0DA60EDF;
        Mon, 21 Feb 2022 09:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBE2C340EC;
        Mon, 21 Feb 2022 09:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435289;
        bh=0l6VWU+fCpdLger+iD1JWTeW8k6VwwchU0sRqFBp3no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4JU5to4MvLpoKdujMOXFclXFkjFmH38q0/HfLuEcJsCvZrnKDbZeZeUDPp82UjEK
         G2RE8SCfpEU6vZaqlsji25lCuaX2r+8ii02nzrR2A7AFSifibjtKH5/Jn/PQ8FNp/K
         YiaRH/EV//uv7wfubLIFwijaejM/Gx8cx82aw0sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Bishop <nicholasbishop@google.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 079/227] drm/radeon: Fix backlight control on iMac 12,1
Date:   Mon, 21 Feb 2022 09:48:18 +0100
Message-Id: <20220221084937.493672824@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Bishop <nicholasbishop@google.com>

commit 364438fd629f7611a84c8e6d7de91659300f1502 upstream.

The iMac 12,1 does not use the gmux driver for backlight, so the radeon
backlight device is needed to set the brightness.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1838
Signed-off-by: Nicholas Bishop <nicholasbishop@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -198,7 +198,8 @@ void radeon_atom_backlight_init(struct r
 	 * so don't register a backlight device
 	 */
 	if ((rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
-	    (rdev->pdev->device == 0x6741))
+	    (rdev->pdev->device == 0x6741) &&
+	    !dmi_match(DMI_PRODUCT_NAME, "iMac12,1"))
 		return;
 
 	if (!radeon_encoder->enc_priv)


