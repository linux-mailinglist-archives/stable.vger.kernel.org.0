Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C949959467B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346173AbiHOW5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352677AbiHOW4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B1B12F733;
        Mon, 15 Aug 2022 12:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 328A2CE12C3;
        Mon, 15 Aug 2022 19:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB601C433C1;
        Mon, 15 Aug 2022 19:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593347;
        bh=So4KEy2R+io5ZynIl2AOA2Bc69IgEvmlEzIA5aE010w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot5VwNHTCOnB67Ak9aOSNo7GbrizxFyQLsqV998pBd9E7tCCVxw8BzEcUgx7qHNCZ
         Juylxn4fknX2qVB+KJHWSg9ikS89JdFWeAmvn1t+HsfmeIWLrvJLCqgHJ7HPc+jGNa
         CP38CgrJBPu3QY8QALJclccNm1nI4n9iqu1yseZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Jin Liu <jinl@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0254/1157] ACPI: VIOT: Fix ACS setup
Date:   Mon, 15 Aug 2022 19:53:30 +0200
Message-Id: <20220815180449.759726806@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 3dcb861dbc6ab101838a1548b1efddd00ca3c3ec ]

Currently acpi_viot_init() gets called after the pci
device has been scanned and pci_enable_acs() has been called.
So pci_request_acs() fails to be taken into account leading
to wrong single iommu group topologies when dealing with
multi-function root ports for instance.

We cannot simply move the acpi_viot_init() earlier, similarly
as the IORT init because the VIOT parsing relies on the pci
scan. However we can detect VIOT is present earlier and in
such a case, request ACS. Introduce a new acpi_viot_early_init()
routine that allows to call pci_request_acs() before the scan.

While at it, guard the call to pci_request_acs() with #ifdef
CONFIG_PCI.

Fixes: 3cf485540e7b ("ACPI: Add driver for the VIOT table")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Jin Liu <jinl@redhat.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Tested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c        |  1 +
 drivers/acpi/viot.c       | 26 ++++++++++++++++++++------
 include/linux/acpi_viot.h |  2 ++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e2db1bdd9dd2..1d36bb684f5c 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1399,6 +1399,7 @@ static int __init acpi_init(void)
 
 	pci_mmcfg_late_init();
 	acpi_iort_init();
+	acpi_viot_early_init();
 	acpi_hest_init();
 	acpi_ghes_init();
 	acpi_scan_init();
diff --git a/drivers/acpi/viot.c b/drivers/acpi/viot.c
index d2256326c73a..647f11cf165d 100644
--- a/drivers/acpi/viot.c
+++ b/drivers/acpi/viot.c
@@ -248,6 +248,26 @@ static int __init viot_parse_node(const struct acpi_viot_header *hdr)
 	return ret;
 }
 
+/**
+ * acpi_viot_early_init - Test the presence of VIOT and enable ACS
+ *
+ * If the VIOT does exist, ACS must be enabled. This cannot be
+ * done in acpi_viot_init() which is called after the bus scan
+ */
+void __init acpi_viot_early_init(void)
+{
+#ifdef CONFIG_PCI
+	acpi_status status;
+	struct acpi_table_header *hdr;
+
+	status = acpi_get_table(ACPI_SIG_VIOT, 0, &hdr);
+	if (ACPI_FAILURE(status))
+		return;
+	pci_request_acs();
+	acpi_put_table(hdr);
+#endif
+}
+
 /**
  * acpi_viot_init - Parse the VIOT table
  *
@@ -319,12 +339,6 @@ static int viot_pci_dev_iommu_init(struct pci_dev *pdev, u16 dev_id, void *data)
 			epid = ((domain_nr - ep->segment_start) << 16) +
 				dev_id - ep->bdf_start + ep->endpoint_id;
 
-			/*
-			 * If we found a PCI range managed by the viommu, we're
-			 * the one that has to request ACS.
-			 */
-			pci_request_acs();
-
 			return viot_dev_iommu_init(&pdev->dev, ep->viommu,
 						   epid);
 		}
diff --git a/include/linux/acpi_viot.h b/include/linux/acpi_viot.h
index 1eb8ee5b0e5f..a5a122431563 100644
--- a/include/linux/acpi_viot.h
+++ b/include/linux/acpi_viot.h
@@ -6,9 +6,11 @@
 #include <linux/acpi.h>
 
 #ifdef CONFIG_ACPI_VIOT
+void __init acpi_viot_early_init(void);
 void __init acpi_viot_init(void);
 int viot_iommu_configure(struct device *dev);
 #else
+static inline void acpi_viot_early_init(void) {}
 static inline void acpi_viot_init(void) {}
 static inline int viot_iommu_configure(struct device *dev)
 {
-- 
2.35.1



