Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22477566CE5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiGEMUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbiGEMTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0611ADA6;
        Tue,  5 Jul 2022 05:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 857E3CE1A19;
        Tue,  5 Jul 2022 12:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965E4C341C7;
        Tue,  5 Jul 2022 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023300;
        bh=4WXz2y68FOjP0HgfcdIFWltw+CyggqE2EdWR0mX+PZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR1kn+94DAfMR20vOpIu9PHviUs4TqLMHgXqkRs9o02KLlOcMIWCV2fL6CWoRWUnz
         Z4CSEKcByHysgNtcT9QivK3xAkvSPlwVfM0S3lvVxnX2jh6g59zYXLfblxnjSe2CG0
         MhcyUZX9NKAa62k6xAfl1htsqFAGc2FFKUyD2Ifs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Felipe=20de=20Jesus=20Araujo=20da=20Concei=C3=A7=C3=A3o?= 
        <felipe.conceicao@petrosoftdesign.com>,
        "Lamarque V. Souza" <lamarque.souza@petrosoftdesign.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.18 011/102] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA IM2P33F8ABR1
Date:   Tue,  5 Jul 2022 13:57:37 +0200
Message-Id: <20220705115618.736191551@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lamarque Vieira Souza <lamarque@petrosoftdesign.com>

commit e1c70d79346356bb1ede3f79436df80917845ab9 upstream.

ADATA IM2P33F8ABR1 reports bogus eui64 values that appear to be the same
across all drives. Quirk them out so they are not marked as "non globally
unique" duplicates.

Co-developed-by: Felipe de Jesus Araujo da Conceição <felipe.conceicao@petrosoftdesign.com>
Signed-off-by: Felipe de Jesus Araujo da Conceição <felipe.conceicao@petrosoftdesign.com>
Signed-off-by: Lamarque V. Souza <lamarque.souza@petrosoftdesign.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3436,6 +3436,8 @@ static const struct pci_device_id nvme_i
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1cc1, 0x33f8),   /* ADATA IM2P33F8ABR1 1 TB */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x10ec, 0x5762),   /* ADATA SX6000LNP */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
 				NVME_QUIRK_BOGUS_NID, },


