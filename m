Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576D76AEE1A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjCGSJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjCGSJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF48185A5E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B33EB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7662CC433D2;
        Tue,  7 Mar 2023 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211884;
        bh=NlbxwG6eUCX4juJ50RjoPsRPj/g18EsVLrVnO1RNEic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbEYZdHIOtHOv3gCvo2VAZYeZGanyJSOh2b32JoKjpkzOo09wUef/ivtx/UF2HTn4
         LOtzg/CQ7l7rWUf2RXbtqigbIC1gzsucIkbZ6nWEny90TCVKm2BJBPfK+Xgi7a++1I
         Et1c1nZqvzVjjLbeU3HWa1IFP66aGoY70YMswyQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 1001/1001] drm/edid: fix parsing of 3D modes from HDMI VSDB
Date:   Tue,  7 Mar 2023 18:02:53 +0100
Message-Id: <20230307170105.748347529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 72794d16bd535a984e6653a18f5862405b49b5f9 upstream.

Commit 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db
iter") inadvertently moved the do_hdmi_vsdb_modes() call within the db
iteration loop, always passing NULL as the CTA VDB to
do_hdmi_vsdb_modes(), skipping a lot of stereo modes.

Move the call back outside of the loop.

This does mean only one CTA VDB and HDMI VSDB combination will be
handled, but it's an unlikely scenario to have more than one of either
block, and it was not accounted for before the regression either.

Fixes: 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db iter")
Cc: <stable@vger.kernel.org> # v6.0+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/cf159b8816191ed595a3cb954acaf189c4528cc7.1672826282.git.jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5249,13 +5249,12 @@ static int add_cea_modes(struct drm_conn
 {
 	const struct cea_db *db;
 	struct cea_db_iter iter;
+	const u8 *hdmi = NULL, *video = NULL;
+	u8 hdmi_len = 0, video_len = 0;
 	int modes = 0;
 
 	cea_db_iter_edid_begin(drm_edid, &iter);
 	cea_db_iter_for_each(db, &iter) {
-		const u8 *hdmi = NULL, *video = NULL;
-		u8 hdmi_len = 0, video_len = 0;
-
 		if (cea_db_tag(db) == CTA_DB_VIDEO) {
 			video = cea_db_data(db);
 			video_len = cea_db_payload_len(db);
@@ -5271,18 +5270,17 @@ static int add_cea_modes(struct drm_conn
 			modes += do_y420vdb_modes(connector, vdb420,
 						  cea_db_payload_len(db) - 1);
 		}
-
-		/*
-		 * We parse the HDMI VSDB after having added the cea modes as we
-		 * will be patching their flags when the sink supports stereo
-		 * 3D.
-		 */
-		if (hdmi)
-			modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
-						    video, video_len);
 	}
 	cea_db_iter_end(&iter);
 
+	/*
+	 * We parse the HDMI VSDB after having added the cea modes as we will be
+	 * patching their flags when the sink supports stereo 3D.
+	 */
+	if (hdmi)
+		modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
+					    video, video_len);
+
 	return modes;
 }
 


