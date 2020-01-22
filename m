Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7A145660
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgAVN02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgAVN02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:28 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB53B2467B;
        Wed, 22 Jan 2020 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699587;
        bh=8QijUBSXZsydj3NB/meNkcDErESmAxv0joTQ/EXXFJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSCzDVB1MRIgcOqsjZMWaFbqk3768K75TQPJGoQbTub/1fezSWs1DjHJVWOuxf5J6
         4zQ1tN8yKGmfC4NeJf0KBqo1phDwJIUBhLs2VvilkUl8RxejchtflpxyuZ61PhIMFr
         DtC246SeELPaj2/nTs9K1/om22EIBx3CbBZyetec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Smith <msmith626@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 151/222] bnxt_en: Do not treat DSN (Digital Serial Number) read failure as fatal.
Date:   Wed, 22 Jan 2020 10:28:57 +0100
Message-Id: <20200122092844.536923917@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit d061b2411d5f3d6272187ab734ce0640827fca13 ]

DSN read can fail, for example on a kdump kernel without PCIe extended
config space support.  If DSN read fails, don't set the
BNXT_FLAG_DSN_VALID flag and continue loading.  Check the flag
to see if the stored DSN is valid before using it.  Only VF reps
creation should fail without valid DSN.

Fixes: 03213a996531 ("bnxt: move bp->switch_id initialization to PF probe")
Reported-by: Marc Smith <msmith626@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |    7 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |    3 +++
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11299,7 +11299,7 @@ int bnxt_get_port_parent_id(struct net_d
 		return -EOPNOTSUPP;
 
 	/* The PF and it's VF-reps only support the switchdev framework */
-	if (!BNXT_PF(bp))
+	if (!BNXT_PF(bp) || !(bp->flags & BNXT_FLAG_DSN_VALID))
 		return -EOPNOTSUPP;
 
 	ppid->id_len = sizeof(bp->switch_id);
@@ -11691,6 +11691,7 @@ static int bnxt_pcie_dsn_get(struct bnxt
 	put_unaligned_le32(dw, &dsn[0]);
 	pci_read_config_dword(pdev, pos + 4, &dw);
 	put_unaligned_le32(dw, &dsn[4]);
+	bp->flags |= BNXT_FLAG_DSN_VALID;
 	return 0;
 }
 
@@ -11802,9 +11803,7 @@ static int bnxt_init_one(struct pci_dev
 
 	if (BNXT_PF(bp)) {
 		/* Read the adapter's DSN to use as the eswitch switch_id */
-		rc = bnxt_pcie_dsn_get(bp, bp->switch_id);
-		if (rc)
-			goto init_err_pci_clean;
+		bnxt_pcie_dsn_get(bp, bp->switch_id);
 	}
 
 	/* MTU range: 60 - FW defined max */
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1510,6 +1510,7 @@ struct bnxt {
 	#define BNXT_FLAG_NO_AGG_RINGS	0x20000
 	#define BNXT_FLAG_RX_PAGE_MODE	0x40000
 	#define BNXT_FLAG_MULTI_HOST	0x100000
+	#define BNXT_FLAG_DSN_VALID	0x200000
 	#define BNXT_FLAG_DOUBLE_DB	0x400000
 	#define BNXT_FLAG_CHIP_NITRO_A0	0x1000000
 	#define BNXT_FLAG_DIM		0x2000000
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -398,6 +398,9 @@ static int bnxt_vf_reps_create(struct bn
 	struct net_device *dev;
 	int rc, i;
 
+	if (!(bp->flags & BNXT_FLAG_DSN_VALID))
+		return -ENODEV;
+
 	bp->vf_reps = kcalloc(num_vfs, sizeof(vf_rep), GFP_KERNEL);
 	if (!bp->vf_reps)
 		return -ENOMEM;


