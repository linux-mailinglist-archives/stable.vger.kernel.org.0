Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752842A15E6
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgJaLjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgJaLfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0562074F;
        Sat, 31 Oct 2020 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144134;
        bh=BanLibDslFMxKfSMB5bNdcEGkbpjh87fOkqxDs6YsOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jeq2geBeDzsr4jVEZgU/vEdEZiPdUc2V17kU8tmXZZZUofz6rKbLw+NqnlG5dxxHb
         fE7FfeawJRDDzPSMHSpf+M3lUnna4+L7GNMyihdeLRwCykEJP00Zqfv/wHNA7LckXz
         MnyX06vODf7r76BR/2HxDcurIGM04hY3Rg95X+tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Oleksandr Shamray <oleksandrs@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 18/49] mlxsw: core: Fix memory leak on module removal
Date:   Sat, 31 Oct 2020 12:35:14 +0100
Message-Id: <20201031113456.326785907@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit adc80b6cfedff6dad8b93d46a5ea2775fd5af9ec ]

Free the devlink instance during the teardown sequence in the non-reload
case to avoid the following memory leak.

unreferenced object 0xffff888232895000 (size 2048):
  comm "modprobe", pid 1073, jiffies 4295568857 (age 164.871s)
  hex dump (first 32 bytes):
    00 01 00 00 00 00 ad de 22 01 00 00 00 00 ad de  ........".......
    10 50 89 32 82 88 ff ff 10 50 89 32 82 88 ff ff  .P.2.....P.2....
  backtrace:
    [<00000000c704e9a6>] __kmalloc+0x13a/0x2a0
    [<00000000ee30129d>] devlink_alloc+0xff/0x760
    [<0000000092ab3e5d>] 0xffffffffa042e5b0
    [<000000004f3f8a31>] 0xffffffffa042f6ad
    [<0000000092800b4b>] 0xffffffffa0491df3
    [<00000000c4843903>] local_pci_probe+0xcb/0x170
    [<000000006993ded7>] pci_device_probe+0x2c2/0x4e0
    [<00000000a8e0de75>] really_probe+0x2c5/0xf90
    [<00000000d42ba75d>] driver_probe_device+0x1eb/0x340
    [<00000000bcc95e05>] device_driver_attach+0x294/0x300
    [<000000000e2bc177>] __driver_attach+0x167/0x2f0
    [<000000007d44cd6e>] bus_for_each_dev+0x148/0x1f0
    [<000000003cd5a91e>] driver_attach+0x45/0x60
    [<000000000041ce51>] bus_add_driver+0x3b8/0x720
    [<00000000f5215476>] driver_register+0x230/0x4e0
    [<00000000d79356f5>] __pci_register_driver+0x190/0x200

Fixes: a22712a96291 ("mlxsw: core: Fix devlink unregister flow")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Vadim Pasternak <vadimp@nvidia.com>
Tested-by: Oleksandr Shamray <oleksandrs@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1281,6 +1281,8 @@ void mlxsw_core_bus_device_unregister(st
 	if (!reload)
 		devlink_resources_unregister(devlink, NULL);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
+	if (!reload)
+		devlink_free(devlink);
 
 	return;
 


