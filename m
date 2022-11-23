Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D1B635D6A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiKWMoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbiKWMnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E442B6D975;
        Wed, 23 Nov 2022 04:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D84B81F38;
        Wed, 23 Nov 2022 12:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69214C433C1;
        Wed, 23 Nov 2022 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207313;
        bh=GnznFkeWz1BM6kc4uNtVvw6nzrk+kR5vHJan/6Yl2AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4ENGVcTcsr96ZvkS9Jrk5oJ2tfqBEkbRCQFffpCxoNn4T7Rs8XEz6+jPt0Wh5V2w
         q8MrHcylE7Hb7ClVNFoDTm6T7CYcoDkvXJ7EB+ALF0XSYwO/PIw0lAoXz1+hq0V8C3
         utQ2tNYqotGXIGmp+PDG4fi+Aa+VEaJsng2uR732lnYfP42zBUtad7c7flHAo3jR2F
         C0mXORGD+DpiS8iF/fNdIi2DaECDtYGSUI1RL8PmC8kLe0+KF1+zrEW7eceCaKushX
         QSXZ7nseDl5Qh3ElhkIHx5aJZ03bIK35tu3FybYAoahakwqCrXsW99E8nmCrpKTkNp
         Xq3nQB1PjIYLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 23/44] platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
Date:   Wed, 23 Nov 2022 07:40:32 -0500
Message-Id: <20221123124057.264822-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit d0cdd85046b15089df71a50548617ac1025300d0 ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before asus_wmi_set_xusb2pr() returns.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221111100752.134311-1-wangxiongfeng2@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index eec7d0ed7cf2..8e1979b477a7 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1656,6 +1656,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
-- 
2.35.1

