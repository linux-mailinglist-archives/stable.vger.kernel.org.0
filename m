Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB3045101D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242612AbhKOSlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242544AbhKOSiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B6D632DF;
        Mon, 15 Nov 2021 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999396;
        bh=tap+HRvvemmA8l2EyCeQCQUxgwnf1ec60xbv7fMIo9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9r5mUsJsa8ZmEf850D7pIKFGkhcm+eCYGy2LxmttGEjM+40lctaHbMZiRvV4Ddsz
         S4qsAxth4etP5Xb3LtW9ffITZPb2SBYkS7WqWS3x3fyd3zJ4CCMTh1Egi9Y1hJBdlR
         Z3G/6LfaNUwWj0M0+kdIMg/qSOWFJbGEL9CvAK0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 249/849] media: imx: set a media_device bus_info string
Date:   Mon, 15 Nov 2021 17:55:32 +0100
Message-Id: <20211115165428.635741862@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 6d0d779b212c27293d9ccb4da092ff0ccb6efa39 ]

Some tools like v4l2-compliance let users select a media device based
on the bus_info string which can be quite convenient. Use a unique
string for that.

This also fixes the following v4l2-compliance warning:
warn: v4l2-test-media.cpp(52): empty bus_info

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-dev-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-dev-common.c b/drivers/staging/media/imx/imx-media-dev-common.c
index d186179388d03..4d873726a461b 100644
--- a/drivers/staging/media/imx/imx-media-dev-common.c
+++ b/drivers/staging/media/imx/imx-media-dev-common.c
@@ -367,6 +367,8 @@ struct imx_media_dev *imx_media_dev_init(struct device *dev,
 	imxmd->v4l2_dev.notify = imx_media_notify;
 	strscpy(imxmd->v4l2_dev.name, "imx-media",
 		sizeof(imxmd->v4l2_dev.name));
+	snprintf(imxmd->md.bus_info, sizeof(imxmd->md.bus_info),
+		 "platform:%s", dev_name(imxmd->md.dev));
 
 	media_device_init(&imxmd->md);
 
-- 
2.33.0



