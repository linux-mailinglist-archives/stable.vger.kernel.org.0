Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBE22F616
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfE3ExF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfE3DKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B46244BC;
        Thu, 30 May 2019 03:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185841;
        bh=5mpJYdrDYFJZ4rsIuXEv/X6DFib4s+JmFa4WhOa4HfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCCc2bOtIJsywM1Yde8XwUsGO31hPQqwJ5tN6rAislVzOtnoCExrzLPJQPprLo633
         YO7GjXUYlLN89kvU/05HQ3DXNqSx19N7r93RZitPCOJMq7UCK0rffGkp5gBfNkez/R
         3+PrRuRhHf1YGiuE3ctlFMJjVTFzskK00zg61wBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 158/405] media: stm32-dcmi: fix crash when subdev do not expose any formats
Date:   Wed, 29 May 2019 20:02:36 -0700
Message-Id: <20190530030549.136440100@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 33dfeb62e23c31619d2197850f7e8b50e8cc5466 ]

Do not access sd_formats[] if num_of_sd_formats is zero, ie
subdev sensor didn't expose any formats.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index a1f0801081ba9..922855b6025c7 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -811,6 +811,9 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
 
 	sd_fmt = find_format_by_fourcc(dcmi, pix->pixelformat);
 	if (!sd_fmt) {
+		if (!dcmi->num_of_sd_formats)
+			return -ENODATA;
+
 		sd_fmt = dcmi->sd_formats[dcmi->num_of_sd_formats - 1];
 		pix->pixelformat = sd_fmt->fourcc;
 	}
@@ -989,6 +992,9 @@ static int dcmi_set_sensor_format(struct stm32_dcmi *dcmi,
 
 	sd_fmt = find_format_by_fourcc(dcmi, pix->pixelformat);
 	if (!sd_fmt) {
+		if (!dcmi->num_of_sd_formats)
+			return -ENODATA;
+
 		sd_fmt = dcmi->sd_formats[dcmi->num_of_sd_formats - 1];
 		pix->pixelformat = sd_fmt->fourcc;
 	}
-- 
2.20.1



