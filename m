Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766B5450B63
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbhKORYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236999AbhKORTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73256326D;
        Mon, 15 Nov 2021 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996506;
        bh=rdP6oZ9XMgYml/iKLXdHxrHtOiiEdxENziJOiT9jMm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxYisRJEO7G1OPnHTcc0ecbC5nAv3YvNafPENC4YBjT2S6rujhsVWA17bQXtXaOJB
         4cxQ4WpPhTwRs1DwqnDeMgpXetVFaaFvEEpSCAisabHo3rhRSq035svAzzy6/gsB1X
         oZiG2M913oByTA8fLX8+T9u6nCQ+bofx6Q0usZT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/355] media: imx: set a media_device bus_info string
Date:   Mon, 15 Nov 2021 18:01:01 +0100
Message-Id: <20211115165318.229996808@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 66b505f7e8dff..137e414cda186 100644
--- a/drivers/staging/media/imx/imx-media-dev-common.c
+++ b/drivers/staging/media/imx/imx-media-dev-common.c
@@ -373,6 +373,8 @@ struct imx_media_dev *imx_media_dev_init(struct device *dev,
 	imxmd->v4l2_dev.notify = imx_media_notify;
 	strscpy(imxmd->v4l2_dev.name, "imx-media",
 		sizeof(imxmd->v4l2_dev.name));
+	snprintf(imxmd->md.bus_info, sizeof(imxmd->md.bus_info),
+		 "platform:%s", dev_name(imxmd->md.dev));
 
 	media_device_init(&imxmd->md);
 
-- 
2.33.0



