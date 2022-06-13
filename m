Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157665492DE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351015AbiFMLFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351752AbiFMLE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:04:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B3A32EE8;
        Mon, 13 Jun 2022 03:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C0D160FC9;
        Mon, 13 Jun 2022 10:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFDBC34114;
        Mon, 13 Jun 2022 10:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116434;
        bh=EAB0sFpBWApDmm/5hoRD6cLlg+kbsbnjhf66J8G8h6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aWv868ZVwCodcmFJOG0rsJdAA4IlmbGTQkIcN9H3INrvBqYUHAnvaX5jA0iIjNu+
         OE11qaha1Pb6l+1+jCxuHBLgMhXrEgoasIvO7gcquTKgd7LDzATviZyEzpNSSbcI4a
         Rx9GiCBq8Lq3X0LK7xcRPa7dEsLdR3baWisGUOng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/411] drm/edid: fix invalid EDID extension block filtering
Date:   Mon, 13 Jun 2022 12:05:55 +0200
Message-Id: <20220613094931.140199973@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index aeeab1b57aad..2dc6dd6230d7 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1702,9 +1702,6 @@ struct edid *drm_do_get_edid(struct drm_connector *connector,
 
 		connector_bad_edid(connector, edid, edid[0x7e] + 1);
 
-		edid[EDID_LENGTH-1] += edid[0x7e] - valid_extensions;
-		edid[0x7e] = valid_extensions;
-
 		new = kmalloc_array(valid_extensions + 1, EDID_LENGTH,
 				    GFP_KERNEL);
 		if (!new)
@@ -1721,6 +1718,9 @@ struct edid *drm_do_get_edid(struct drm_connector *connector,
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



