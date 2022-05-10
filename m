Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14DB521A0B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242300AbiEJNxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245009AbiEJNrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF7D2380F7;
        Tue, 10 May 2022 06:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 467756188A;
        Tue, 10 May 2022 13:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC2C385C2;
        Tue, 10 May 2022 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189610;
        bh=n1KCDh4LONfKCtHsaCx9VaPa6rdpnvpNzEZKw6ZLikY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXyMIHKf/IF0HSnOhrCSp3oVJ9mIlDXXizhL7RIvEiN+bsgBzpz2pZlI7h8gyQhCj
         KjV2WgcGYuVAj7FtlL1RhvtDpCBBPyyZ3VSo+rRCIEUN+bZ1sEZjZZrrqpSxxRZblN
         D3Z/yp0+uZ5Xa+DOduQvKXccQaJz9ax3yRovM9ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 106/135] PCI: pci-bridge-emul: Add description for class_revision field
Date:   Tue, 10 May 2022 15:08:08 +0200
Message-Id: <20220510130743.448324699@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 9319230ac147067652b58fe849ffe0ceec098665 upstream.

The current assignment to the class_revision member

  class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);

can make the reader think that class is at high 16 bits of the member and
revision at low 16 bits.

In reality, class is at high 24 bits, but the class for PCI Bridge Normal
Decode is PCI_CLASS_BRIDGE_PCI << 8.

Change the assignment and add a comment to make this clearer.

Link: https://lore.kernel.org/r/20211130172913.9727-2-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -284,7 +284,11 @@ int pci_bridge_emul_init(struct pci_brid
 {
 	BUILD_BUG_ON(sizeof(bridge->conf) != PCI_BRIDGE_CONF_END);
 
-	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
+	/*
+	 * class_revision: Class is high 24 bits and revision is low 8 bit of this member,
+	 * while class for PCI Bridge Normal Decode has the 24-bit value: PCI_CLASS_BRIDGE_PCI << 8
+	 */
+	bridge->conf.class_revision |= cpu_to_le32((PCI_CLASS_BRIDGE_PCI << 8) << 8);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;
 	bridge->conf.status = cpu_to_le16(PCI_STATUS_CAP_LIST);


