Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434E1F6B5A
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgFKPqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:46:01 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51072 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbgFKPqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:46:00 -0400
Received: from localhost.localdomain (p200300cb871f5b00895b3f12fcab1eee.dip0.t-ipconnect.de [IPv6:2003:cb:871f:5b00:895b:3f12:fcab:1eee])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dafna)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id C469E2A5098;
        Thu, 11 Jun 2020 16:45:58 +0100 (BST)
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
To:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc:     dafna.hirschfeld@collabora.com, helen.koike@collabora.com,
        ezequiel@collabora.com, hverkuil@xs4all.nl, kernel@collabora.com,
        dafna3@gmail.com, sakari.ailus@linux.intel.com,
        linux-rockchip@lists.infradead.org, mchehab@kernel.org,
        tfiga@chromium.org, stable@vger.kernel.org
Subject: [RESEND PATCH v3 1/6] media: staging: rkisp1: rsz: supported formats are the isp's src formats, not sink formats
Date:   Thu, 11 Jun 2020 17:45:46 +0200
Message-Id: <20200611154551.25022-2-dafna.hirschfeld@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
References: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rkisp1_resizer's enum callback 'rkisp1_rsz_enum_mbus_code'
calls the enum callback of the 'rkisp1_isp' on it's video sink pad.
This is a bug, the resizer should support the same formats
supported by the 'rkisp1_isp' on the source pad (not the sink pad).

Fixes: 56e3b29f9f6b "media: staging: rkisp1: add streaming paths"

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/staging/media/rkisp1/rkisp1-resizer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
index d049374413dc..d64c064bdb1d 100644
--- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
+++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
@@ -437,8 +437,8 @@ static int rkisp1_rsz_enum_mbus_code(struct v4l2_subdev *sd,
 	u32 pad = code->pad;
 	int ret;
 
-	/* supported mbus codes are the same in isp sink pad */
-	code->pad = RKISP1_ISP_PAD_SINK_VIDEO;
+	/* supported mbus codes are the same in isp video src pad */
+	code->pad = RKISP1_ISP_PAD_SOURCE_VIDEO;
 	ret = v4l2_subdev_call(&rsz->rkisp1->isp.sd, pad, enum_mbus_code,
 			       &dummy_cfg, code);
 
-- 
2.17.1

