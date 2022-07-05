Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BFD566D32
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiGEMVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbiGEMTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6FE1D30A;
        Tue,  5 Jul 2022 05:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB341619F6;
        Tue,  5 Jul 2022 12:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A11C341C8;
        Tue,  5 Jul 2022 12:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023297;
        bh=kc+6aJbmgo+xF3hKG4l3Fhv8uf3p425bh0XgsmdxSuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIINMHSnLus7SKckGcyZ7wl1lKrdEGUjD/7JVnMuRNSgmnhrJXhQ3VUZLdVDql1PM
         /5oPO+ZsX33+jftp/iH05OtNvtsYV/ZOfId9TBZME/lHu1OMTQppL2Sse04mLTyGSY
         wh0+m6UySBUv9rcmD1vCw6mpAC17wOF5i1ICc5Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Greco <pgreco@centosproject.org>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.18 010/102] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA SPECTRIX S40G)
Date:   Tue,  5 Jul 2022 13:57:36 +0200
Message-Id: <20220705115618.708454802@linuxfoundation.org>
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

From: Pablo Greco <pgreco@centosproject.org>

commit 1629de0e0373e04d68e88e6d9d3071fbf70b7ea8 upstream.

ADATA XPG SPECTRIX S40G drives report bogus eui64 values that appear to
be the same across drives in one system. Quirk them out so they are
not marked as "non globally unique" duplicates.

Before:
[    2.258919] nvme nvme1: pci function 0000:06:00.0
[    2.264898] nvme nvme2: pci function 0000:05:00.0
[    2.323235] nvme nvme1: failed to set APST feature (2)
[    2.326153] nvme nvme2: failed to set APST feature (2)
[    2.333935] nvme nvme1: allocated 64 MiB host memory buffer.
[    2.336492] nvme nvme2: allocated 64 MiB host memory buffer.
[    2.339611] nvme nvme1: 7/0/0 default/read/poll queues
[    2.341805] nvme nvme2: 7/0/0 default/read/poll queues
[    2.346114]  nvme1n1: p1
[    2.347197] nvme nvme2: globally duplicate IDs for nsid 1
After:
[    2.427715] nvme nvme1: pci function 0000:06:00.0
[    2.427771] nvme nvme2: pci function 0000:05:00.0
[    2.488154] nvme nvme2: failed to set APST feature (2)
[    2.489895] nvme nvme1: failed to set APST feature (2)
[    2.498773] nvme nvme2: allocated 64 MiB host memory buffer.
[    2.500587] nvme nvme1: allocated 64 MiB host memory buffer.
[    2.504113] nvme nvme2: 7/0/0 default/read/poll queues
[    2.507026] nvme nvme1: 7/0/0 default/read/poll queues
[    2.509467] nvme nvme2: Ignoring bogus Namespace Identifiers
[    2.512804] nvme nvme1: Ignoring bogus Namespace Identifiers
[    2.513698]  nvme1n1: p1

Signed-off-by: Pablo Greco <pgreco@centosproject.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3437,7 +3437,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x10ec, 0x5762),   /* ADATA SX6000LNP */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },


