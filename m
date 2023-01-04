Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3D65D849
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbjADQN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239707AbjADQMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F9965C4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E0ADB81722
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7172AC433F1;
        Wed,  4 Jan 2023 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848747;
        bh=SxN2TOApz+oxv5v0CIdNI5JZj/rkfQMWJ8oWXdXYEOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WClGA9Zvo527yK70HJxiYDe8gFNjejlNFFw8GkhfuujwHOkJHDX2ieeLRXJZWTpVo
         oxCZE54oJ4ZQf/zR5o11m/c6MxgqgRocyUFiwi4AlClc8ochcwa5a7KxTmneiO33iv
         CYYstEN84FkdjSsuXP+K/776UaN2Ji5bjohXVNLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Ming <ming4.li@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.1 076/207] PCI/DOE: Fix maximum data object length miscalculation
Date:   Wed,  4 Jan 2023 17:05:34 +0100
Message-Id: <20230104160514.347191210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Ming <ming4.li@intel.com>

commit a4ff8e7a71601321f7bf7b58ede664dc0d774274 upstream.

Per PCIe r6.0, sec 6.30.1, a data object Length of 0x0 indicates 2^18
DWORDs (256K DW or 1MB) being transferred.  Adjust the value of data object
length for this case on both sending side and receiving side.

Don't bother checking whether Length is greater than SZ_1M because all
values of the 18-bit Length field are valid, and it is impossible to
represent anything larger than SZ_1M:

  0x00000    256K DW (1M bytes)
  0x00001       1 DW (4 bytes)
  ...
  0x3ffff  256K-1 DW (1M - 4 bytes)

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20221116015637.3299664-1-ming4.li@intel.com
Fixes: 9d24322e887b ("PCI/DOE: Add DOE mailbox support functions")
Signed-off-by: Li Ming <ming4.li@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org	# v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/doe.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -29,6 +29,9 @@
 #define PCI_DOE_FLAG_CANCEL	0
 #define PCI_DOE_FLAG_DEAD	1
 
+/* Max data object length is 2^18 dwords */
+#define PCI_DOE_MAX_LENGTH	(1 << 18)
+
 /**
  * struct pci_doe_mb - State for a single DOE mailbox
  *
@@ -107,6 +110,7 @@ static int pci_doe_send_req(struct pci_d
 {
 	struct pci_dev *pdev = doe_mb->pdev;
 	int offset = doe_mb->cap_offset;
+	size_t length;
 	u32 val;
 	int i;
 
@@ -123,15 +127,20 @@ static int pci_doe_send_req(struct pci_d
 	if (FIELD_GET(PCI_DOE_STATUS_ERROR, val))
 		return -EIO;
 
+	/* Length is 2 DW of header + length of payload in DW */
+	length = 2 + task->request_pl_sz / sizeof(u32);
+	if (length > PCI_DOE_MAX_LENGTH)
+		return -EIO;
+	if (length == PCI_DOE_MAX_LENGTH)
+		length = 0;
+
 	/* Write DOE Header */
 	val = FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_1_VID, task->prot.vid) |
 		FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_1_TYPE, task->prot.type);
 	pci_write_config_dword(pdev, offset + PCI_DOE_WRITE, val);
-	/* Length is 2 DW of header + length of payload in DW */
 	pci_write_config_dword(pdev, offset + PCI_DOE_WRITE,
 			       FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH,
-					  2 + task->request_pl_sz /
-						sizeof(u32)));
+					  length));
 	for (i = 0; i < task->request_pl_sz / sizeof(u32); i++)
 		pci_write_config_dword(pdev, offset + PCI_DOE_WRITE,
 				       task->request_pl[i]);
@@ -178,7 +187,10 @@ static int pci_doe_recv_resp(struct pci_
 	pci_write_config_dword(pdev, offset + PCI_DOE_READ, 0);
 
 	length = FIELD_GET(PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH, val);
-	if (length > SZ_1M || length < 2)
+	/* A value of 0x0 indicates max data object length */
+	if (!length)
+		length = PCI_DOE_MAX_LENGTH;
+	if (length < 2)
 		return -EIO;
 
 	/* First 2 dwords have already been read */


