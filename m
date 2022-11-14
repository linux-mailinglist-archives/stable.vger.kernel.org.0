Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB09627F24
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiKNMzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbiKNMzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C979F27CE4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64CA661154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABB8C433D6;
        Mon, 14 Nov 2022 12:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430551;
        bh=uZ9qsS0OYckpeb6kkaxh6OiW9o/2TJToXFfN4l5d9LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgUKG0+3A/gZxjboiza4lVob0dhbu5q3W9lvgnWkZKjcuif2e1SUIQhnAmxrPQdMz
         dO0MY77J+xzN8r1hsEVIoT4Xczy5STovNoX8aXFuew31VGpk3qfEVU3kFrqiWzUVmK
         b4xWpaoLfI0EawPEbVcPwBwmD3VpKrspNVbA3TSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/131] net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
Date:   Mon, 14 Nov 2022 13:45:29 +0100
Message-Id: <20221114124451.237943565@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit d38a648d2d6cc7bee11c6f533ff9426a00c2a74c ]

ipc_pcie_read_bios_cfg() is using the acpi_evaluate_dsm() to
obtain the wwan power state configuration from BIOS but is
not freeing the acpi_object. The acpi_evaluate_dsm() returned
acpi_object to be freed.

Free the acpi_object after use.

Fixes: 7e98d785ae61 ("net: iosm: entry point")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 2fe88b8be348..01df23835be0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -232,6 +232,7 @@ static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
  */
 static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 {
+	enum ipc_pcie_sleep_state sleep_state = IPC_PCIE_D0L12;
 	union acpi_object *object;
 	acpi_handle handle_acpi;
 
@@ -242,12 +243,16 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	}
 
 	object = acpi_evaluate_dsm(handle_acpi, &wwan_acpi_guid, 0, 3, NULL);
+	if (!object)
+		goto default_ret;
+
+	if (object->integer.value == 3)
+		sleep_state = IPC_PCIE_D3L2;
 
-	if (object && object->integer.value == 3)
-		return IPC_PCIE_D3L2;
+	kfree(object);
 
 default_ret:
-	return IPC_PCIE_D0L12;
+	return sleep_state;
 }
 
 static int ipc_pcie_probe(struct pci_dev *pci,
-- 
2.35.1



