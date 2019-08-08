Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0258B869AB
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405129AbfHHTJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405117AbfHHTJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE36021743;
        Thu,  8 Aug 2019 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291375;
        bh=fPjyKWjqbff7ewKV5FEwt3VJernzWM6g/qqYgqjs4WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hulqs+/NfW6bkrMwkPMzQP2ua79xeTUAB/SPicZPa9tD8vhw4ukPm2wpw/sFhsbA9
         9qbNggypMsi1a2yjrM1HzkIp8PTaYCRdQmwDPBfcD635sZyXKoPy+LaF1SyZAFB9JX
         JQxTuSexmu4DOqVmkFCuhl5z8svntr8PZ+vT9LDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 18/45] mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()
Date:   Thu,  8 Aug 2019 21:05:04 +0200
Message-Id: <20190808190454.757996450@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 28fe79000e9b0a6f99959869947f1ca305f14599 ]

In case of sp2 pci driver registration fail, fix the error path to
start with sp1 pci driver unregister.

Fixes: c3ab435466d5 ("mlxsw: spectrum: Extend to support Spectrum-2 ASIC")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5032,7 +5032,7 @@ static int __init mlxsw_sp_module_init(v
 	return 0;
 
 err_sp2_pci_driver_register:
-	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
+	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
 err_sp1_pci_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 err_sp2_core_driver_register:


