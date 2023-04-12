Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E156DEF81
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjDLIvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjDLIvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D793E0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E90663170
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBD7C433D2;
        Wed, 12 Apr 2023 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289407;
        bh=Y5avBEy5XRgbgxi7czMPQBpvH123Ly2+/Aa8by29/LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXHU0+lmlE+f5Rwo+kuF1Z1sIaygRuCe+ZS8jE0FEY9k1Tx5/IaEhQ6/Ww4e4HtqQ
         dOKn53eJ91BvfcO9erkw38vbfHB7ndu+KVKs4eJ0nfQrXiV0LyIai0okCaHVIE9ox5
         XdaDEjWA945LUhIMYJL8lPEX79XeSAw+zSrr9K2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 057/173] cxl/pci: Handle truncated CDAT entries
Date:   Wed, 12 Apr 2023 10:33:03 +0200
Message-Id: <20230412082840.426776136@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit b56faef2312057db20479b240eb71bd2e51fb51c upstream.

If truncated CDAT entries are received from a device, the concatenation
of those entries constitutes a corrupt CDAT, yet is happily exposed to
user space.

Avoid by verifying response lengths and erroring out if truncation is
detected.

The last CDAT entry may still be truncated despite the checks introduced
herein if the length in the CDAT header is too small.  However, that is
easily detectable by user space because it reaches EOF prematurely.
A subsequent commit which rightsizes the CDAT response allocation closes
that remaining loophole.

The two lines introduced here which exceed 80 chars are shortened to
less than 80 chars by a subsequent commit which migrates to a
synchronous DOE API and replaces "t.task.rv" by "rc".

The existing acpi_cdat_header and acpi_table_cdat struct definitions
provided by ACPICA cannot be used because they do not employ __le16 or
__le32 types.  I believe that cannot be changed because those types are
Linux-specific and ACPI is specified for little endian platforms only,
hence doesn't care about endianness.  So duplicate the structs.

Fixes: c97006046c79 ("cxl/port: Read CDAT table")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Link: https://lore.kernel.org/r/bce3aebc0e8e18a1173425a7a865b232c3912963.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |   13 +++++++++----
 drivers/cxl/cxlpci.h   |   14 ++++++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -547,8 +547,8 @@ static int cxl_cdat_read_table(struct de
 
 	do {
 		DECLARE_CDAT_DOE_TASK(CDAT_DOE_REQ(entry_handle), t);
+		struct cdat_entry_header *entry;
 		size_t entry_dw;
-		__le32 *entry;
 		int rc;
 
 		rc = pci_doe_submit_task(cdat_doe, &t.task);
@@ -557,14 +557,19 @@ static int cxl_cdat_read_table(struct de
 			return rc;
 		}
 		wait_for_completion(&t.c);
-		/* 1 DW header + 1 DW data min */
-		if (t.task.rv < (2 * sizeof(__le32)))
+
+		/* 1 DW Table Access Response Header + CDAT entry */
+		entry = (struct cdat_entry_header *)(t.response_pl + 1);
+		if ((entry_handle == 0 &&
+		     t.task.rv != sizeof(__le32) + sizeof(struct cdat_header)) ||
+		    (entry_handle > 0 &&
+		     (t.task.rv < sizeof(__le32) + sizeof(*entry) ||
+		      t.task.rv != sizeof(__le32) + le16_to_cpu(entry->length))))
 			return -EIO;
 
 		/* Get the CXL table access header entry handle */
 		entry_handle = FIELD_GET(CXL_DOE_TABLE_ACCESS_ENTRY_HANDLE,
 					 le32_to_cpu(t.response_pl[0]));
-		entry = t.response_pl + 1;
 		entry_dw = t.task.rv / sizeof(__le32);
 		/* Skip Header */
 		entry_dw -= 1;
--- a/drivers/cxl/cxlpci.h
+++ b/drivers/cxl/cxlpci.h
@@ -62,6 +62,20 @@ enum cxl_regloc_type {
 	CXL_REGLOC_RBI_TYPES
 };
 
+struct cdat_header {
+	__le32 length;
+	u8 revision;
+	u8 checksum;
+	u8 reserved[6];
+	__le32 sequence;
+} __packed;
+
+struct cdat_entry_header {
+	u8 type;
+	u8 reserved;
+	__le16 length;
+} __packed;
+
 int devm_cxl_port_enumerate_dports(struct cxl_port *port);
 struct cxl_dev_state;
 int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm);


