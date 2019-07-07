Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261166171D
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfGGTp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57074 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727515AbfGGTiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:05 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006g2-8Q; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0005Ze-Tp; Sun, 07 Jul 2019 20:38:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.326878483@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 042/129] devres: always use dev_name() in
 devm_ioremap_resource()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 8d84b18f5678d3adfdb9375dfb0d968da2dc753d upstream.

devm_ioremap_resource() prefers calling devm_request_mem_region() with a
resource name instead of a device name -- this looks pretty iff a resource
name isn't specified via a device tree with a "reg-names" property (in this
case, a resource name is set to a device node's full name), but if it is,
it doesn't really scale since these names are only unique to a given device
node, not globally; so, looking at the output of 'cat /proc/iomem', you do
not have an idea which memory region belongs to which device (see "dirmap",
"regs", and "wbuf" lines below):

08000000-0bffffff : dirmap
48000000-bfffffff : System RAM
  48000000-48007fff : reserved
  48080000-48b0ffff : Kernel code
  48b10000-48b8ffff : reserved
  48b90000-48c7afff : Kernel data
  bc6a4000-bcbfffff : reserved
  bcc0f000-bebfffff : reserved
  bec0e000-bec0efff : reserved
  bec11000-bec11fff : reserved
  bec12000-bec14fff : reserved
  bec15000-bfffffff : reserved
e6050000-e605004f : gpio@e6050000
e6051000-e605104f : gpio@e6051000
e6052000-e605204f : gpio@e6052000
e6053000-e605304f : gpio@e6053000
e6054000-e605404f : gpio@e6054000
e6055000-e605504f : gpio@e6055000
e6060000-e606050b : pin-controller@e6060000
e6e60000-e6e6003f : e6e60000.serial
e7400000-e7400fff : ethernet@e7400000
ee200000-ee2001ff : regs
ee208000-ee2080ff : wbuf

I think that devm_request_mem_region() should be called with dev_name()
despite the region names won't look as pretty as before (however, we gain
more consistency with e.g. the serial driver:

08000000-0bffffff : ee200000.rpc
48000000-bfffffff : System RAM
  48000000-48007fff : reserved
  48080000-48b0ffff : Kernel code
  48b10000-48b8ffff : reserved
  48b90000-48c7afff : Kernel data
  bc6a4000-bcbfffff : reserved
  bcc0f000-bebfffff : reserved
  bec0e000-bec0efff : reserved
  bec11000-bec11fff : reserved
  bec12000-bec14fff : reserved
  bec15000-bfffffff : reserved
e6050000-e605004f : e6050000.gpio
e6051000-e605104f : e6051000.gpio
e6052000-e605204f : e6052000.gpio
e6053000-e605304f : e6053000.gpio
e6054000-e605404f : e6054000.gpio
e6055000-e605504f : e6055000.gpio
e6060000-e606050b : e6060000.pin-controller
e6e60000-e6e6003f : e6e60000.serial
e7400000-e7400fff : e7400000.ethernet
ee200000-ee2001ff : ee200000.rpc
ee208000-ee2080ff : ee200000.rpc

Fixes: 72f8c0bfa0de ("lib: devres: add convenience function to remap a resource")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/devres.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/devres.c
+++ b/lib/devres.c
@@ -109,7 +109,6 @@ EXPORT_SYMBOL(devm_iounmap);
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 {
 	resource_size_t size;
-	const char *name;
 	void __iomem *dest_ptr;
 
 	BUG_ON(!dev);
@@ -120,9 +119,8 @@ void __iomem *devm_ioremap_resource(stru
 	}
 
 	size = resource_size(res);
-	name = res->name ?: dev_name(dev);
 
-	if (!devm_request_mem_region(dev, res->start, size, name)) {
+	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}

