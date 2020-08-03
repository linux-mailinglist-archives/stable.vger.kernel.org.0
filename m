Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42F323A5FA
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgHCM3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgHCM3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D022204EC;
        Mon,  3 Aug 2020 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457739;
        bh=cBXhftpuqSNUpg2hO4V9WZgyqofKDY4TSpRr8THldk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vdu4vBGQ6H3ePHNDY/3aALnlBfzgQh7nwoGhMGNf7p5JhQFykNDiHb1EMkbbRYJRb
         bEnFhwB/04G56JVH5T5ekqq40E0I1nFQC/F0aaM4OcpZHF5mWg23rALNwG/XF4X2xC
         LRtsFJew9Sp8SnJJ0Bp6jka0T6HiwOWdPnsQEy2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jake Lawrence <lawja@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/90] mlx4: disable device on shutdown
Date:   Mon,  3 Aug 2020 14:19:17 +0200
Message-Id: <20200803121900.288365745@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3cab8c65525920f00d8f4997b3e9bb73aecb3a8e ]

It appears that not disabling a PCI device on .shutdown may lead to
a Hardware Error with particular (perhaps buggy) BIOS versions:

    mlx4_en: eth0: Close port called
    mlx4_en 0000:04:00.0: removed PHC
    reboot: Restarting system
    {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
    {1}[Hardware Error]: event severity: fatal
    {1}[Hardware Error]:  Error 0, type: fatal
    {1}[Hardware Error]:   section_type: PCIe error
    {1}[Hardware Error]:   port_type: 4, root port
    {1}[Hardware Error]:   version: 1.16
    {1}[Hardware Error]:   command: 0x4010, status: 0x0143
    {1}[Hardware Error]:   device_id: 0000:00:02.2
    {1}[Hardware Error]:   slot: 0
    {1}[Hardware Error]:   secondary_bus: 0x04
    {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x2f06
    {1}[Hardware Error]:   class_code: 000604
    {1}[Hardware Error]:   bridge: secondary_status: 0x2000, control: 0x0003
    {1}[Hardware Error]:   aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00000000
    {1}[Hardware Error]:   aer_uncor_severity: 0x00062030
    {1}[Hardware Error]:   TLP Header: 40000018 040000ff 791f4080 00000000
[hw error repeats]
    Kernel panic - not syncing: Fatal hardware error!
    CPU: 0 PID: 2189 Comm: reboot Kdump: loaded Not tainted 5.6.x-blabla #1
    Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 05/05/2017

Fix the mlx4 driver.

This is a very similar problem to what had been fixed in:
commit 0d98ba8d70b0 ("scsi: hpsa: disable device during shutdown")
to address https://bugzilla.kernel.org/show_bug.cgi?id=199779.

Fixes: 2ba5fbd62b25 ("net/mlx4_core: Handle AER flow properly")
Reported-by: Jake Lawrence <lawja@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 87c2e8de61029..942646fb2256c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4354,12 +4354,14 @@ end:
 static void mlx4_shutdown(struct pci_dev *pdev)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct mlx4_dev *dev = persist->dev;
 
 	mlx4_info(persist->dev, "mlx4_shutdown was called\n");
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	mlx4_pci_disable_device(dev);
 }
 
 static const struct pci_error_handlers mlx4_err_handler = {
-- 
2.25.1



