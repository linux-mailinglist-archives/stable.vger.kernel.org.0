Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75567551D15
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245434AbiFTNPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbiFTNOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F13E1FCE6;
        Mon, 20 Jun 2022 06:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329BC614E9;
        Mon, 20 Jun 2022 13:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A5C3411C;
        Mon, 20 Jun 2022 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730257;
        bh=02UmM0q3jA33fUQBUc8MJyNymoomP4LfNrzJVtLqnjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUmUV2lgltgwb4bYAwT3OsdO8hjBRCEtXaIFRCAZEyZue0gGsRG99kDKYAcEh5JEw
         J7z/TPHYRZaRpsxb0ad0hy1mEXEriOiRv5aFhwzpDCFUGKNPx0BfHd4NOSbYpd+r98
         r/q8rHFm8aj4akFud2iII77Z9LbjrVZ0cCoaTwRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.10 81/84] Revert "PCI: Make pci_enable_ptm() private"
Date:   Mon, 20 Jun 2022 14:51:44 +0200
Message-Id: <20220620124723.283894071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

commit 1d71eb53e45187f58089d32b51e27784c791d90e upstream.

Make pci_enable_ptm() accessible from the drivers.

Exposing this to the driver enables the driver to use the
'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.

This reverts commit ac6c26da29c1 ("PCI: Make pci_enable_ptm() private").

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.h   |    3 ---
 include/linux/pci.h |    7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -585,11 +585,8 @@ static inline void pcie_ecrc_get_policy(
 
 #ifdef CONFIG_PCIE_PTM
 void pci_ptm_init(struct pci_dev *dev);
-int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
 #else
 static inline void pci_ptm_init(struct pci_dev *dev) { }
-static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
-{ return -EINVAL; }
 #endif
 
 struct pci_dev_reset_methods {
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1599,6 +1599,13 @@ static inline bool pci_aer_available(voi
 
 bool pci_ats_disabled(void);
 
+#ifdef CONFIG_PCIE_PTM
+int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
+#else
+static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
+{ return -EINVAL; }
+#endif
+
 void pci_cfg_access_lock(struct pci_dev *dev);
 bool pci_cfg_access_trylock(struct pci_dev *dev);
 void pci_cfg_access_unlock(struct pci_dev *dev);


