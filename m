Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151076E41E8
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 10:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDQICY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 04:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjDQICW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 04:02:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F933594
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 01:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AD561FC0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F7FC433D2;
        Mon, 17 Apr 2023 08:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681718540;
        bh=CrT9gSWa9e7ba/levl417NPwTL/18Xv7pjsmoJSZMN4=;
        h=Subject:To:Cc:From:Date:From;
        b=t/o7o98UOjguMszUvU7PsCf9ZazcLcfLIzgPlT9/AGCEcTQ7ZMrwRNEvhLIr53h22
         XWXTEN1lcXCmEElhvtLM1yhL/1fsE3svOdtZIeGOzLzcBiOWBmNCLnvcsQBDREBwek
         ug04pfvdg+zNGCL/sSyi1zC3CbdHrc90ZrjxoILc=
Subject: FAILED: patch "[PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD" failed to apply to 5.10-stable tree
To:     dory@dory.moe, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 10:02:06 +0200
Message-ID: <2023041706-from-upper-6dbc@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 74391b3e69855e7dd65a9cef36baf5fc1345affd
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041706-from-upper-6dbc@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
1231363aec86 ("nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN")
80b2624094c8 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM760")
200dccd07df2 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610")
d6c52fa3e955 ("nvme-pci: Crucial P2 has bogus namespace ids")
6b961bce50e4 ("nvme-pci: avoid the deepest sleep state on ZHITAI TiPro7000 SSDs")
3765fad50896 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG GAMMIX S50")
a98a945b80f8 ("nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202")
4bdf260362b3 ("nvme: add 48-bit DMA address quirk for Amazon NVMe controllers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74391b3e69855e7dd65a9cef36baf5fc1345affd Mon Sep 17 00:00:00 2001
From: Duy Truong <dory@dory.moe>
Date: Thu, 13 Apr 2023 17:55:48 -0700
Subject: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD

Added a quirk to fix the TeamGroup T-Force Cardea Zero Z330 SSDs reporting
duplicate NGUIDs.

Signed-off-by: Duy Truong <dory@dory.moe>
Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 282d808400c5..cd7873de3121 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3443,6 +3443,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),

