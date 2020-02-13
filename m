Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1858415C308
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgBMPjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:39:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387449AbgBMP3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:06 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06474222C2;
        Thu, 13 Feb 2020 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607746;
        bh=bQjW8lwrVyACw128x2TiWIGTmALlgD5E5Cy8VNj2jx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYWWDGVdN1oYnCbWXAOBeLYQm63PtV7X4t81kWPLDNxcPOmOfQITSKNit86r2Q3+k
         vp0l18i3JVBy8PvOSACjk/0+r6rvCyis2KJZRelwuEQdjzZ1x1pCgbg/4UNvRwp1XH
         xLOLDo8KR1amhgUtxR8+xaTmO2qZ9QtWBJpjK1EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beniamin Bia <beniamin.bia@analog.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.5 103/120] dt-bindings: iio: adc: ad7606: Fix wrong maxItems value
Date:   Thu, 13 Feb 2020 07:21:39 -0800
Message-Id: <20200213151935.457006420@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beniamin Bia <beniamin.bia@analog.com>

commit a6c4f77cb3b11f81077b53c4a38f21b92d41f21e upstream.

This patch set the correct value for oversampling maxItems. In the
original example, appears 3 items for oversampling while the maxItems
is set to 1, this patch fixes those issues.

Fixes: 416f882c3b40 ("dt-bindings: iio: adc: Migrate AD7606 documentation to yaml")
Signed-off-by: Beniamin Bia <beniamin.bia@analog.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
@@ -82,7 +82,7 @@ properties:
       Must be the device tree identifier of the over-sampling
       mode pins. As the line is active high, it should be marked
       GPIO_ACTIVE_HIGH.
-    maxItems: 1
+    maxItems: 3
 
   adi,sw-mode:
     description:
@@ -125,9 +125,9 @@ examples:
                 adi,conversion-start-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
                 reset-gpios = <&gpio 27 GPIO_ACTIVE_HIGH>;
                 adi,first-data-gpios = <&gpio 22 GPIO_ACTIVE_HIGH>;
-                adi,oversampling-ratio-gpios = <&gpio 18 GPIO_ACTIVE_HIGH
-                                                &gpio 23 GPIO_ACTIVE_HIGH
-                                                &gpio 26 GPIO_ACTIVE_HIGH>;
+                adi,oversampling-ratio-gpios = <&gpio 18 GPIO_ACTIVE_HIGH>,
+                                               <&gpio 23 GPIO_ACTIVE_HIGH>,
+                                               <&gpio 26 GPIO_ACTIVE_HIGH>;
                 standby-gpios = <&gpio 24 GPIO_ACTIVE_LOW>;
                 adi,sw-mode;
         };


