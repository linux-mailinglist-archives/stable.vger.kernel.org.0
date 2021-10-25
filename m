Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E14439558
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJYL4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhJYL4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD3061027;
        Mon, 25 Oct 2021 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162857;
        bh=YDaGvnW29RXV7XM/rAbNb6WCpfjPhf7k8y9aqrr8FiM=;
        h=From:To:Cc:Subject:Date:From;
        b=RVsl9hLtMhXwTB5Mw48Oz5jmVRapGBXa4svqWsgHdhLc5qAkqTNPa/rgL8FoDzyPq
         Hzy03LLoGSJgrZqTavKUSDKMEdZI+p20FjPdncI3N7NGTDcvzpMf8azCwxSxEZ71XX
         3Qtc4Ibj0XQ8XBifTBXdZllXNLCMzw2Sooe07jMilpDu3tvh58wlDt6s8Xg5ijrcHO
         95vXeqZzvICffg1vP6gltPzbKJteIbgt1k7FCwMsnzrsZZxh6N3uOE4/voKrE53ipy
         O6BMe1Tdhdx6aHr7Bhj1tFa7llt9TyUUgY0VAD1TdWTKFqU+AYvd28QMuO5hMihxYl
         Fq2KfmMtZ3K/g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyYB-0001Kr-Qz; Mon, 25 Oct 2021 13:53:59 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dave Airlie <airlied@redhat.com>
Cc:     Sean Paul <sean@poorly.run>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] drm/udl: fix control-message timeout
Date:   Mon, 25 Oct 2021 13:53:53 +0200
Message-Id: <20211025115353.5089-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 5320918b9a87 ("drm/udl: initial UDL driver (v4)")
Cc: stable@vger.kernel.org      # 3.4
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpu/drm/udl/udl_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 3750fd216131..930574ad2bca 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -30,7 +30,7 @@ static int udl_get_edid_block(void *data, u8 *buf, unsigned int block,
 		int bval = (i + block * EDID_LENGTH) << 8;
 		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      0x02, (0x80 | (0x02 << 5)), bval,
-				      0xA1, read_buff, 2, HZ);
+				      0xA1, read_buff, 2, 1000);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
 			kfree(read_buff);
-- 
2.32.0

