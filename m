Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87B1991AC
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgCaJKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbgCaJKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9149C20675;
        Tue, 31 Mar 2020 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645849;
        bh=tgP0f73IQfr9nhtgKblge+hnEzvHdlEOvF/a/Acmk6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oODtG07rCqcLvaAVl7ASzfr73SA8Y7n4zxA6rx4T3Wge95VipSVLzbdxtvhNUFnD+
         fvwZjOsINST1QblyFBEZhYhB9stbdor9qmK04ERT9gkzgxwtk8AGp0phIWTAYYxKEo
         7WqH+iQhETEK9kFDCppy3ZrMTm5E4RbZSmZmJqbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 013/155] mlxsw: pci: Only issue reset when system is ready
Date:   Tue, 31 Mar 2020 10:57:33 +0200
Message-Id: <20200331085419.871902898@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 6002059d7882c3512e6ac52fa82424272ddfcd5c ]

During initialization the driver issues a software reset command and
then waits for the system status to change back to "ready" state.

However, before issuing the reset command the driver does not check that
the system is actually in "ready" state. On Spectrum-{1,2} systems this
was always the case as the hardware initialization time is very short.
On Spectrum-3 systems this is no longer the case. This results in the
software reset command timing-out and the driver failing to load:

[ 6.347591] mlxsw_spectrum3 0000:06:00.0: Cmd exec timed-out (opcode=40(ACCESS_REG),opcode_mod=0,in_mod=0)
[ 6.358382] mlxsw_spectrum3 0000:06:00.0: Reg cmd access failed (reg_id=9023(mrsr),type=write)
[ 6.368028] mlxsw_spectrum3 0000:06:00.0: cannot register bus device
[ 6.375274] mlxsw_spectrum3: probe of 0000:06:00.0 failed with error -110

Fix this by waiting for the system to become ready both before issuing
the reset command and afterwards. In case of failure, print the last
system status to aid in debugging.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c |   50 +++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1318,36 +1318,64 @@ static void mlxsw_pci_mbox_free(struct m
 			    mbox->mapaddr);
 }
 
-static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
-			      const struct pci_device_id *id)
+static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
+				    const struct pci_device_id *id,
+				    u32 *p_sys_status)
 {
 	unsigned long end;
-	char mrsr_pl[MLXSW_REG_MRSR_LEN];
-	int err;
+	u32 val;
 
-	mlxsw_reg_mrsr_pack(mrsr_pl);
-	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
-	if (err)
-		return err;
 	if (id->device == PCI_DEVICE_ID_MELLANOX_SWITCHX2) {
 		msleep(MLXSW_PCI_SW_RESET_TIMEOUT_MSECS);
 		return 0;
 	}
 
-	/* We must wait for the HW to become responsive once again. */
+	/* We must wait for the HW to become responsive. */
 	msleep(MLXSW_PCI_SW_RESET_WAIT_MSECS);
 
 	end = jiffies + msecs_to_jiffies(MLXSW_PCI_SW_RESET_TIMEOUT_MSECS);
 	do {
-		u32 val = mlxsw_pci_read32(mlxsw_pci, FW_READY);
-
+		val = mlxsw_pci_read32(mlxsw_pci, FW_READY);
 		if ((val & MLXSW_PCI_FW_READY_MASK) == MLXSW_PCI_FW_READY_MAGIC)
 			return 0;
 		cond_resched();
 	} while (time_before(jiffies, end));
+
+	*p_sys_status = val & MLXSW_PCI_FW_READY_MASK;
+
 	return -EBUSY;
 }
 
+static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
+			      const struct pci_device_id *id)
+{
+	struct pci_dev *pdev = mlxsw_pci->pdev;
+	char mrsr_pl[MLXSW_REG_MRSR_LEN];
+	u32 sys_status;
+	int err;
+
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to reach system ready status before reset. Status is 0x%x\n",
+			sys_status);
+		return err;
+	}
+
+	mlxsw_reg_mrsr_pack(mrsr_pl);
+	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
+	if (err)
+		return err;
+
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to reach system ready status after reset. Status is 0x%x\n",
+			sys_status);
+		return err;
+	}
+
+	return 0;
+}
+
 static int mlxsw_pci_alloc_irq_vectors(struct mlxsw_pci *mlxsw_pci)
 {
 	int err;


