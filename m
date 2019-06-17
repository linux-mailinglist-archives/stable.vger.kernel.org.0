Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FD949403
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfFQVXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbfFQVXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 971D020673;
        Mon, 17 Jun 2019 21:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806612;
        bh=ZZUzArcMjzp1ZUoNgnxq5kYOqQFnQ8BS0bQB27xlweo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkmLtrOv7sPlqIui+q2loCKA/Fo3mDnskahn8sYcFj4Jn+xNW5SE50EPBe7Z2LhDu
         Ob2HEPq8MsJf9mCcaA6Fc1T7E4swZ/wpZthW7uaLiNjSb6UOmkZQtURdX5inoLApVW
         Daaoc7UTH+0Z45FOoVUmNYMybtwVzrIl9xVlcARI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Harish Chegondi <harish.chegondi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Tested-by: Paul Wise" <pabs3@bonedaddy.net>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.1 112/115] drm/edid: abstract override/firmware EDID retrieval
Date:   Mon, 17 Jun 2019 23:10:12 +0200
Message-Id: <20190617210805.590671194@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 56a2b7f2a39a8d4b16a628e113decde3d7400879 upstream.

Abstract the debugfs override and the firmware EDID retrieval
function. We'll be needing it in the follow-up. No functional changes.

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Harish Chegondi <harish.chegondi@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Tested-by: Paul Wise <pabs3@bonedaddy.net>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190607110513.12072-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1580,6 +1580,20 @@ static void connector_bad_edid(struct dr
 	}
 }
 
+/* Get override or firmware EDID */
+static struct edid *drm_get_override_edid(struct drm_connector *connector)
+{
+	struct edid *override = NULL;
+
+	if (connector->override_edid)
+		override = drm_edid_duplicate(connector->edid_blob_ptr->data);
+
+	if (!override)
+		override = drm_load_edid_firmware(connector);
+
+	return IS_ERR(override) ? NULL : override;
+}
+
 /**
  * drm_do_get_edid - get EDID data using a custom EDID block read function
  * @connector: connector we're probing
@@ -1607,15 +1621,10 @@ struct edid *drm_do_get_edid(struct drm_
 {
 	int i, j = 0, valid_extensions = 0;
 	u8 *edid, *new;
-	struct edid *override = NULL;
-
-	if (connector->override_edid)
-		override = drm_edid_duplicate(connector->edid_blob_ptr->data);
-
-	if (!override)
-		override = drm_load_edid_firmware(connector);
+	struct edid *override;
 
-	if (!IS_ERR_OR_NULL(override))
+	override = drm_get_override_edid(connector);
+	if (override)
 		return override;
 
 	if ((edid = kmalloc(EDID_LENGTH, GFP_KERNEL)) == NULL)


