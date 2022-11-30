Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D445C63DF84
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiK3Sr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiK3Srz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2593815FCE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B658361D74
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46E2C433D7;
        Wed, 30 Nov 2022 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834072;
        bh=pghWzr987WErM7R0k86Xmm4qfYwvkEnvraBvVp1CQeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOG+0xwvVzyLY3HGffzav2/gFQUoZFGT3fY/W4JN8mMRSEgYJRqOGepaZvG62LVy/
         QYAwjdlUcN6+um54xlnLThW3eCEfgZnVlj60kwXyMIV8DMxnuT8+NhSmLrgkjVi+Et
         UCPyovJVBdJF44Duj0YwjG0C4e4ep3fk+jY5U+Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 119/289] net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()
Date:   Wed, 30 Nov 2022 19:21:44 +0100
Message-Id: <20221130180546.838021766@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit e541dd7763fc34aec2f93f652a396cc2e7b92d8d ]

acpi_evaluate_dsm() should be coupled with ACPI_FREE() to free the ACPI
memory, because we need to track the allocation of acpi_object when
ACPI_DBG_TRACK_ALLOCATIONS enabled, so use ACPI_FREE() instead of kfree().

Fixes: d38a648d2d6c ("net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221118062447.2324881-1-bobo.shaobowang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 97cb6846c6ae..f604d4a01e1b 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -249,7 +249,7 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	if (object->integer.value == 3)
 		sleep_state = IPC_PCIE_D3L2;
 
-	kfree(object);
+	ACPI_FREE(object);
 
 default_ret:
 	return sleep_state;
-- 
2.35.1



