Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD03D6D4980
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjDCOi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjDCOi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C889F3C23
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C016B81CBC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18B3C433EF;
        Mon,  3 Apr 2023 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532704;
        bh=5eV74yvYIvmyDtYfV8PPpV4c+wtIjm40vhyr2Ff9WbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pC7GnPqMRGv8PUeZmhcib7zDAT/zsPqtQjgEkypj3KSKXQSAIXlLfb1TM8m9RK/M3
         0+am2UWrMUsyIU79bGQLVnMSWwHgWaLYSo7daqCE5u194/Tvxe4D2UsD2C3owlBaU0
         NUhxUMo6Pf3krc1DTLVROF40UUenDkagXMKta0Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Philipp Geulen <p.geulen@js-elektronik.de>,
        Chaitanya Kulkarni <kkch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/181] nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM620
Date:   Mon,  3 Apr 2023 16:08:09 +0200
Message-Id: <20230403140416.912193628@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Geulen <p.geulen@js-elektronik.de>

[ Upstream commit b65d44fa0fe072c91bf41cd8756baa2b4c77eff2 ]

Added a quirk to fix Lexar NM620 1TB SSD reporting duplicate NGUIDs.

Signed-off-by: Philipp Geulen <p.geulen@js-elektronik.de>
Reviewed-by: Chaitanya Kulkarni <kkch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 100f774bc97fa..60452f6a9f711 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3547,6 +3547,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x1d97), /* Lexar NM620 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
-- 
2.39.2



