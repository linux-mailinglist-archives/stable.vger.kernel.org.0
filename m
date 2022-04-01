Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2614EF474
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiDAPEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349360AbiDAOzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF755A8;
        Fri,  1 Apr 2022 07:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B036060A53;
        Fri,  1 Apr 2022 14:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4CDC3410F;
        Fri,  1 Apr 2022 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824203;
        bh=aAtUW6xzviuFlUiqNktomCAuc9i20pmfxhiullHdCE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5Nkge55mv/f6JJwxoml31LGIZvhKjpfU7bTeKoJ7aMxRUj/yhaShadYaNXmaEfo7
         CMfwMyAQu/LlCsXmW22Vv+pQlJyqSuSeMxoUzcwupW34Jn3pCLluvzVpqvUvHsGz+o
         qEirMtn/zjA/n6s+oUl/CspKr67R+GB5JzZW0QOFjbu6oFNwsmgF5LSqTHqfNlJyw4
         Gz3vNNr0Jehzu6DUc4b0JDhJcIQBydbVp8q4PdOugQXZbAB2BajzzQl1tfdb+thXoo
         5GeCNvjSSTlPRfItWHs3IpVHqnXIXVv2M4LD+uXrPY8YbMX+mPbsMiat5/voQGFlIu
         G0521rpFoAvDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, lukas@wunner.de,
        naveennaidu479@gmail.com, mani@kernel.org, hdegoede@redhat.com,
        zhangliguang@linux.alibaba.com, ameynarkhede03@gmail.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/65] PCI: pciehp: Add Qualcomm quirk for Command Completed erratum
Date:   Fri,  1 Apr 2022 10:41:27 -0400
Message-Id: <20220401144206.1953700-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 9f72d4757cbe4d1ed669192f6d23817c9e437c4b ]

The Qualcomm PCI bridge device (Device ID 0x0110) found in chipsets such as
SM8450 does not set the Command Completed bit unless writes to the Slot
Command register change "Control" bits.

This results in timeouts like below:

  pcieport 0001:00:00.0: pciehp: Timeout on hotplug command 0x03c0 (issued 2020 msec ago)

Add the device to the Command Completed quirk to mark commands "completed"
immediately unless they change the "Control" bits.

Link: https://lore.kernel.org/r/20220210145003.135907-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 30708af975ad..ee43c85d3cd2 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1058,6 +1058,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0110,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0400,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0401,
-- 
2.34.1

