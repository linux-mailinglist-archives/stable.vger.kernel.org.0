Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4C51FCAC1
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 12:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgFQKXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 06:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgFQKXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 06:23:15 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C418214D8;
        Wed, 17 Jun 2020 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592389394;
        bh=q4XtEUaNAPjAlHRDzfBXndousVziD4EzqeUrETXxBjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MCVuvHI4/1WTFEjLx/PerIQCGJWPkXUx8NmAPAuT+j6OWVH2KxRnjyvdt2jK8+s0
         7ayqOmzHDqBByicUIi1G7WN6rwNZdX4ChqzQOGRlVZ9muaJ7ewvrGl8DKhbpe34EPM
         MzliQlc5UYP6C7dFO4dXAxjMjubYHD0FWHaRvuYg=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: power: supply: bq25890: Document required interrupt
Date:   Wed, 17 Jun 2020 12:23:05 +0200
Message-Id: <20200617102305.14241-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617102305.14241-1-krzk@kernel.org>
References: <20200617102305.14241-1-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver requires interrupts (fails probe if it is not provided) so
document this requirement in bindings.

Fixes: 4aeae9cb0dad ("power_supply: Add support for TI BQ25890 charger chip")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 Documentation/devicetree/bindings/power/supply/bq25890.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.txt b/Documentation/devicetree/bindings/power/supply/bq25890.txt
index 51ecc756521f..3b4c69a7fa70 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25890.txt
+++ b/Documentation/devicetree/bindings/power/supply/bq25890.txt
@@ -10,6 +10,7 @@ Required properties:
     * "ti,bq25895"
     * "ti,bq25896"
 - reg: integer, i2c address of the device.
+- interrupts: interrupt line;
 - ti,battery-regulation-voltage: integer, maximum charging voltage (in uV);
 - ti,charge-current: integer, maximum charging current (in uA);
 - ti,termination-current: integer, charge will be terminated when current in
@@ -39,6 +40,9 @@ bq25890 {
 	compatible = "ti,bq25890";
 	reg = <0x6a>;
 
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 IRQ_TYPE_EDGE_FALLING>;
+
 	ti,battery-regulation-voltage = <4200000>;
 	ti,charge-current = <1000000>;
 	ti,termination-current = <50000>;
-- 
2.17.1

