Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19351329076
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbhCAUIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242443AbhCAT6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:58:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C2D6504C;
        Mon,  1 Mar 2021 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621373;
        bh=fWBOcpZmbe6WNpFJZAMA68foNWZ2ghO72Hl40Rj2rNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy1cDPeNKb5XbXjlIr6NPBeIzaiYCrqtLKJ1OiyphdQ5K8k8+0WsJ7l7YLr5rdAG/
         N4Og8N1TgxZH1fupuSIQF4c8zBURQKiGEfvRQvIlqu6m2eU3xmxbZdUVMdkX1ZfeiK
         VWaF8qxOiKIguQZ7WvjVJpAjWivfKSiue3DivRio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 491/775] mei: hbm: call mei_set_devstate() on hbm stop response
Date:   Mon,  1 Mar 2021 17:10:59 +0100
Message-Id: <20210301161225.782195263@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 3a77df62deb2e62de0dc26c1cb763cc152329287 ]

Use mei_set_devstate() wrapper upon hbm stop command response,
to trigger sysfs event.

Fixes: 43b8a7ed4739 ("mei: expose device state in sysfs")
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-3-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 686e8b6a4c55e..0cba3c6dfb148 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1373,7 +1373,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		dev->dev_state = MEI_DEV_POWER_DOWN;
+		mei_set_devstate(dev, MEI_DEV_POWER_DOWN);
 		dev_info(dev->dev, "hbm: stop response: resetting.\n");
 		/* force the reset */
 		return -EPROTO;
-- 
2.27.0



