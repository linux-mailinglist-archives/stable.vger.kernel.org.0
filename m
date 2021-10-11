Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906A442909B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbhJKOKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241864AbhJKOIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BC66124F;
        Mon, 11 Oct 2021 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960886;
        bh=tx2s8Vfs7vROGq+0y/pyfaiNWVs4C19XcKOE+UM9Gyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3dRrIyTAt4HimuDon5do5OZMvd0yZuanquUlqjd3lGlyLb3t22cSOmeFR7cDNaqA
         hG/d1NMjwZaEPVHYEwXyZkwh2ZDTzGipBg6QPHIY8pTJe3Mtnyh4vFOKi8XYHP2Hfy
         KObmsesJCYxNQ/Tya+jYDxhhHy0aIjuiWvNmr7Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 102/151] video: fbdev: gbefb: Only instantiate device when built for IP32
Date:   Mon, 11 Oct 2021 15:46:14 +0200
Message-Id: <20211011134521.113118342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 11b8e2bb986d23157e82e267fb8cc6b281dfdee9 ]

The gbefb driver not only registers a driver but also the device for that
driver. This is all well and good when run on the IP32 machines that are
supported by the driver but since the driver supports building with
COMPILE_TEST we might also be building on other platforms which do not have
this hardware and will crash instantiating the driver. Add an IS_ENABLED()
check so we compile out the device registration if we don't have the Kconfig
option for the machine enabled.

Fixes: 552ccf6b259d290c0c ("video: fbdev: gbefb: add COMPILE_TEST support")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210921212102.30803-1-broonie@kernel.org
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/gbefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
index c5b99a4861e8..6b4d5a7f3e15 100644
--- a/drivers/video/fbdev/gbefb.c
+++ b/drivers/video/fbdev/gbefb.c
@@ -1267,7 +1267,7 @@ static struct platform_device *gbefb_device;
 static int __init gbefb_init(void)
 {
 	int ret = platform_driver_register(&gbefb_driver);
-	if (!ret) {
+	if (IS_ENABLED(CONFIG_SGI_IP32) && !ret) {
 		gbefb_device = platform_device_alloc("gbefb", 0);
 		if (gbefb_device) {
 			ret = platform_device_add(gbefb_device);
-- 
2.33.0



