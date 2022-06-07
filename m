Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BFA541970
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377982AbiFGVWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380908AbiFGVRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DF721FBFF;
        Tue,  7 Jun 2022 11:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52523617DA;
        Tue,  7 Jun 2022 18:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620AFC385A2;
        Tue,  7 Jun 2022 18:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628283;
        bh=iOb0nUWMNLkduNeH44/8s0eyZ5TAcg1492StEU120iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SICEqomvNZa0SqCfmfKaRBZve9/LNvmxP+7stDvlWjbZ/W3VgQrZCgt7CljKHUn8J
         tnN/gw3H12wCViVmEaXkRHwAV5Z2FB0JUuAgaRsb6GGqGK2VbyVDGtz+7Qc8Kg4P7f
         Mlrd/y2MEZaHD8tjKX8HWvIUkQKchihxLYPU8XNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 272/879] drm/edid: fix invalid EDID extension block filtering
Date:   Tue,  7 Jun 2022 18:56:30 +0200
Message-Id: <20220607165010.745218657@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 3aefc722ff52076407203b6af9713de567993adf ]

The invalid EDID block filtering uses the number of valid EDID
extensions instead of all EDID extensions for looping the extensions in
the copy. This is fine, by coincidence, if all the invalid blocks are at
the end of the EDID. However, it's completely broken if there are
invalid extensions in the middle; the invalid blocks are included and
valid blocks are excluded.

Fix it by modifying the base block after, not before, the copy.

Fixes: 14544d0937bf ("drm/edid: Only print the bad edid when aborting")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220330170426.349248-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index cc7bd58369df..c5b86414873e 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2031,9 +2031,6 @@ struct edid *drm_do_get_edid(struct drm_connector *connector,
 
 		connector_bad_edid(connector, edid, edid[0x7e] + 1);
 
-		edid[EDID_LENGTH-1] += edid[0x7e] - valid_extensions;
-		edid[0x7e] = valid_extensions;
-
 		new = kmalloc_array(valid_extensions + 1, EDID_LENGTH,
 				    GFP_KERNEL);
 		if (!new)
@@ -2050,6 +2047,9 @@ struct edid *drm_do_get_edid(struct drm_connector *connector,
 			base += EDID_LENGTH;
 		}
 
+		new[EDID_LENGTH - 1] += new[0x7e] - valid_extensions;
+		new[0x7e] = valid_extensions;
+
 		kfree(edid);
 		edid = new;
 	}
-- 
2.35.1



