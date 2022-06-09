Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD7D544639
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242305AbiFIIoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 04:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242515AbiFIInD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 04:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C9B4A9;
        Thu,  9 Jun 2022 01:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1DFBB82C83;
        Thu,  9 Jun 2022 08:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62235C3411B;
        Thu,  9 Jun 2022 08:41:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aSNkRAYF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654764094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2dDMHfrQBIFCsGOyc6iUSyEV9nvom4+iCQjiNqjREs=;
        b=aSNkRAYF0Iq1LpZDCM7juqJ+gmJryJUgZG6y9XAnk2+DePTMoHgr+sclGaRCohaFQFweOd
        YxUrpiBtMxpl7l7zM8uElKABfGbFlATl5gyUp0IzdbHXGMjZgOMKf9No6Nun9JMLXi01cf
        4/N04tfzPxdjxT+AC6OA+vlxKu5CnBI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2561c0a4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 9 Jun 2022 08:41:33 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>, alan.adamson@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>,
        Keith Busch <kbusch@kernel.org>, axboe@fb.com,
        Christoph Hellwig <hch@lst.de>, abhijeet.rao@intel.com,
        monish.kumar.r@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "nvme-pci: add quirks for Samsung X5 SSDs"
Date:   Thu,  9 Jun 2022 10:40:51 +0200
Message-Id: <20220609084051.4445-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9o-orF52HzkT80054e3Op5fLOcTHb-KHpvvU7H3FpAJ7A@mail.gmail.com>
References: <CAHmME9o-orF52HzkT80054e3Op5fLOcTHb-KHpvvU7H3FpAJ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit bc360b0b1611566e1bd47384daf49af6a1c51837.

This matches the hardware identifier of the Samsung 970 EVO Plus, a very
popular internal laptop NVMe drive, which is not the Samsung X5, an
external thunderbolt drive. In particular, this causes:

1) a 2.3 second boot time delay; and
2) disabling of deep power saving states.

So just revert this until whatever funny business can be worked out
regarding Samsung's PCI IDs.

Fixes: bc360b0b1611 ("nvme-pci: add quirks for Samsung X5 SSDs")
Cc: stable@vger.kernel.org
Cc: Monish Kumar R <monish.kumar.r@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/nvme/host/pci.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 48f4f6eb877b..47b9e3e0ea5a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3483,10 +3483,7 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
-		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
-				NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
-- 
2.35.1

