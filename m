Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD0C4D627
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfFTSEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbfFTSEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 197B021670;
        Thu, 20 Jun 2019 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053891;
        bh=RXSCdDUMopVh8+8d9z183A+gfSEGcEZeZFDCTI3t3fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLyuKitGinzQZIvVcBwueGU/i/yq27GwhfgM/bCTp4Y1oguMXHgojg0smeEBYS8RI
         XlvYzhbcg6f1+m++LQGFYv9TUf37fHdmApzHemnofFnmWbY9IYUF5BoEnckICzU4NI
         x7SNnR10O7eUyHdPeHB1rDy/gj7NuMcs2qipaf3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.9 063/117] media: v4l2-ioctl: clear fields in s_parm
Date:   Thu, 20 Jun 2019 19:56:37 +0200
Message-Id: <20190620174356.670522344@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 8a7c5594c02022ca5fa7fb603e11b3e1feb76ed5 upstream.

Zero the reserved capture/output array.

Zero the extendedmode (it is never used in drivers).

Clear all flags in capture/outputmode except for V4L2_MODE_HIGHQUALITY,
as that is the only valid flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-ioctl.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1959,7 +1959,22 @@ static int v4l_s_parm(const struct v4l2_
 	struct v4l2_streamparm *p = arg;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_s_parm(file, fh, p);
+	if (ret)
+		return ret;
+
+	/* Note: extendedmode is never used in drivers */
+	if (V4L2_TYPE_IS_OUTPUT(p->type)) {
+		memset(p->parm.output.reserved, 0,
+		       sizeof(p->parm.output.reserved));
+		p->parm.output.extendedmode = 0;
+		p->parm.output.outputmode &= V4L2_MODE_HIGHQUALITY;
+	} else {
+		memset(p->parm.capture.reserved, 0,
+		       sizeof(p->parm.capture.reserved));
+		p->parm.capture.extendedmode = 0;
+		p->parm.capture.capturemode &= V4L2_MODE_HIGHQUALITY;
+	}
+	return ops->vidioc_s_parm(file, fh, p);
 }
 
 static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,


