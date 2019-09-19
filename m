Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AF3B7A78
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 15:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbfISN27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 09:28:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:28045 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388551AbfISN27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 09:28:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 06:28:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,523,1559545200"; 
   d="scan'208";a="199392042"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga002.jf.intel.com with SMTP; 19 Sep 2019 06:28:54 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 19 Sep 2019 16:28:53 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        linux-media@vger.kernel.org, Martin Bugge <marbugge@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thierry Reding <treding@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] video/hdmi: Fix AVI bar unpack
Date:   Thu, 19 Sep 2019 16:28:53 +0300
Message-Id: <20190919132853.30954-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The bar values are little endian, not big endian. The pack
function did it right but the unpack got it wrong. Fix it.

Cc: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Fixes: 2c676f378edb ("[media] hdmi: added unpack and logging functions for InfoFrames")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/video/hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index b939bc28d886..9c82e2a0a411 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -1576,12 +1576,12 @@ static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
 	if (ptr[0] & 0x10)
 		frame->active_aspect = ptr[1] & 0xf;
 	if (ptr[0] & 0x8) {
-		frame->top_bar = (ptr[5] << 8) + ptr[6];
-		frame->bottom_bar = (ptr[7] << 8) + ptr[8];
+		frame->top_bar = (ptr[6] << 8) | ptr[5];
+		frame->bottom_bar = (ptr[8] << 8) | ptr[7];
 	}
 	if (ptr[0] & 0x4) {
-		frame->left_bar = (ptr[9] << 8) + ptr[10];
-		frame->right_bar = (ptr[11] << 8) + ptr[12];
+		frame->left_bar = (ptr[10] << 8) | ptr[9];
+		frame->right_bar = (ptr[12] << 8) | ptr[11];
 	}
 	frame->scan_mode = ptr[0] & 0x3;
 
-- 
2.21.0

