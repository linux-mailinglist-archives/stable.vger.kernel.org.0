Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8012E2061C3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404193AbgFWUuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404136AbgFWUs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619BD21548;
        Tue, 23 Jun 2020 20:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945339;
        bh=R8poT/WfSWU1GfxheMUoZ/FdITa3vE/XmE9Ej5fNV9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywRC/CddO5ou3iWBurckDGe7kjztbihH3+ZKUv0S6nghY9VIfx5fUK4D1kRpw1JyT
         ldxVJcI67eD4gSekuGsQgUzf4BWnDix/MMngXbenyqlFwXMSYZ/PbOCqu2awL+Tokh
         HC0/o2S7o54VBgdCrND3TgVuMk4P4JYncucBZfXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 103/136] scsi: acornscsi: Fix an error handling path in acornscsi_probe()
Date:   Tue, 23 Jun 2020 21:59:19 +0200
Message-Id: <20200623195308.856634438@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 421fe869a11ef..ef9d907f2df5c 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2914,8 +2914,10 @@ static int acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
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



