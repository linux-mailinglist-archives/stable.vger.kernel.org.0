Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA8A535D06
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350240AbiE0JB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350442AbiE0I76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491FB765C;
        Fri, 27 May 2022 01:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3DB461D91;
        Fri, 27 May 2022 08:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAA4C385B8;
        Fri, 27 May 2022 08:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641753;
        bh=Yy5gQPcfw9NC/kuApdrxoyH05hh4EnBXxxCCeB24uyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMA6kDG7Qjqjs8HGxmqmnpjctGDQaABSw/10hAdxT3cgRznt4bGuRicxE/jqFdcDA
         fAQ6yMJxB973r0mazlxYMEUszbsnm2xThFoK6jON5He085aMhRHjcX69If9Y20KOGl
         P/U8CIcRrzORgYh3HaG/vt+ih585qLsOyC3lq/ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.18 46/47] ACPI: sysfs: Fix BERT error region memory mapping
Date:   Fri, 27 May 2022 10:50:26 +0200
Message-Id: <20220527084808.833542561@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 1bbc21785b7336619fb6a67f1fff5afdaf229acc upstream.

Currently the sysfs interface maps the BERT error region as "memory"
(through acpi_os_map_memory()) in order to copy the error records into
memory buffers through memory operations (eg memory_read_from_buffer()).

The OS system cannot detect whether the BERT error region is part of
system RAM or it is "device memory" (eg BMC memory) and therefore it
cannot detect which memory attributes the bus to memory support (and
corresponding kernel mapping, unless firmware provides the required
information).

The acpi_os_map_memory() arch backend implementation determines the
mapping attributes. On arm64, if the BERT error region is not present in
the EFI memory map, the error region is mapped as device-nGnRnE; this
triggers alignment faults since memcpy unaligned accesses are not
allowed in device-nGnRnE regions.

The ACPI sysfs code cannot therefore map by default the BERT error
region with memory semantics but should use a safer default.

Change the sysfs code to map the BERT error region as MMIO (through
acpi_os_map_iomem()) and use the memcpy_fromio() interface to read the
error region into the kernel buffer.

Link: https://lore.kernel.org/linux-arm-kernel/31ffe8fc-f5ee-2858-26c5-0fd8bdd68702@arm.com
Link: https://lore.kernel.org/linux-acpi/CAJZ5v0g+OVbhuUUDrLUCfX_mVqY_e8ubgLTU98=jfjTeb4t+Pw@mail.gmail.com
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Veronika Kabatova <vkabatov@redhat.com>
Tested-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sysfs.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -415,19 +415,30 @@ static ssize_t acpi_data_show(struct fil
 			      loff_t offset, size_t count)
 {
 	struct acpi_data_attr *data_attr;
-	void *base;
-	ssize_t rc;
+	void __iomem *base;
+	ssize_t size;
 
 	data_attr = container_of(bin_attr, struct acpi_data_attr, attr);
+	size = data_attr->attr.size;
 
-	base = acpi_os_map_memory(data_attr->addr, data_attr->attr.size);
+	if (offset < 0)
+		return -EINVAL;
+
+	if (offset >= size)
+		return 0;
+
+	if (count > size - offset)
+		count = size - offset;
+
+	base = acpi_os_map_iomem(data_attr->addr, size);
 	if (!base)
 		return -ENOMEM;
-	rc = memory_read_from_buffer(buf, count, &offset, base,
-				     data_attr->attr.size);
-	acpi_os_unmap_memory(base, data_attr->attr.size);
 
-	return rc;
+	memcpy_fromio(buf, base + offset, count);
+
+	acpi_os_unmap_iomem(base, size);
+
+	return count;
 }
 
 static int acpi_bert_data_init(void *th, struct acpi_data_attr *data_attr)


