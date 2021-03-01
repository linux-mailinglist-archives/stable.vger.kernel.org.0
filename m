Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC0328D94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhCATNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241280AbhCATJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A100651A1;
        Mon,  1 Mar 2021 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618720;
        bh=Pk9sI8KEEXP6HELEYhD7kTM9rjp13VdcAeXmrm1UWr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tlva/tvrWz+Cf5CcFCEpHYul0aboVs+7DDSI+1knaMuBcJ0PARybJ5Y0w7GkdDqqc
         hyMMe800thtucH3R7on+Aicc3isCDrzgTo/hVvEeYN2jJAxQGTxEucfi2PEEzV23pr
         x8TW8/CVpDC+pkbDOrjT4rd8oDZo5Gofn7zhRwFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <robert.foss@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/663] media: camss: missing error code in msm_video_register()
Date:   Mon,  1 Mar 2021 17:06:52 +0100
Message-Id: <20210301161149.892611332@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9c67ed2ab299123872be14a3dc2ea44ce7e4538b ]

This error path returns success but it should return -EINVAL.

Fixes: cba3819d1e93 ("media: camss: Format configuration per hardware version")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index 114c3ae4a4abb..15965e63cb619 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -979,6 +979,7 @@ int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
 			video->nformats = ARRAY_SIZE(formats_rdi_8x96);
 		}
 	} else {
+		ret = -EINVAL;
 		goto error_video_register;
 	}
 
-- 
2.27.0



