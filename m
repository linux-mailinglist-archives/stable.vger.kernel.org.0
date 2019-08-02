Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFAE7F18F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390345AbfHBJdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391313AbfHBJdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8A52184B;
        Fri,  2 Aug 2019 09:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738395;
        bh=eFhYU83jO4L2FhXJ+Kbfgwu10CTkyXqe7SPvW+nkfXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpN4D+dXskHJ/DFLIKnrZfUVpXtOJCMd3/4m3UdzW8yKuywqN33gKlod4nfe/K+3f
         NFh40MaEdrdZXTDgtiwFnAkjvo49FUaCv7Bcbm+IQC7EJML3TEZ2kxgwhzhbk89FIo
         xb9FCF+rzTfI+Jh9v0SdjrsXZxT3kmmfHaifpq4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 070/158] PCI: Do not poll for PME if the device is in D3cold
Date:   Fri,  2 Aug 2019 11:28:11 +0200
Message-Id: <20190802092218.202615264@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 000dd5316e1c756a1c028f22e01d06a38249dd4d upstream.

PME polling does not take into account that a device that is directly
connected to the host bridge may go into D3cold as well. This leads to a
situation where the PME poll thread reads from a config space of a
device that is in D3cold and gets incorrect information because the
config space is not accessible.

Here is an example from Intel Ice Lake system where two PCIe root ports
are in D3cold (I've instrumented the kernel to log the PMCSR register
contents):

  [   62.971442] pcieport 0000:00:07.1: Check PME status, PMCSR=0xffff
  [   62.971504] pcieport 0000:00:07.0: Check PME status, PMCSR=0xffff

Since 0xffff is interpreted so that PME is pending, the root ports will
be runtime resumed. This repeats over and over again essentially
blocking all runtime power management.

Prevent this from happening by checking whether the device is in D3cold
before its PME status is read.

Fixes: 71a83bd727cc ("PCI/PM: add runtime PM support to PCIe port")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: 3.6+ <stable@vger.kernel.org> # v3.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1736,6 +1736,13 @@ static void pci_pme_list_scan(struct wor
 			 */
 			if (bridge && bridge->current_state != PCI_D0)
 				continue;
+			/*
+			 * If the device is in D3cold it should not be
+			 * polled either.
+			 */
+			if (pme_dev->dev->current_state == PCI_D3cold)
+				continue;
+
 			pci_pme_wakeup(pme_dev->dev, NULL);
 		} else {
 			list_del(&pme_dev->list);


