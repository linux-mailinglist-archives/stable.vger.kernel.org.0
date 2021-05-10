Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAB37839D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhEJKqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhEJKof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54E196195B;
        Mon, 10 May 2021 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642817;
        bh=gHK9z7jQUHKGMyq9Dk1nA6jlE7fCAzl1NO77XE5WdZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrTifn3DP0U3xSH07+v3ArBBAUnjyHtRJW4HyJ5kdMyRJOJcuiiiWGlZlFZprcshp
         mDtEdw/qsvbVIgAk76HaTNWD8x2HoZiEajuin+ECE25shNn2XtVHJyXAyyq4E2UVDb
         gL6MvN2uma9sP5QeRqvrOc7/v5Kt+pjEQyr+ho+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/299] usb: gadget: f_uac2: validate input parameters
Date:   Mon, 10 May 2021 12:17:40 +0200
Message-Id: <20210510102006.970567959@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

[ Upstream commit 3713d5ceb04d5ab6a5e2b86dfca49170053f3a5e ]

Currently user can configure UAC2 function with
parameters that violate UAC2 spec or are not supported
by UAC2 gadget implementation.

This can lead to incorrect behavior if such gadget
is connected to the host - like enumeration failure
or other issues depending on host's UAC2 driver
implementation, bringing user to a long hours
of debugging the issue.

Instead of silently accept these parameters, throw
an error if they are not valid.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-4-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 39 ++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 6f03e944e0e3..dd960cea642f 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -14,6 +14,9 @@
 #include "u_audio.h"
 #include "u_uac2.h"
 
+/* UAC2 spec: 4.1 Audio Channel Cluster Descriptor */
+#define UAC2_CHANNEL_MASK 0x07FFFFFF
+
 /*
  * The driver implements a simple UAC_2 topology.
  * USB-OUT -> IT_1 -> OT_3 -> ALSA_Capture
@@ -604,6 +607,36 @@ static void setup_descriptor(struct f_uac2_opts *opts)
 	hs_audio_desc[i] = NULL;
 }
 
+static int afunc_validate_opts(struct g_audio *agdev, struct device *dev)
+{
+	struct f_uac2_opts *opts = g_audio_to_uac2_opts(agdev);
+
+	if (!opts->p_chmask && !opts->c_chmask) {
+		dev_err(dev, "Error: no playback and capture channels\n");
+		return -EINVAL;
+	} else if (opts->p_chmask & ~UAC2_CHANNEL_MASK) {
+		dev_err(dev, "Error: unsupported playback channels mask\n");
+		return -EINVAL;
+	} else if (opts->c_chmask & ~UAC2_CHANNEL_MASK) {
+		dev_err(dev, "Error: unsupported capture channels mask\n");
+		return -EINVAL;
+	} else if ((opts->p_ssize < 1) || (opts->p_ssize > 4)) {
+		dev_err(dev, "Error: incorrect playback sample size\n");
+		return -EINVAL;
+	} else if ((opts->c_ssize < 1) || (opts->c_ssize > 4)) {
+		dev_err(dev, "Error: incorrect capture sample size\n");
+		return -EINVAL;
+	} else if (!opts->p_srate) {
+		dev_err(dev, "Error: incorrect playback sampling rate\n");
+		return -EINVAL;
+	} else if (!opts->c_srate) {
+		dev_err(dev, "Error: incorrect capture sampling rate\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 {
@@ -612,11 +645,13 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 	struct usb_composite_dev *cdev = cfg->cdev;
 	struct usb_gadget *gadget = cdev->gadget;
 	struct device *dev = &gadget->dev;
-	struct f_uac2_opts *uac2_opts;
+	struct f_uac2_opts *uac2_opts = g_audio_to_uac2_opts(agdev);
 	struct usb_string *us;
 	int ret;
 
-	uac2_opts = container_of(fn->fi, struct f_uac2_opts, func_inst);
+	ret = afunc_validate_opts(agdev, dev);
+	if (ret)
+		return ret;
 
 	us = usb_gstrings_attach(cdev, fn_strings, ARRAY_SIZE(strings_fn));
 	if (IS_ERR(us))
-- 
2.30.2



