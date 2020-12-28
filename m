Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A372E6860
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgL1Qf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgL1NCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4410224D2;
        Mon, 28 Dec 2020 13:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160485;
        bh=9/8GsZg8kvKV8XE3LxsYiNOmganx7LZuZdKDGykeqgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoU3KFBgOoAjjerE809aM6oGDa7cWqwUUQvBWtX238NAjb53fTW2QY37KMfh0eTtF
         AbTN6BACkmqxnZUoqdHaw/YTkPaYN/17MkO4xxc4gVVdmeP/cr/aAVPN0F+9sNKKml
         CJ12HUqiW52r1ui0BCMlvP8670F3T870mtKTXygA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 068/175] drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
Date:   Mon, 28 Dec 2020 13:48:41 +0100
Message-Id: <20201228124856.545358160@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 723ae803218da993143387bf966042eccefac077 ]

Return -ENOMEM when allocating refill memory failed.

Fixes: 71e8831f6407 ("drm/omap: DMM/TILER support for OMAP4+ platform")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201117061045.3452287-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index 6a0b25e0823fa..6b64a1e07c017 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -747,6 +747,7 @@ static int omap_dmm_probe(struct platform_device *dev)
 					   &omap_dmm->refill_pa, GFP_KERNEL);
 	if (!omap_dmm->refill_va) {
 		dev_err(&dev->dev, "could not allocate refill memory\n");
+		ret = -ENOMEM;
 		goto fail;
 	}
 
-- 
2.27.0



