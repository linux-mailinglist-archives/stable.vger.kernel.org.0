Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AA144A15A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhKIBJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239956AbhKIBHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1132C6162E;
        Tue,  9 Nov 2021 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419785;
        bh=fJKt79npfQTWKKmxqFy13G2LlyTw9LUirXRUVbIsj2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJeskcPRdooyq0orFEyf21i30HTeabn5+F/Ye1sTZm1lAPseHneo0gG8mHyrQhqf5
         t+bDcYflPCzINokv7Tyxh/jAp9hyc0cv9soCjQ9giA9Yf9IjWxxFEU14DU2bA9IPEo
         wQt168ZU50+kzYExA39LY5lPoZLDysufRBi/DAXjprLFleWICO/TkZd1O4ZX7wnc/3
         DYUoZGTmdJ+m9fIIJWqvwjNLPPkUThVtBnU+gt3ccC2TIwXC549eQ83JF4kL4W3fac
         B+XbR5lhpv0/2zuJ6Wbe+ZhAMvdCsjtDh4Vy11GfHFiPzdtwnVZ/s6qhqbQYR95B12
         lhB2q6wMQeGxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dwlsalmeida@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 042/138] media: vidtv: Fix memory leak in remove
Date:   Mon,  8 Nov 2021 12:45:08 -0500
Message-Id: <20211108174644.1187889-42-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 76e21bb8be4f5f987f3006d197196fe6af63f656 ]

vidtv_bridge_remove() releases and cleans up everything except for dvb
itself. The patch adds this missed release.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index 75617709c8ce2..0f6d998d18dc0 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -557,6 +557,7 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 	dvb_dmxdev_release(&dvb->dmx_dev);
 	dvb_dmx_release(&dvb->demux);
 	dvb_unregister_adapter(&dvb->adapter);
+	kfree(dvb);
 	dev_info(&pdev->dev, "Successfully removed vidtv\n");
 
 	return 0;
-- 
2.33.0

