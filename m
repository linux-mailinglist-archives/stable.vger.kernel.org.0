Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4336CA714
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405040AbfJCQuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404546AbfJCQuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42F8215EA;
        Thu,  3 Oct 2019 16:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121418;
        bh=p4KhjG1+Btil1DJt/BXGtuxMmF2t2VXOhj88S3TeQ+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtZggPUfWu+YTwvBboMSKsQl30FqUCOxfjG7p1aJ+EbB0LsONY94Rq5DcCkn9ZPc5
         L0i9dkjGdq8nAIGph7IfnEvx7ZTF0wYO2zuu6ox8gBFUD4P4Q0HhdYU6g43qKDXx7K
         2uQmlQluGeZXiPMROq9+NTJemN4BEXQyuVuNxBzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.3 272/344] media: vivid: fix device init when no_error_inj=1 and fb disabled
Date:   Thu,  3 Oct 2019 17:53:57 +0200
Message-Id: <20191003154607.047447508@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Tucker <guillaume.tucker@collabora.com>

commit 79e85d1d2c16ba4907bb9d6a4381516b729ff341 upstream.

Add an extra condition to add the video output control class when the
device has some hdmi outputs defined.  This is required to then always
be able to add the display present control, which is enabled when
there are some hdmi outputs.

This fixes the corner case where no_error_inj is enabled and the
device has no frame buffer but some hdmi outputs, as otherwise the
video output control class would be added anyway.  Without this fix,
the sanity checks fail in v4l2_ctrl_new() as name is NULL.

Fixes: c533435ffb91 ("media: vivid: add display present control")
Cc: stable@vger.kernel.org # for 5.3
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vivid/vivid-ctrls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1473,7 +1473,7 @@ int vivid_create_controls(struct vivid_d
 	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
 	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_out, 26);
-	if (!no_error_inj || dev->has_fb)
+	if (!no_error_inj || dev->has_fb || dev->num_hdmi_outputs)
 		v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vbi_cap, 21);
 	v4l2_ctrl_new_custom(hdl_vbi_cap, &vivid_ctrl_class, NULL);


