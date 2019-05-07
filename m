Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAB159DA
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfEGFkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbfEGFka (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8DC2087F;
        Tue,  7 May 2019 05:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207629;
        bh=C/SEdJvcztVmaWYIHppHb6GDJ7iOjWkEKhogPF8LK1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzLugjq8V/bTzbg43eUiU523ZrMeJwpsfGuXMzckElO7DXJomqN+NW2UIm8pAkKLX
         P8PJcWgoVtZwneNDn/RzqxYprPZOMjqwTh2QRLvazvthMHftSn+VDRaPacvKN9DB/S
         ZnuI51kryP7CnSTdJMEXm+769qAfAvPj1/1zVw+s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <alexander.levin@microsoft.com>,
        dri-devel@lists.freedesktop.org, linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 67/95] drm/rockchip: psr: do not dereference encoder before it is null checked.
Date:   Tue,  7 May 2019 01:37:56 -0400
Message-Id: <20190507053826.31622-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 4eda776c3cefcb1f01b2d85bd8753f67606282b5 ]

'encoder' is dereferenced before it is null sanity checked, hence we
potentially have a null pointer dereference bug. Instead, initialise
drm_drv from encoder->dev->dev_private after we are sure 'encoder' is
not null.

Fixes: 5182c1a556d7f ("drm/rockchip: add an common abstracted PSR driver")
Cc: stable@vger.kernel.org
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20181013105654.11827-1-enric.balletbo@collabora.com
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/gpu/drm/rockchip/rockchip_drm_psr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_psr.c b/drivers/gpu/drm/rockchip/rockchip_drm_psr.c
index a553e182ff53..32e7dba2bf5e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_psr.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_psr.c
@@ -221,13 +221,15 @@ EXPORT_SYMBOL(rockchip_drm_psr_flush_all);
 int rockchip_drm_psr_register(struct drm_encoder *encoder,
 			void (*psr_set)(struct drm_encoder *, bool enable))
 {
-	struct rockchip_drm_private *drm_drv = encoder->dev->dev_private;
+	struct rockchip_drm_private *drm_drv;
 	struct psr_drv *psr;
 	unsigned long flags;
 
 	if (!encoder || !psr_set)
 		return -EINVAL;
 
+	drm_drv = encoder->dev->dev_private;
+
 	psr = kzalloc(sizeof(struct psr_drv), GFP_KERNEL);
 	if (!psr)
 		return -ENOMEM;
-- 
2.20.1

