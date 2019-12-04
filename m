Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54833113245
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfLDSHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730691AbfLDSHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:03 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56F420675;
        Wed,  4 Dec 2019 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482822;
        bh=sh0v4/QS4yXDf8nsPhpABgTaRIB6/vBbFmDq+bER7xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5Wu+QM6ztDAgeKTjRCCpUNmv39fGK/3xHB1gW51SkeLq95cq7eZYNYw29CXd5/VQ
         qkXFmFaT2iw3LWpF2peR6PVkAYdm48FPBogO9h8c+YqPs/LggWwCM8TuZS16uG2kFj
         MfZ0PDNEVEXoc5TeKcuha9rwDz2Wjc+2nmBVhy7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Luo <luojian5@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 149/209] scsi: libsas: Support SATA PHY connection rate unmatch fixing during discovery
Date:   Wed,  4 Dec 2019 18:56:01 +0100
Message-Id: <20191204175333.764334004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit cec9771d2e954650095aa37a6a97722c8194e7d2 ]

   +----------+             +----------+
   |          |             |          |
   |          |--- 3.0 G ---|          |--- 6.0 G --- SAS  disk
   |          |             |          |
   |          |--- 3.0 G ---|          |--- 6.0 G --- SAS  disk
   |initiator |             |          |
   | device   |--- 3.0 G ---| Expander |--- 6.0 G --- SAS  disk
   |          |             |          |
   |          |--- 3.0 G ---|          |--- 6.0 G --- SATA disk  -->failed to connect
   |          |             |          |
   |          |             |          |--- 6.0 G --- SATA disk  -->failed to connect
   |          |             |          |
   +----------+             +----------+

According to Serial Attached SCSI - 1.1 (SAS-1.1):
If an expander PHY attached to a SATA PHY is using a physical link rate
greater than the maximum connection rate supported by the pathway from an
STP initiator port, a management application client should use the SMP PHY
CONTROL function (see 10.4.3.10) to set the PROGRAMMED MAXIMUM PHYSICAL
LINK RATE field of the expander PHY to the maximum connection rate
supported by the pathway from that STP initiator port.

Currently libsas does not support checking if this condition occurs, nor
rectifying when it does.

Such a condition is not at all common, however it has been seen on some
pre-silicon environments where the initiator PHY only supports a 1.5 Gbit
maximum linkrate, mated with 12G expander PHYs and 3/6G SATA phy.

This patch adds support for checking and rectifying this condition during
initial device discovery only.

We do support checking min pathway connection rate during revalidation phase,
when new devices can be detected in the topology. However we do not
support in the case of the the user reprogramming PHY linkrates, such that
min pathway condition is not met/maintained.

A note on root port PHY rates:
The libsas root port PHY rates calculation is broken. Libsas sets the
rates (min, max, and current linkrate) of a root port to the same linkrate
of the first PHY member of that same port. In doing so, it assumes that
all other PHYs which subsequently join the port to have the same
negotiated linkrate, when they could actually be different.

In practice this doesn't happen, as initiator and expander PHYs are
normally initialised with consistent min/max linkrates.

This has not caused an issue so far, so leave alone for now.

Tested-by: Jian Luo <luojian5@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 7f2d00354a850..63c44eaabf69e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -817,6 +817,26 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 #ifdef CONFIG_SCSI_SAS_ATA
 	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
+		if (child->linkrate > parent->min_linkrate) {
+			struct sas_phy_linkrates rates = {
+				.maximum_linkrate = parent->min_linkrate,
+				.minimum_linkrate = parent->min_linkrate,
+			};
+			int ret;
+
+			pr_notice("ex %016llx phy%02d SATA device linkrate > min pathway connection rate, attempting to lower device linkrate\n",
+				   SAS_ADDR(child->sas_addr), phy_id);
+			ret = sas_smp_phy_control(parent, phy_id,
+						  PHY_FUNC_LINK_RESET, &rates);
+			if (ret) {
+				pr_err("ex %016llx phy%02d SATA device could not set linkrate (%d)\n",
+				       SAS_ADDR(child->sas_addr), phy_id, ret);
+				goto out_free;
+			}
+			pr_notice("ex %016llx phy%02d SATA device set linkrate successfully\n",
+				  SAS_ADDR(child->sas_addr), phy_id);
+			child->linkrate = child->min_linkrate;
+		}
 		res = sas_get_ata_info(child, phy);
 		if (res)
 			goto out_free;
-- 
2.20.1



