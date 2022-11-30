Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271DF63E01C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiK3Sxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiK3Sxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1512F38D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 997EFB81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA43AC433C1;
        Wed, 30 Nov 2022 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834413;
        bh=GnznFkeWz1BM6kc4uNtVvw6nzrk+kR5vHJan/6Yl2AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oDUnNreZP5zpFF5jdtzB/fZau3T1w7qL22LPOmci7lEAbkSihIjkeCLQLSoHlPi4
         zwIcm8y3UMkt40S284JN0AXJfBQx8MOgMRCNyKj4iVu4Q44gD787n49iQMnWxjeoTn
         Z5B4IA/ldgxwt3nqEOM1op+lAKZDhdPwmfE/a/BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 245/289] platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
Date:   Wed, 30 Nov 2022 19:23:50 +0100
Message-Id: <20221130180549.663646498@linuxfoundation.org>
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



