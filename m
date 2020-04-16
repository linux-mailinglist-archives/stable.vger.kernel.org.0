Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458CE1AC24C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895318AbgDPN0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895286AbgDPN0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:26:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43FA321BE5;
        Thu, 16 Apr 2020 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043600;
        bh=u7f2pqtpVNbs8a/p06LRN9rLRFe4gO8tJL2WMQuS9X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWnzeSFrzEeajAiiEF2SEbgT1CfuNbAbqo91x/uCPenc5OjC9rx+HMuXQocxOYixR
         QOBVSKvZJ7X8U7Q/MJJUNOX2Dxh9Z+TE0PM3PE9MQPhcv4dJLTOKP3Naqxyo0t4cXc
         k188uTeZon6RfqN6osa8I4Z42OdbVx9DBUH8owp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rdunlap@infradead.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/146] media: i2c: video-i2c: fix build errors due to imply hwmon
Date:   Thu, 16 Apr 2020 15:22:44 +0200
Message-Id: <20200416131245.622380720@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Ranostay <matt.ranostay@konsulko.com>

[ Upstream commit 64d4fc9926f09861a35d8f0f7d81f056e6d5af7b ]

Fix build fault when CONFIG_HWMON is a module, and CONFIG_VIDEO_I2C
as builtin. This is due to 'imply hwmon' in the respective Kconfig.

Issue build log:

ld: drivers/media/i2c/video-i2c.o: in function `amg88xx_hwmon_init':
video-i2c.c:(.text+0x2e1): undefined reference to `devm_hwmon_device_register_with_info

Cc: rdunlap@infradead.org
Fixes: acbea6798955 (media: video-i2c: add hwmon support for amg88xx)
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index f27d294dcbef5..dd50acc085d89 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -105,7 +105,7 @@ static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
 	return (ret == 2) ? 0 : -EIO;
 }
 
-#if IS_ENABLED(CONFIG_HWMON)
+#if IS_REACHABLE(CONFIG_HWMON)
 
 static const u32 amg88xx_temp_config[] = {
 	HWMON_T_INPUT,
-- 
2.20.1



