Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C43130BFFE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhBBNrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232902AbhBBNpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EA964F81;
        Tue,  2 Feb 2021 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273267;
        bh=YLzPPctyy4SyJqM/ItZUdmGJL549Q0u1dOVa0SLo4SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMdMrzBUnzooyQ4fd7Bw2b6Gn4HGp5jv23nkqGCkaUCuSf2rqPOD37KaE52EDUxN+
         e4iYuvEXG+uX1DG77+uxIksfNVW+uN/29NCKSEwW6GB82ACqHPEFJ+evPTP3r1JLMw
         tZT6jIYOCwnZMI9vVjxykW1GE5QS8LYyykxEx7ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 011/142] media: cedrus: Fix H264 decoding
Date:   Tue,  2 Feb 2021 14:36:14 +0100
Message-Id: <20210202132958.167593589@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit 73bc0b0c2a96b31199da0ce6c3d04be81ef73bb9 upstream.

During H264 API overhaul subtle bug was introduced Cedrus driver.
Progressive references have both, top and bottom reference flags set.
Cedrus reference list expects only bottom reference flag and only when
interlaced frames are decoded. However, due to a bug in Cedrus check,
exclusivity is not tested and that flag is set also for progressive
references. That causes "jumpy" background with many videos.

Fix that by checking that only bottom reference flag is set in control
and nothing else.

Tested-by: Andre Heider <a.heider@gmail.com>
Fixes: cfc8c3ed533e ("media: cedrus: h264: Properly configure reference field")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -203,7 +203,7 @@ static void _cedrus_write_ref_list(struc
 		position = cedrus_buf->codec.h264.position;
 
 		sram_array[i] |= position << 1;
-		if (ref_list[i].fields & V4L2_H264_BOTTOM_FIELD_REF)
+		if (ref_list[i].fields == V4L2_H264_BOTTOM_FIELD_REF)
 			sram_array[i] |= BIT(0);
 	}
 


