Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13AB6AED01
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCGSAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCGR7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78C2A676B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66CFFB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B181AC433EF;
        Tue,  7 Mar 2023 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211638;
        bh=If8t++W7o9jwDAXYCDe6bZ2uaq27PXPrAEmWO8iRs4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q077NvnTFXqqRbMuG3k89Yd3kzI5phf5j3Cj2WcN73T1SpOoa4de10RIJdQDBk//+
         NIqjHR9ShJiXw98rfRmEE2poE39BGNq3wdcc5842AJ4v1zcX+msU9wE6jbqLkeD4HZ
         Pz4Jrd/SijflaO6vBqPBkM/yxUOI0yRMAZh0pny0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.2 0895/1001] cxl/pmem: Fix nvdimm registration races
Date:   Tue,  7 Mar 2023 18:01:07 +0100
Message-Id: <20230307170100.817078484@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit f57aec443c24d2e8e1f3b5b4856aea12ddda4254 upstream.

A loop of the form:

    while true; do modprobe cxl_pci; modprobe -r cxl_pci; done

...fails with the following crash signature:

    BUG: kernel NULL pointer dereference, address: 0000000000000040
    [..]
    RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
     nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
     nd_label_data_init+0x135/0x7e0 [libnvdimm]
     nvdimm_probe+0xd6/0x1c0 [libnvdimm]
     nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
     really_probe+0xde/0x380
     __driver_probe_device+0x78/0x170
     driver_probe_device+0x1f/0x90
     __device_attach_driver+0x85/0x110
     bus_for_each_drv+0x7d/0xc0
     __device_attach+0xb4/0x1e0
     bus_probe_device+0x9f/0xc0
     device_add+0x445/0x9c0
     nd_async_device_register+0xe/0x40 [libnvdimm]
     async_run_entry_fn+0x30/0x130

...namely that the bottom half of async nvdimm device registration runs
after the CXL has already torn down the context that cxl_pmem_ctl()
needs. Unlike the ACPI NFIT case that benefits from launching multiple
nvdimm device registrations in parallel from those listed in the table,
CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So provide for a
synchronous registration path to preclude this scenario.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pmem.c         |    1 +
 drivers/nvdimm/bus.c       |   19 ++++++++++++++++---
 drivers/nvdimm/dimm_devs.c |    5 ++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    3 +++
 5 files changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -76,6 +76,7 @@ static int cxl_nvdimm_probe(struct devic
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -508,7 +508,7 @@ static void nd_async_device_unregister(v
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+static void __nd_device_register(struct device *dev, bool sync)
 {
 	if (!dev)
 		return;
@@ -531,11 +531,24 @@ void nd_device_register(struct device *d
 	}
 	get_device(dev);
 
-	async_schedule_dev_domain(nd_async_device_register, dev,
-				  &nd_async_domain);
+	if (sync)
+		nd_async_device_register(dev, 0);
+	else
+		async_schedule_dev_domain(nd_async_device_register, dev,
+					  &nd_async_domain);
+}
+
+void nd_device_register(struct device *dev)
+{
+	__nd_device_register(dev, false);
 }
 EXPORT_SYMBOL(nd_device_register);
 
+void nd_device_register_sync(struct device *dev)
+{
+	__nd_device_register(dev, true);
+}
+
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
 	bool killed;
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -624,7 +624,10 @@ struct nvdimm *__nvdimm_create(struct nv
 	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &nvdimm_key);
-	nd_device_register(dev);
+	if (test_bit(NDD_REGISTER_SYNC, &flags))
+		nd_device_register_sync(dev);
+	else
+		nd_device_register(dev);
 
 	return nvdimm;
 }
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdim
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 void nd_device_register(struct device *dev);
+void nd_device_register_sync(struct device *dev);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
 		      u32 flags);
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -41,6 +41,9 @@ enum {
 	 */
 	NDD_INCOHERENT = 7,
 
+	/* dimm provider wants synchronous registration by __nvdimm_create() */
+	NDD_REGISTER_SYNC = 8,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,


