Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7876E41E5
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 10:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjDQICW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 04:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDQICQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 04:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F60F3595
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 01:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A9B361FAE
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2A6C433EF;
        Mon, 17 Apr 2023 08:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681718533;
        bh=jsj5L5tyhOe9L1i6cj2bJjEriaD0PXfZH7kQfSX71+I=;
        h=Subject:To:Cc:From:Date:From;
        b=CN3QbpY9dxfoIONY3NJPiBPBUZ7NihQCDTBSzdrDmvABZtlC3fDShlK4+G683076R
         slA76ErQsPKWnRwQINZUtgKaN6VhlfnpBO9cMhkT63zEvqz5UVu8ZMdQQ75HMVHYug
         7FfQtGnWY+pK3+c6NUGwejfaqPZTUy2nGrufq1J4=
Subject: FAILED: patch "[PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD" failed to apply to 6.1-stable tree
To:     dory@dory.moe, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 10:02:04 +0200
Message-ID: <2023041704-perch-bullion-073e@gregkh>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 74391b3e69855e7dd65a9cef36baf5fc1345affd
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041704-perch-bullion-073e@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
1231363aec86 ("nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN")

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

