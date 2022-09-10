Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633805B495E
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIJVTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIJVSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0D84BD0E;
        Sat, 10 Sep 2022 14:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845FB60E65;
        Sat, 10 Sep 2022 21:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18003C433D7;
        Sat, 10 Sep 2022 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844644;
        bh=k/IRruyCkZWhZI+atk2d7eT+R5sJKTlp9ZUCQcg/64c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T42lwsKWVgIEf3yVp6cCWjGLowj1CxEqw3PUoSu3s/utYi+QWwUDz+d2vo5Nf3M+b
         meCf/giYeCHDmzMbWv81dksXd3+Z6yn9B2MpgAVS2nF7OJH0ZJy7DnHqR8tVUtjGbv
         M0abV7UU8Hzy0FM1WXr+2A/Krdmd8ox6qNnMrT015FYPOP5hTH53KbUXMod0a4E+7B
         RFL1v/k4/3+TqsgiTo00qBFs2pRicefJnvWEols6bawuuwVSQqRcav73ouVOltcdf0
         TKFU75TpPowev+v8OBpVuMfAyIWzrMv2eG4wA+7Kl6aWz6AIMif+o+sDVDRrlolPgP
         DJZNixtrfh4pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyamin Ayesh <me@shyamin.com>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 26/38] nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610
Date:   Sat, 10 Sep 2022 17:16:11 -0400
Message-Id: <20220910211623.69825-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
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

From: Shyamin Ayesh <me@shyamin.com>

[ Upstream commit 200dccd07df21b504a2168960059f0a971bf415d ]

Lexar NM610 reports bogus eui64 values that appear to be the same across
all drives. Quirk them out so they are not marked as "non globally unique"
duplicates.

Signed-off-by: Shyamin Ayesh <me@shyamin.com>
[patch formatting]
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 73d9fcba3b1c0..9f6614f7dbeb1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3517,6 +3517,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.35.1

