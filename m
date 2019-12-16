Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88AB1217CF
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbfLPSiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfLPSET (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF83A20700;
        Mon, 16 Dec 2019 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519458;
        bh=Au99viy+X18pYsQ1rPzRNBgVSzZlFq3Aj87KG1CsGg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMnuJ29ir/K3B845w8I/866ISRTQtlNvu27PHwik6XVSmqfv3Fl46DQDBVqfFkm6V
         bK4E9An+2CMvo7barRbrB+5Gsdx+OiM3Lc+I+YfVMU4nw6KcQimUEKyUWyQsGV9ON6
         ozCEy29r4SfQ82RiHqDGXv0GiTrmzOIMmvgjTN1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 074/140] ACPI: OSL: only free map once in osl.c
Date:   Mon, 16 Dec 2019 18:49:02 +0100
Message-Id: <20191216174807.473825782@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

commit 833a426cc471b6088011b3d67f1dc4e147614647 upstream.

acpi_os_map_cleanup checks map->refcount outside of acpi_ioremap_lock
before freeing the map. This creates a race condition the can result
in the map being freed more than once.
A panic can be caused by running

for ((i=0; i<10; i++))
do
        for ((j=0; j<100000; j++))
        do
                cat /sys/firmware/acpi/tables/data/BERT >/dev/null
        done &
done

This patch makes sure that only the process that drops the reference
to 0 does the freeing.

Fixes: b7c1fadd6c2e ("ACPI: Do not use krefs under a mutex in osl.c")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/osl.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -374,19 +374,21 @@ void *__ref acpi_os_map_memory(acpi_phys
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
-static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
+/* Must be called with mutex_lock(&acpi_ioremap_lock) */
+static unsigned long acpi_os_drop_map_ref(struct acpi_ioremap *map)
 {
-	if (!--map->refcount)
+	unsigned long refcount = --map->refcount;
+
+	if (!refcount)
 		list_del_rcu(&map->list);
+	return refcount;
 }
 
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	if (!map->refcount) {
-		synchronize_rcu_expedited();
-		acpi_unmap(map->phys, map->virt);
-		kfree(map);
-	}
+	synchronize_rcu_expedited();
+	acpi_unmap(map->phys, map->virt);
+	kfree(map);
 }
 
 /**
@@ -406,6 +408,7 @@ static void acpi_os_map_cleanup(struct a
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
+	unsigned long refcount;
 
 	if (!acpi_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
@@ -419,10 +422,11 @@ void __ref acpi_os_unmap_iomem(void __io
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount = acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
 
@@ -457,6 +461,7 @@ void acpi_os_unmap_generic_address(struc
 {
 	u64 addr;
 	struct acpi_ioremap *map;
+	unsigned long refcount;
 
 	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -472,10 +477,11 @@ void acpi_os_unmap_generic_address(struc
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount = acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL(acpi_os_unmap_generic_address);
 


