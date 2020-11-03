Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3712A53CA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbgKCVEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgKCVEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:04:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D9A20658;
        Tue,  3 Nov 2020 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437472;
        bh=4QZvZJNefxpLQmb5bdwsvFumMXg2nUnNIhRGW+TTBxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCfDB/VTM7lXDUUwmoZ8JXQYzKl/h7fXhfLOgwJq3CMoc1AI6vS+n44+QgDZL9VtS
         ftiFG0FVhSmZdKpUtEs5yG+YxcaG1QzNgH1N7omngiMmvccvFOpXK4WFi1HkXkCZ9B
         Vac485fBQscJ/MlJ2r1s2oZwQSyxCBe5q5a+8CNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/191] ata: sata_nv: Fix retrieving of active qcs
Date:   Tue,  3 Nov 2020 21:35:45 +0100
Message-Id: <20201103203239.510532893@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 8e4c309f9f33b76c09daa02b796ef87918eee494 ]

ata_qc_complete_multiple() has to be called with the tags physically
active, that is the hw tag is at bit 0. ap->qc_active has the same tag
at bit ATA_TAG_INTERNAL instead, so call ata_qc_get_active() to fix that
up. This is done in the vein of 8385d756e114 ("libata: Fix retrieving of
active qcs").

Fixes: 28361c403683 ("libata: add extra internal command")
Tested-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_nv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 798d549435cc1..2248a40631bf1 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2122,7 +2122,7 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 	pp->dhfis_bits &= ~done_mask;
 	pp->dmafis_bits &= ~done_mask;
 	pp->sdbfis_bits |= done_mask;
-	ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+	ata_qc_complete_multiple(ap, ata_qc_get_active(ap) ^ done_mask);
 
 	if (!ap->qc_active) {
 		DPRINTK("over\n");
-- 
2.27.0



