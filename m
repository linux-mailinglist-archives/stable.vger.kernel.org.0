Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630C714D4B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfEFOtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbfEFOtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 680632053B;
        Mon,  6 May 2019 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154186;
        bh=JoRzNY+QPvh8+dvdNwVECguMJzhCYTx+rNPGUizfYF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAth1AGp+66LS46CPeRzJN45iqgsL2rESSkpuZ5anOJtIgUCW44MwMORFYgnjXa1J
         p7qR5HiioiyfDQjuOaOAVDLk5scEppunL9vH+WHt6LJoMfiXSOOt6fKSdOCzx+f7/v
         pjGLxAW9wyRsgZcd9UfFGD+j8kMhBzihTnIVWj4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        SCSI ML <linux-scsi@vger.kernel.org>,
        DM ML <dm-devel@redhat.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 44/62] scsi: core: add new RDAC LENOVO/DE_Series device
Date:   Mon,  6 May 2019 16:33:15 +0200
Message-Id: <20190506143055.010173706@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1cb1d2c64e812928fe0a40b8f7e74523d0283dbe ]

Blacklist "Universal Xport" LUN. It's used for in-band storage array
management.  Also add model to the rdac dh family.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_dh.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 282ea00d0f87..9d555b63d2e2 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -249,6 +249,7 @@ static struct {
 	{"NETAPP", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 375cede0c534..c9bc6f058424 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -75,6 +75,7 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"NETAPP", "INF-01-00",		"rdac", },
 	{"LSI", "INF-01-00",		"rdac", },
 	{"ENGENIO", "INF-01-00",	"rdac", },
+	{"LENOVO", "DE_Series",		"rdac", },
 	{NULL, NULL,			NULL },
 };
 
-- 
2.20.1



