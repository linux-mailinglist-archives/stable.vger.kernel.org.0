Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1927C7952D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbfG2Tjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388715AbfG2Tje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:39:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBDB206DD;
        Mon, 29 Jul 2019 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429173;
        bh=GPZWIZ0GW9VQNZManbtyg9SbsNsyMGSocdRZIBblNWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWAI0BkL0KYv1y9hkrdDa7hpwpc+xCmgS4Pa8chSARly357LcwsPzCqZvi0gb7e9E
         4Dv8NA/DtafBmXHWDQdp91UuCkepsHWSATGmDwQx/exirVpQJpdMT0La5K9vhD+4Wn
         fNQ+t+tCpjvzS3xKCp+Ht7yBm5AxI80LgMvifY54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/113] drm/edid: Fix a missing-check bug in drm_load_edid_firmware()
Date:   Mon, 29 Jul 2019 21:21:42 +0200
Message-Id: <20190729190659.425633645@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9f1f1a2dab38d4ce87a13565cf4dc1b73bef3a5f ]

In drm_load_edid_firmware(), fwstr is allocated by kstrdup(). And fwstr
is dereferenced in the following codes. However, memory allocation
functions such as kstrdup() may fail and returns NULL. Dereferencing
this null pointer may cause the kernel go wrong. Thus we should check
this kstrdup() operation.
Further, if kstrdup() returns NULL, we should return ERR_PTR(-ENOMEM) to
the caller site.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524023222.GA5302@zhanggen-UX430UQ
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid_load.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index a4915099aaa9..a0e107abc40d 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -290,6 +290,8 @@ struct edid *drm_load_edid_firmware(struct drm_connector *connector)
 	 * the last one found one as a fallback.
 	 */
 	fwstr = kstrdup(edid_firmware, GFP_KERNEL);
+	if (!fwstr)
+		return ERR_PTR(-ENOMEM);
 	edidstr = fwstr;
 
 	while ((edidname = strsep(&edidstr, ","))) {
-- 
2.20.1



