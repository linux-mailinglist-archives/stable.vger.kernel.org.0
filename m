Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D386BB2D2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjCOMi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjCOMih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE56A2C08
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B96061CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F8BC433D2;
        Wed, 15 Mar 2023 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883857;
        bh=fioF359d8FJ067o9MJKO9N/YlzuEa6BbcD88fm+/4P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5ev37QBIloNNFERMHq0gDadf0VuMouLnASpJd+UVGIRI4VNFUZeIplhkhKRvYZYh
         CDPSjnYUifgkrd+BRVHpJqTfYOfxe9GvDP0xf+L6RBWOhS7vt+ROZ5oIKb1bSEv6T3
         S4v6jG5UFDEy8+0zyHDasz7+gaynMB8zRYki1x4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Vitaly.Prosyak@amd.com, Uma Shankar <uma.shankar@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Joshua Ashton <joshua@froggi.es>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 015/141] drm/display: Dont block HDR_OUTPUT_METADATA on unknown EOTF
Date:   Wed, 15 Mar 2023 13:11:58 +0100
Message-Id: <20230315115740.452098505@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit e5eef23e267c72521d81f23f7f82d1f523d4a253 upstream.

The EDID of an HDR display defines EOTFs that are supported
by the display and can be set in the HDR metadata infoframe.
Userspace is expected to read the EDID and set an appropriate
HDR_OUTPUT_METADATA.

In drm_parse_hdr_metadata_block the kernel reads the supported
EOTFs from the EDID and stores them in the
drm_connector->hdr_sink_metadata. While doing so it also
filters the EOTFs to the EOTFs the kernel knows about.
When an HDR_OUTPUT_METADATA is set it then checks to
make sure the EOTF is a supported EOTF. In cases where
the kernel doesn't know about a new EOTF this check will
fail, even if the EDID advertises support.

Since it is expected that userspace reads the EDID to understand
what the display supports it doesn't make sense for DRM to block
an HDR_OUTPUT_METADATA if it contains an EOTF the kernel doesn't
understand.

This comes with the added benefit of future-proofing metadata
support. If the spec defines a new EOTF there is no need to
update DRM and an compositor can immediately make use of it.

Bug: https://gitlab.freedesktop.org/wayland/weston/-/issues/609

v2: Distinguish EOTFs defind in kernel and ones defined
    in EDID in the commit description (Pekka)

v3: Rebase; drm_hdmi_infoframe_set_hdr_metadata moved
    to drm_hdmi_helper.c

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Sebastian Wick <sebastian.wick@redhat.com>
Cc: Vitaly.Prosyak@amd.com
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Joshua Ashton <joshua@froggi.es>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Reviewed-By: Joshua Ashton <joshua@froggi.es>
Link: https://patchwork.freedesktop.org/patch/msgid/20230113162428.33874-2-harry.wentland@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_hdmi_helper.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/display/drm_hdmi_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_helper.c
@@ -44,10 +44,8 @@ int drm_hdmi_infoframe_set_hdr_metadata(
 
 	/* Sink EOTF is Bit map while infoframe is absolute values */
 	if (!is_eotf_supported(hdr_metadata->hdmi_metadata_type1.eotf,
-	    connector->hdr_sink_metadata.hdmi_type1.eotf)) {
-		DRM_DEBUG_KMS("EOTF Not Supported\n");
-		return -EINVAL;
-	}
+	    connector->hdr_sink_metadata.hdmi_type1.eotf))
+		DRM_DEBUG_KMS("Unknown EOTF %d\n", hdr_metadata->hdmi_metadata_type1.eotf);
 
 	err = hdmi_drm_infoframe_init(frame);
 	if (err < 0)


