Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543956ECDA3
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjDXNZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjDXNZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4C526C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70933622A2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820D9C433D2;
        Mon, 24 Apr 2023 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342708;
        bh=klTnNbqhhHKwmr0mRHTpdwPsdjCQ7bdTFVzX8ykdOSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psKZxd6ScLjTorkqaovegxaoZs0w5lSb9OlZIZltNntpaniAH/W1rAoZ/+WeogRq2
         OEEHUkh2NOr7cN6zcxoCzDUibsmv2zzBviqcV0fHq8Wugvz5cOr4paH6zGodoqP/3L
         czrvtx3xpVBfCEAoPqjVjxqdGz65a0kZ63NjQlJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/98] mlxsw: pci: Fix possible crash during initialization
Date:   Mon, 24 Apr 2023 15:16:51 +0200
Message-Id: <20230424131134.988156303@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1f64757ee2bb22a93ec89b4c71707297e8cca0ba ]

During initialization the driver issues a reset command via its command
interface in order to remove previous configuration from the device.

After issuing the reset, the driver waits for 200ms before polling on
the "system_status" register using memory-mapped IO until the device
reaches a ready state (0x5E). The wait is necessary because the reset
command only triggers the reset, but the reset itself happens
asynchronously. If the driver starts polling too soon, the read of the
"system_status" register will never return and the system will crash
[1].

The issue was discovered when the device was flashed with a development
firmware version where the reset routine took longer to complete. The
issue was fixed in the firmware, but it exposed the fact that the
current wait time is borderline.

Fix by increasing the wait time from 200ms to 400ms. With this patch and
the buggy firmware version, the issue did not reproduce in 10 reboots
whereas without the patch the issue is reproduced quite consistently.

[1]
mce: CPUs not responding to MCE broadcast (may include false positives): 0,4
mce: CPUs not responding to MCE broadcast (may include false positives): 0,4
Kernel panic - not syncing: Timeout: Not all CPUs entered broadcast exception handler
Shutting down cpus with NMI
Kernel Offset: 0x12000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: ac004e84164e ("mlxsw: pci: Wait longer before accessing the device after reset")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 48dbfea0a2a1d..7cdf0ce24f288 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -26,7 +26,7 @@
 #define MLXSW_PCI_CIR_TIMEOUT_MSECS		1000
 
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		400
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
-- 
2.39.2



