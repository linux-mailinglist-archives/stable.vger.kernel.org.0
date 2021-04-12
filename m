Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EFA35BF66
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhDLJGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238523AbhDLJCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E44261244;
        Mon, 12 Apr 2021 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218055;
        bh=AemVYUQYYDN1IfXCxWkhw0kUVwZhv3Usbs0TOhzwAVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IA/XCBZjaUta8joQD4Co0PLtD7RfiapYvsxQoL3uicTddhAHG5R+tS6+JdgJUHQFq
         rt3cidkQvsXhBefvGk3DoT1rul1CPLmPzQ3JXxmxXVa7NVgSG3xXY3+a5aQYOa42nY
         Oxd+s7hLIVX34aeYWC4bFuHaWXcz9MSfq+kbVSTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.11 019/210] drm/i915: Fix invalid access to ACPI _DSM objects
Date:   Mon, 12 Apr 2021 10:38:44 +0200
Message-Id: <20210412084016.652273106@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b6a37a93c9ac3900987c79b726d0bb3699d8db4e upstream.

intel_dsm_platform_mux_info() tries to parse the ACPI package data
from _DSM for the debug information, but it assumes the fixed format
without checking what values are stored in the elements actually.
When an unexpected value is returned from BIOS, it may lead to GPF or
NULL dereference, as reported recently.

Add the checks of the contents in the returned values and skip the
values for invalid cases.

v1->v2: Check the info contents before dereferencing, too

BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=1184074
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210402082317.871-1-tiwai@suse.de
(cherry picked from commit 337d7a1621c7f02af867229990ac67c97da1b53a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_acpi.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_acpi.c
+++ b/drivers/gpu/drm/i915/display/intel_acpi.c
@@ -84,13 +84,31 @@ static void intel_dsm_platform_mux_info(
 		return;
 	}
 
+	if (!pkg->package.count) {
+		DRM_DEBUG_DRIVER("no connection in _DSM\n");
+		return;
+	}
+
 	connector_count = &pkg->package.elements[0];
 	DRM_DEBUG_DRIVER("MUX info connectors: %lld\n",
 		  (unsigned long long)connector_count->integer.value);
 	for (i = 1; i < pkg->package.count; i++) {
 		union acpi_object *obj = &pkg->package.elements[i];
-		union acpi_object *connector_id = &obj->package.elements[0];
-		union acpi_object *info = &obj->package.elements[1];
+		union acpi_object *connector_id;
+		union acpi_object *info;
+
+		if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count < 2) {
+			DRM_DEBUG_DRIVER("Invalid object for MUX #%d\n", i);
+			continue;
+		}
+
+		connector_id = &obj->package.elements[0];
+		info = &obj->package.elements[1];
+		if (info->type != ACPI_TYPE_BUFFER || info->buffer.length < 4) {
+			DRM_DEBUG_DRIVER("Invalid info for MUX obj #%d\n", i);
+			continue;
+		}
+
 		DRM_DEBUG_DRIVER("Connector id: 0x%016llx\n",
 			  (unsigned long long)connector_id->integer.value);
 		DRM_DEBUG_DRIVER("  port id: %s\n",


