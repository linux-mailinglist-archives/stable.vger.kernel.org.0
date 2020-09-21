Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26903272DD3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgIUQnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgIUQni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A08F23998;
        Mon, 21 Sep 2020 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706617;
        bh=gMBtvEME0kpMwgrfz6h+ibQod2yLncPhPCjk5Ye35xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZ69crFNUYwZ1VYrcYMMuw2LwztwOb2wXCi5Iq6nWlrBffwE/aaDIWC8BnG24Aa3h
         TPYoH6+ALVZtkk8+kXXD//qpqBy0Q2qHyv396zQ5WB5dd+X+tPnwgxSLjroSdDaDPL
         V5VoeztmnuisxpEkj1ctnwFQ2Adj+kkMAPhH1/RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org,
        Dilip Kota <eswara.kota@linux.intel.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.8 005/118] dt-bindings: PCI: intel,lgm-pcie: Fix matching on all snps,dw-pcie instances
Date:   Mon, 21 Sep 2020 18:26:57 +0200
Message-Id: <20200921162036.594717224@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit a326462cba6ae7398a5c997dddf3bea39555a825 upstream.

The intel,lgm-pcie binding is matching on all snps,dw-pcie instances
which is wrong. Add a custom 'select' entry to fix this.

Fixes: e54ea45a4955 ("dt-bindings: PCI: intel: Add YAML schemas for the PCIe RC controller")
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Reviewed-by: Dilip Kota <eswara.kota@linux.intel.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml
@@ -9,6 +9,14 @@ title: PCIe RC controller on Intel Gatew
 maintainers:
   - Dilip Kota <eswara.kota@linux.intel.com>
 
+select:
+  properties:
+    compatible:
+      contains:
+        const: intel,lgm-pcie
+  required:
+    - compatible
+
 properties:
   compatible:
     items:


