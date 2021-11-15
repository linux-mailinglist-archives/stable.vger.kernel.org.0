Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18A945241B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355925AbhKPBgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242570AbhKOSiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37864632E4;
        Mon, 15 Nov 2021 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999412;
        bh=fJKt79npfQTWKKmxqFy13G2LlyTw9LUirXRUVbIsj2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7zsSQ1q3jifvShSpi7ZRzBDdU005HOrSvL68SAhxhmSrRqhNG4ElUum8Xkw1/NmT
         9nhhyIWVfiq6ZBBlgL3wHoiW34xiz+yjvyhM1ZGqvPvvuaSAaTcub+z9jU39mw8Eoq
         ArGnAv4IQsdBKYJTT4dk8EpiP9zmKtnheeuh8Oqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 245/849] media: vidtv: Fix memory leak in remove
Date:   Mon, 15 Nov 2021 17:55:28 +0100
Message-Id: <20211115165428.503216321@linuxfoundation.org>
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



