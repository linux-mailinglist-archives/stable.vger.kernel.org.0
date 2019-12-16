Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3203D1215E8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfLPSZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbfLPSSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 485C7207FF;
        Mon, 16 Dec 2019 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520300;
        bh=/NHO/ohMsAOzW+98SBxccfqI4V7e9Zzwpgpq+pT90G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW0QUta6TdXeNEE4r2HluQRc0MSMQekMngm3XrWLqyv7m2lMgekc7B5EvyEcgIQHi
         8LV/vBRz+XUL+V3jW9YnDEk8zdacIZVdDw4CSfvNJ5mmXaBzL1ubyIpOzwUPKpVeen
         lAnoosWy3KdNLRAlmf/Ur+VWd4DbLZTVNxUPzuvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francois Buergisser <fbuergisser@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 099/177] media: hantro: Fix picture order count table enable
Date:   Mon, 16 Dec 2019 18:49:15 +0100
Message-Id: <20191216174840.911533538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francois Buergisser <fbuergisser@chromium.org>

commit 58c93a548b0248fad6437f8c8921f9b031c3892a upstream.

The picture order count table only makes sense for profiles
higher than Baseline. This is confirmed by the H.264 specification
(See 8.2.1 Decoding process for picture order count), which
clarifies how POC are used for features not present in Baseline.

"""
Picture order counts are used to determine initial picture orderings
for reference pictures in the decoding of B slices, to represent picture
order differences between frames or fields for motion vector derivation
in temporal direct mode, for implicit mode weighted prediction in B slices,
and for decoder conformance checking.
"""

As a side note, this change matches various vendors downstream codebases,
including ChromiumOS and IMX VPU libraries.

Fixes: dea0a82f3d22 ("media: hantro: Add support for H264 decoding on G1")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_g1_h264_dec.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/media/hantro/hantro_g1_h264_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_h264_dec.c
@@ -34,9 +34,11 @@ static void set_params(struct hantro_ctx
 	reg = G1_REG_DEC_CTRL0_DEC_AXI_WR_ID(0x0);
 	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
 		reg |= G1_REG_DEC_CTRL0_SEQ_MBAFF_E;
-	reg |= G1_REG_DEC_CTRL0_PICORD_COUNT_E;
-	if (sps->profile_idc > 66 && dec_param->nal_ref_idc)
-		reg |= G1_REG_DEC_CTRL0_WRITE_MVS_E;
+	if (sps->profile_idc > 66) {
+		reg |= G1_REG_DEC_CTRL0_PICORD_COUNT_E;
+		if (dec_param->nal_ref_idc)
+			reg |= G1_REG_DEC_CTRL0_WRITE_MVS_E;
+	}
 
 	if (!(sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY) &&
 	    (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD ||


