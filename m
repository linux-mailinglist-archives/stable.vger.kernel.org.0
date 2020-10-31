Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEEE2A1687
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgJaLq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgJaLq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250452074F;
        Sat, 31 Oct 2020 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144786;
        bh=e2Rk9PNlPqMnrxoDg8bwy03tmY6Hby9b57Vg85fF3OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQMRaTipPmqcZWqQ3/w/QLTWpm+KMXbTIiCis0+pAdSS6ua53eOGkgHCNVHIUzKoo
         J0xCAKkCVQ8xBlzRVFWkDnHgVh3GY3E0Q4IsYTEDhf6ksQubJgkXkuqQ2UJSkTpcy6
         0xOVJuQL++3nfIpjSnhNhTNpBLoxU+acLi0HW2LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 62/74] cxl: Rework error message for incompatible slots
Date:   Sat, 31 Oct 2020 12:36:44 +0100
Message-Id: <20201031113502.999003344@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

commit 40ac790d99c6dd16b367d5c2339e446a5f1b0593 upstream.

Improve the error message shown if a capi adapter is plugged on a
capi-incompatible slot directly under the PHB (no intermediate switch).

Fixes: 5632874311db ("cxl: Add support for POWER9 DD2")
Cc: stable@vger.kernel.org # 4.14+
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200407115601.25453-1-fbarrat@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/cxl/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -393,8 +393,8 @@ int cxl_calc_capp_routing(struct pci_dev
 	*capp_unit_id = get_capp_unit_id(np, *phb_index);
 	of_node_put(np);
 	if (!*capp_unit_id) {
-		pr_err("cxl: invalid capp unit id (phb_index: %d)\n",
-		       *phb_index);
+		pr_err("cxl: No capp unit found for PHB[%lld,%d]. Make sure the adapter is on a capi-compatible slot\n",
+		       *chipid, *phb_index);
 		return -ENODEV;
 	}
 


