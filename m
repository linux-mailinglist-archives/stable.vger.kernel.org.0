Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010761FE5F2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgFRC3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgFRBQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB28221F1;
        Thu, 18 Jun 2020 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442967;
        bh=AIM68VyQmCJv9NVAjJep09xySiU1PdQUeWOx6nIZLZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8txIk0hou5UswgieO/yHeKqkjMK5EzuRww/hSx5uVbtaSUu7mcEqp3xkl4UrjAT2
         Jk+rKi6LNl79Xek7yV1DNQo5NNHekDeiDp5FGKk62J6TvF55db/rzykX6wIR7Ct3Kg
         eHDI8MDYbQ+aIHV9gL9xK3gFvTyJZIPQG9CUIZGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 372/388] scsi: acornscsi: Fix an error handling path in acornscsi_probe()
Date:   Wed, 17 Jun 2020 21:07:49 -0400
Message-Id: <20200618010805.600873-372-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 42c76c9848e13dbe0538d7ae0147a269dfa859cb ]

'ret' is known to be 0 at this point.  Explicitly return -ENOMEM if one of
the 'ecardm_iomap()' calls fail.

Link: https://lore.kernel.org/r/20200530081622.577888-1-christophe.jaillet@wanadoo.fr
Fixes: e95a1b656a98 ("[ARM] rpc: acornscsi: update to new style ecard driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arm/acornscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index ddb52e7ba622..9a912fd0f70b 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2911,8 +2911,10 @@ static int acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	ashost->base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	ashost->fast = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
-	if (!ashost->base || !ashost->fast)
+	if (!ashost->base || !ashost->fast) {
+		ret = -ENOMEM;
 		goto out_put;
+	}
 
 	host->irq = ec->irq;
 	ashost->host = host;
-- 
2.25.1

