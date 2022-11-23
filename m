Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662BB635DFA
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiKWMxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiKWMxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:53:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA308DA55;
        Wed, 23 Nov 2022 04:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE427B81F70;
        Wed, 23 Nov 2022 12:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3FEC433D7;
        Wed, 23 Nov 2022 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207508;
        bh=qB5XqF5nkXDbgvjE1KWxNlmDbGiUjFpQU0Hoc+cvTRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2nCRVmEnXBCjtXcQXQpA7Pw82sBDgwSW0UfEgeOzvkRWJyHPGAiHh/jc4gb4KeK7
         uS5Bk5SMe0IXJRVOuSE8ojlMiEdJf3khRUiQosVNI+HMWtLeWNnRPomApop+kduNCi
         IEp0Q5Mwna6XZrjRI9ZuFoTWZKsnT4py/HoTxgf2jXm8mWgHW6XGn7KxMpzqPwBp/V
         2pa9f5Ov6dKfhxSIJ60KrTPUUNwZDkXrlzeZOiyWLUTYX5jPPX5BAmOD6wvGF2551s
         y+Y4rlxegVDc8ikPVyZgj+29uiGzz3cuZo4RRUHbR3ZksH43N8TxjmeBqYA85Ve3f3
         Y5I9Rx6zB+0Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/11] platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
Date:   Wed, 23 Nov 2022 07:44:49 -0500
Message-Id: <20221123124458.266492-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
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
index 339b753ba447..3723ae37993d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1176,6 +1176,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
-- 
2.35.1

