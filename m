Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EFD83BE5
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfHFVin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbfHFViG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:38:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05332189E;
        Tue,  6 Aug 2019 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127486;
        bh=TVfTkcJ8KkVOiUsmcxKFMFDoP6IU3vPc4t5JMQzWKuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj4yVEHoRUVLcMpK4KEErnAf8wkPy0OL8zzCJXJXJ3ZyoSIkJl04jzLve+Orm1o/1
         AxjsFQTbRxywpmmjZkodhaE9hWvOlicXG+U+vHuNBj6tZ/HyA1XoxhbMBW3Ug8amkO
         GNCsF6hdtEjZYgj+AH8u93g4PqhLWMCylW9bXm5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/14] ata: libahci: do not complain in case of deferred probe
Date:   Tue,  6 Aug 2019 17:37:43 -0400
Message-Id: <20190806213749.20689-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213749.20689-1-sashal@kernel.org>
References: <20190806213749.20689-1-sashal@kernel.org>
MIME-Version: 1.0
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
index cd2eab6aa92ea..65371e1befe8a 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -300,6 +300,9 @@ static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
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

