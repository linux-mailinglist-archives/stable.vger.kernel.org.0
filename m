Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0499DFE1
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbfH0H62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbfH0H61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3540F206BF;
        Tue, 27 Aug 2019 07:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892706;
        bh=G9OEy4CmaSXtfVtdYKmh1SHnSG9Tl5z7jV7Dznx61UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5IJAJy8s+J5S9zy0kqSj72UQ73cwGw0GUPduGcVWqGHY1poWQHnda8YVRpEbkPS9
         0XI5dCiOraZYeLJlvq5RHxnQ9ShqMFyf2g+BPMz3BV1SEqDW3Oq8Y4sxRaTS0ceV7B
         JWv/QcI2SnK+BrsdOBimujKXqoM7W+0wa86JZ+ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 84/98] genirq: Properly pair kobject_del() with kobject_add()
Date:   Tue, 27 Aug 2019 09:51:03 +0200
Message-Id: <20190827072722.416373794@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

commit d0ff14fdc987303aeeb7de6f1bd72c3749ae2a9b upstream.

If alloc_descs() fails before irq_sysfs_init() has run, free_desc() in the
cleanup path will call kobject_del() even though the kobject has not been
added with kobject_add().

Fix this by making the call to kobject_del() conditional on whether
irq_sysfs_init() has run.

This problem surfaced because commit aa30f47cf666 ("kobject: Add support
for default attribute groups to kobj_type") makes kobject_del() stricter
about pairing with kobject_add(). If the pairing is incorrrect, a WARNING
and backtrace occur in sysfs_remove_group() because there is no parent.

[ tglx: Add a comment to the code and make it work with CONFIG_SYSFS=n ]

Fixes: ecb3f394c5db ("genirq: Expose interrupt information through sysfs")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1564703564-4116-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/irqdesc.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -294,6 +294,18 @@ static void irq_sysfs_add(int irq, struc
 	}
 }
 
+static void irq_sysfs_del(struct irq_desc *desc)
+{
+	/*
+	 * If irq_sysfs_init() has not yet been invoked (early boot), then
+	 * irq_kobj_base is NULL and the descriptor was never added.
+	 * kobject_del() complains about a object with no parent, so make
+	 * it conditional.
+	 */
+	if (irq_kobj_base)
+		kobject_del(&desc->kobj);
+}
+
 static int __init irq_sysfs_init(void)
 {
 	struct irq_desc *desc;
@@ -324,6 +336,7 @@ static struct kobj_type irq_kobj_type =
 };
 
 static void irq_sysfs_add(int irq, struct irq_desc *desc) {}
+static void irq_sysfs_del(struct irq_desc *desc) {}
 
 #endif /* CONFIG_SYSFS */
 
@@ -437,7 +450,7 @@ static void free_desc(unsigned int irq)
 	 * The sysfs entry must be serialized against a concurrent
 	 * irq_sysfs_init() as well.
 	 */
-	kobject_del(&desc->kobj);
+	irq_sysfs_del(desc);
 	delete_irq_desc(irq);
 
 	/*


