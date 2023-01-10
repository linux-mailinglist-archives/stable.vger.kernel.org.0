Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2CA664AE6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbjAJShg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbjAJSgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:36:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295EC8F2B1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 968A4CE18B3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B93FC433D2;
        Tue, 10 Jan 2023 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375512;
        bh=Dm/YtF3GZklzKstOwt2dcrdE8o2PMXfQTqoOEEhpbDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz1j5looCZQhmHWJ3w3f1q0F6nrRdjBUz6UHE39UKLSnYNpwHkwrdBH98Vv2meL6B
         b/vhkxtpmor2DiMnN54RxVwouFcjuJuQ7ir4cRNiKRJRNIsYZVvRmG/We692J7HpvC
         rDOtfeKvEFOHcaPK65Qw1R0cV6Qp4XQna6O0mnFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/290] qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
Date:   Tue, 10 Jan 2023 19:05:06 +0100
Message-Id: <20230110180039.385986892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 13a7c8964afcd8ca43c0b6001ebb0127baa95362 ]

adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
case qlcnic_dcb_attach() would return an error, which always happens
under OOM conditions. This would lead to use-after-free because both
of the existing callers invoke qlcnic_dcb_get_info() on the obtained
pointer, which is potentially freed at that point.

Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
pointer at callsite using qlcnic_dcb_free(). This also removes the now
unused qlcnic_clear_dcb_ops() helper, which was a simple wrapper around
kfree() also causing memory leaks for partially initialized dcb.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 3c44bba1d270 ("qlcnic: Disable DCB operations from SR-IOV VFs")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  8 +++++++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 10 ++--------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |  8 +++++++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index 27dffa299ca6..7c3cf9ad4563 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2505,7 +2505,13 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter, int pci_using_dac)
 		goto disable_mbx_intr;
 
 	qlcnic_83xx_clear_function_resources(adapter);
-	qlcnic_dcb_enable(adapter->dcb);
+
+	err = qlcnic_dcb_enable(adapter->dcb);
+	if (err) {
+		qlcnic_dcb_free(adapter->dcb);
+		goto disable_mbx_intr;
+	}
+
 	qlcnic_83xx_initialize_nic(adapter, 1);
 	qlcnic_dcb_get_info(adapter->dcb);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index 7519773eaca6..22afa2be85fd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -41,11 +41,6 @@ struct qlcnic_dcb {
 	unsigned long			state;
 };
 
-static inline void qlcnic_clear_dcb_ops(struct qlcnic_dcb *dcb)
-{
-	kfree(dcb);
-}
-
 static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 {
 	if (dcb && dcb->ops->get_hw_capability)
@@ -112,9 +107,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
 		dcb->ops->init_dcbnl_ops(dcb);
 }
 
-static inline void qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
+static inline int qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
 {
-	if (dcb && qlcnic_dcb_attach(dcb))
-		qlcnic_clear_dcb_ops(dcb);
+	return dcb ? qlcnic_dcb_attach(dcb) : 0;
 }
 #endif
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 75960a29f80e..cec07d5bbe67 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2616,7 +2616,13 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "Device does not support MSI interrupts\n");
 
 	if (qlcnic_82xx_check(adapter)) {
-		qlcnic_dcb_enable(adapter->dcb);
+		err = qlcnic_dcb_enable(adapter->dcb);
+		if (err) {
+			qlcnic_dcb_free(adapter->dcb);
+			dev_err(&pdev->dev, "Failed to enable DCB\n");
+			goto err_out_free_hw;
+		}
+
 		qlcnic_dcb_get_info(adapter->dcb);
 		err = qlcnic_setup_intr(adapter);
 
-- 
2.35.1



