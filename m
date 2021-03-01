Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA517328665
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhCARJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236505AbhCARDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738B564F3E;
        Mon,  1 Mar 2021 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616747;
        bh=Frsx+3Qe0XcLkuuSfij4oeuMPEwnvn4hMPA/nIAoptI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGbp91KSICwglYMZGQdp+aJsy8dvO6yQiBu4vn+IUf03pIM59mWWn9D4E+gr4B1pJ
         n9lgvXDfPb8GVUO+sTlCL9qPo2gPGSYMKWwSQx59P7bLUeLYuzVc4iBA/fHRskQjn+
         WmDzhuzrxqFpH1wiUW4mYpScGrIhmZ6QNg7wLvNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <robert.foss@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/247] media: camss: missing error code in msm_video_register()
Date:   Mon,  1 Mar 2021 17:11:41 +0100
Message-Id: <20210301161035.646384986@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index c9bb0d023db48..e81ebeb0506e4 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -901,6 +901,7 @@ int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
 			video->nformats = ARRAY_SIZE(formats_rdi_8x96);
 		}
 	} else {
+		ret = -EINVAL;
 		goto error_video_register;
 	}
 
-- 
2.27.0



