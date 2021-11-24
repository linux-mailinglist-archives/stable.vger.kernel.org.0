Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3FC45C24A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346473AbhKXN04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:26:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348262AbhKXNYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 928DD61152;
        Wed, 24 Nov 2021 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758148;
        bh=sVLH/3bPoTcclJCjnqTxHfTrKiW3x4IU7q64XrNSqD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWuAx2GJTKjR/nnnvVsZgHQ7PKSd1XeLYewv2MHofCuKkzC5GtE60upX7V8Yof6w3
         GRn+sVcFwYGQslhQnanNF0DX1iSE7zs4PnbMSo0mJNkNGjaAyQEsXDLgpy2kagMVid
         6puT0krFg7jcoHKKtmrJFhq3if1DZXqszFDuR1V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/100] drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame
Date:   Wed, 24 Nov 2021 12:58:25 +0100
Message-Id: <20211124115657.100070144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 3cc1ae1fa70ab369e4645e38ce335a19438093ad ]

gv100_hdmi_ctrl() writes vendor_infoframe.subpack0_high to 0x6f0110, and
then overwrites it with 0. Just drop the overwrite with 0, that's clearly
a mistake.

Because of this issue the HDMI VIC is 0 instead of 1 in the HDMI Vendor
InfoFrame when transmitting 4kp30.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 290ffeafcc1a ("drm/nouveau/disp/gv100: initial support")
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/3d3bd0f7-c150-2479-9350-35d394ee772d@xs4all.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c
index 6e3c450eaacef..3ff49344abc77 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c
@@ -62,7 +62,6 @@ gv100_hdmi_ctrl(struct nvkm_ior *ior, int head, bool enable, u8 max_ac_packet,
 		nvkm_wr32(device, 0x6f0108 + hdmi, vendor_infoframe.header);
 		nvkm_wr32(device, 0x6f010c + hdmi, vendor_infoframe.subpack0_low);
 		nvkm_wr32(device, 0x6f0110 + hdmi, vendor_infoframe.subpack0_high);
-		nvkm_wr32(device, 0x6f0110 + hdmi, 0x00000000);
 		nvkm_wr32(device, 0x6f0114 + hdmi, 0x00000000);
 		nvkm_wr32(device, 0x6f0118 + hdmi, 0x00000000);
 		nvkm_wr32(device, 0x6f011c + hdmi, 0x00000000);
-- 
2.33.0



