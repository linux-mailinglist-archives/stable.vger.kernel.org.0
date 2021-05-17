Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA3A38337E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbhEQO6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242474AbhEQO4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 552F66147F;
        Mon, 17 May 2021 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261527;
        bh=ztFUVYCkZNRiIqAVuEpmknBv/d7sXZEZdnw/hveynLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFKpgfcbz1DkFq7w/AqTxAGm93/4soGHpZh02RMG7UQhFVdkQJPcRC7FIx7xeEdpH
         /PHQdftQ953LfUvBY6GyVA0aXBlsnEbINOnTzCx2ncmzGuK8bc7TrdXmbc4MFSHBqO
         Ovdq6aqkeRpLF9+5pjLBHxmn4J1A4fLkh+6rO+Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.12 359/363] dt-bindings: PCI: rcar-pci-host: Document missing R-Car H1 support
Date:   Mon, 17 May 2021 16:03:45 +0200
Message-Id: <20210517140314.736667051@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 62b3b3660aff66433d71f142ab6ed2baaea25025 upstream.

scripts/checkpatch.pl -f drivers/pci/controller/pcie-rcar-host.c:

    WARNING: DT compatible string "renesas,pcie-r8a7779" appears un-documented -- check ./Documentation/devicetree/bindings/
    #853: FILE: drivers/pci/controller/pcie-rcar-host.c:853:
    +	{ .compatible = "renesas,pcie-r8a7779",

Re-add the compatible value for R-Car H1, which was lost during the
json-schema conversion.  Make the "resets" property optional on R-Car
H1, as it is not present yet on R-Car Gen1 SoCs.

Fixes: 0d69ce3c2c63d4db ("dt-bindings: PCI: rcar-pci-host: Convert bindings to json-schema")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/fb0bb969cd0e5872ab5eac70e070242c0d8a5b81.1619700202.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/rcar-pci-host.yaml |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
+++ b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
@@ -17,6 +17,7 @@ allOf:
 properties:
   compatible:
     oneOf:
+      - const: renesas,pcie-r8a7779       # R-Car H1
       - items:
           - enum:
               - renesas,pcie-r8a7742      # RZ/G1H
@@ -74,7 +75,16 @@ required:
   - clocks
   - clock-names
   - power-domains
-  - resets
+
+if:
+  not:
+    properties:
+      compatible:
+        contains:
+          const: renesas,pcie-r8a7779
+then:
+  required:
+    - resets
 
 unevaluatedProperties: false
 


