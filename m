Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364E71FE052
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgFRBrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731022AbgFRB2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:28:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44EB7221FC;
        Thu, 18 Jun 2020 01:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443698;
        bh=iLpKnNLcCmnU67a1CwsUEPaUwcpiD+DGwyuTxy6efnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJrx2lGhakmgPHu9BfdcghawyHZqlwrppIDiAKahkEH1STXNJVMb7wg+1y8myIys7
         CsNbsCDOaUf2xlMT8zRHewich27udM7g3VNREbWQFDFGsL0ya5jgLw1mi5DGuxafj8
         hladq8s+GZXxbSCpfL0kFsy5up+p+9gLDhD1DiEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 108/108] scsi: acornscsi: Fix an error handling path in acornscsi_probe()
Date:   Wed, 17 Jun 2020 21:26:00 -0400
Message-Id: <20200618012600.608744-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
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
index 421fe869a11e..ef9d907f2df5 100644
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

