Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23DCBA9AE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437061AbfIVTSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438085AbfIVSzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B79221D7B;
        Sun, 22 Sep 2019 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178523;
        bh=AsUcjl7bU3ZIWQ/tixJ4jOBHiqJuChzvSZje7Wuze/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd+u95NKlI+913oMvvpDtbaIzz/hGOQidOpmXUoLZp2YQtckrThBHn/CaV5Ee0H5t
         F3LolCUrBG4+iAUXiHZVOAIBMyeTwbkKqZrJRktcZMmngF94VlxRxzA3UmIBKWyEU6
         AQCzbIivnnJbby7rv7PMUSlwbcnQARL9T/tklPJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darius Rad <alpha@area49.net>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/128] media: rc: imon: Allow iMON RC protocol for ffdc 7e device
Date:   Sun, 22 Sep 2019 14:52:59 -0400
Message-Id: <20190922185418.2158-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darius Rad <alpha@area49.net>

[ Upstream commit b20a6e298bcb8cb8ae18de26baaf462a6418515b ]

Allow selecting the IR protocol, MCE or iMON, for a device that
identifies as follows (with config id 0x7e):

15c2:ffdc SoundGraph Inc. iMON PAD Remote Controller

As the driver is structured to default to iMON when both RC
protocols are supported, existing users of this device (using MCE
protocol) will need to manually switch to MCE (RC-6) protocol from
userspace (with ir-keytable, sysfs).

Signed-off-by: Darius Rad <alpha@area49.net>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 1041c056854d5..f23a220352f7f 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1835,12 +1835,17 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		break;
 	/* iMON VFD, MCE IR */
 	case 0x46:
-	case 0x7e:
 	case 0x9e:
 		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
 		allowed_protos = RC_PROTO_BIT_RC6_MCE;
 		break;
+	/* iMON VFD, iMON or MCE IR */
+	case 0x7e:
+		dev_info(ictx->dev, "0xffdc iMON VFD, iMON or MCE IR");
+		detected_display_type = IMON_DISPLAY_TYPE_VFD;
+		allowed_protos |= RC_PROTO_BIT_RC6_MCE;
+		break;
 	/* iMON LCD, MCE IR */
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
-- 
2.20.1

