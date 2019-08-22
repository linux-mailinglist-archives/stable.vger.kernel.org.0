Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1499AA3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391131AbfHVROm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390543AbfHVRIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:51 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60D723402;
        Thu, 22 Aug 2019 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493731;
        bh=d3C4g9gaX7ZxIX8z6EjnIicHuLXSAtpXg8kYz21AgXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pcg1kRKSOkSiDbMm5E05HeZh7ZoEaVGQTBWG401m6Hkm9qf+ozDOLJOqLiq4u2+fS
         mHABlR38b0XNRBWUw9YljKM6btsmg3hMyCfkjBRmK5YESsbDwJrXNIXQKZDJlVK1lt
         VkpLhYwNTNvQnhKD0Jcm7FU8wmM9krZD4+em0qCs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 067/135] ata: libahci: do not complain in case of deferred probe
Date:   Thu, 22 Aug 2019 13:07:03 -0400
Message-Id: <20190822170811.13303-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 090bb803708198e5ab6b0046398c7ed9f4d12d6b ]

Retrieving PHYs can defer the probe, do not spawn an error when
-EPROBE_DEFER is returned, it is normal behavior.

Fixes: b1a9edbda040 ("ata: libahci: allow to use multiple PHYs")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 72312ad2e142d..c25cdbf817f18 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -338,6 +338,9 @@ static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
 		hpriv->phys[port] = NULL;
 		rc = 0;
 		break;
+	case -EPROBE_DEFER:
+		/* Do not complain yet */
+		break;
 
 	default:
 		dev_err(dev,
-- 
2.20.1

