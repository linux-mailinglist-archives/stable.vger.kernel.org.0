Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620BF83C25
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfHFVkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbfHFVgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF202186A;
        Tue,  6 Aug 2019 21:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127411;
        bh=Bl9/DbJ3RHmDEt92DJen9NmESl82esOn0yRvhyAXIgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMvQAXdG919MNvcRTfQN/rghosCe75cC5kVryezs1NRkpoPAiOglKG46M7CsMXekh
         W3SWjzxWGpwd5C3Jkb5Z5W/rwIDm3+NnRBl56FkqflFLBemenzj/GM9WCVuFvCTvZ7
         W1+vtiltxcl+gRJdripZh7BCBuHXbJLzMnGL3M4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/25] ata: libahci: do not complain in case of deferred probe
Date:   Tue,  6 Aug 2019 17:36:11 -0400
Message-Id: <20190806213624.20194-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213624.20194-1-sashal@kernel.org>
References: <20190806213624.20194-1-sashal@kernel.org>
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
index a270a1173c8cb..70cdbf1b0f9a3 100644
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

