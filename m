Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF62635E3F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiKWMvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbiKWMvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:51:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248487EC8A;
        Wed, 23 Nov 2022 04:44:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D1AE61CAC;
        Wed, 23 Nov 2022 12:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B17C433D6;
        Wed, 23 Nov 2022 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207447;
        bh=RW4HlKrC8HJ1IjGXRBDcvUafv7RxhxgfYV7vWL5KbOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKwsxoTfPXwjYPOAfpkBSTZ7MjKUFdJ38TGWkamu32/BWNk0lLY52sAjFRklqx+IE
         2aFDlfqpZPc1k8lZjQptvza74vC5203tVRgMm9vZfQ7RT7Dhp6pjaUVFhs/iQ5JKH1
         P2fR6m8kF9YnpRSduZUDHcVjIAyhsvIdbNXxWwLp2ljyeUqf3fN5lvldXQAs8Tlibf
         aSvgGRtxZ3y5T1C6v8Tltq0p07ma4jpE0J6n6Xrg62clmsUGzuMqCikgcjUEfGltTk
         +NsSl9aeWcfBQ+F/SO1GTln6t9IOa/YnPBIWhPTgVzKh7r9rhekcOOhti+qSyjK3YJ
         PPMk9Vy+XzPFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 09/22] xen-pciback: Allow setting PCI_MSIX_FLAGS_MASKALL too
Date:   Wed, 23 Nov 2022 07:43:24 -0500
Message-Id: <20221123124339.265912-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124339.265912-1-sashal@kernel.org>
References: <20221123124339.265912-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

[ Upstream commit 5e29500eba2aa19e1323df46f64dafcd4a327092 ]

When Xen domain configures MSI-X, the usual approach is to enable MSI-X
together with masking all of them via the config space, then fill the
table and only then clear PCI_MSIX_FLAGS_MASKALL. Allow doing this via
QEMU running in a stub domain.

Previously, when changing PCI_MSIX_FLAGS_MASKALL was not allowed, the
whole write was aborted, preventing change to the PCI_MSIX_FLAGS_ENABLE
bit too.

Note the Xen hypervisor intercepts this write anyway, and may keep the
PCI_MSIX_FLAGS_MASKALL bit set if it wishes to. It will store the
guest-requested state and will apply it eventually.

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Link: https://lore.kernel.org/r/20221114103110.1519413-1-marmarek@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/conf_space_capability.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/conf_space_capability.c b/drivers/xen/xen-pciback/conf_space_capability.c
index 5e53b4817f16..097316a74126 100644
--- a/drivers/xen/xen-pciback/conf_space_capability.c
+++ b/drivers/xen/xen-pciback/conf_space_capability.c
@@ -190,13 +190,16 @@ static const struct config_field caplist_pm[] = {
 };
 
 static struct msi_msix_field_config {
-	u16          enable_bit; /* bit for enabling MSI/MSI-X */
-	unsigned int int_type;   /* interrupt type for exclusiveness check */
+	u16          enable_bit;   /* bit for enabling MSI/MSI-X */
+	u16          allowed_bits; /* bits allowed to be changed */
+	unsigned int int_type;     /* interrupt type for exclusiveness check */
 } msi_field_config = {
 	.enable_bit	= PCI_MSI_FLAGS_ENABLE,
+	.allowed_bits	= PCI_MSI_FLAGS_ENABLE,
 	.int_type	= INTERRUPT_TYPE_MSI,
 }, msix_field_config = {
 	.enable_bit	= PCI_MSIX_FLAGS_ENABLE,
+	.allowed_bits	= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL,
 	.int_type	= INTERRUPT_TYPE_MSIX,
 };
 
@@ -229,7 +232,7 @@ static int msi_msix_flags_write(struct pci_dev *dev, int offset, u16 new_value,
 		return 0;
 
 	if (!dev_data->allow_interrupt_control ||
-	    (new_value ^ old_value) & ~field_config->enable_bit)
+	    (new_value ^ old_value) & ~field_config->allowed_bits)
 		return PCIBIOS_SET_FAILED;
 
 	if (new_value & field_config->enable_bit) {
-- 
2.35.1

