Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B51960887C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiJVIRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiJVIQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:16:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7672DCB0F;
        Sat, 22 Oct 2022 00:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C605E60B45;
        Sat, 22 Oct 2022 07:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B594FC433C1;
        Sat, 22 Oct 2022 07:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425444;
        bh=l0qQ2lCaxTmpz63zjBz0GZTyNJRYUHWb1NPdjSlk1wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I19Iitnf4GaMFXtW0zpbujUUx/0sWWctBNJN9gd8//TX18MANm80iXPvGTujdttc6
         BdAGrRRwcMJwxS7tAf2wkMN6HbEIxmYXVTFXNj85cLFrd4RW9lVpDyrTUHA4lNS+1n
         S93/cxT/D8FS2QeDhpJGAuPqMWCiBNTHYbENLJ1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 504/717] powerpc: Fix SPE Power ISA properties for e500v1 platforms
Date:   Sat, 22 Oct 2022 09:26:23 +0200
Message-Id: <20221022072520.548164809@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 37b9345ce7f4ab17538ea62def6f6d430f091355 ]

Commit 2eb28006431c ("powerpc/e500v2: Add Power ISA properties to comply
with ePAPR 1.1") introduced new include file e500v2_power_isa.dtsi and
should have used it for all e500v2 platforms. But apparently it was used
also for e500v1 platforms mpc8540, mpc8541, mpc8555 and mpc8560.

e500v1 cores compared to e500v2 do not support double precision floating
point SPE instructions. Hence power-isa-sp.fd should not be set on e500v1
platforms, which is in e500v2_power_isa.dtsi include file.

Fix this issue by introducing a new e500v1_power_isa.dtsi include file and
use it in all e500v1 device tree files.

Fixes: 2eb28006431c ("powerpc/e500v2: Add Power ISA properties to comply with ePAPR 1.1")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220902212103.22534-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/fsl/e500v1_power_isa.dtsi        | 51 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts      |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts      |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts      |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts      |  2 +-
 5 files changed, 55 insertions(+), 4 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi b/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi
new file mode 100644
index 000000000000..7e2a90cde72e
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi
@@ -0,0 +1,51 @@
+/*
+ * e500v1 Power ISA Device Tree Source (include)
+ *
+ * Copyright 2012 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor "AS IS" AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/ {
+	cpus {
+		power-isa-version = "2.03";
+		power-isa-b;		// Base
+		power-isa-e;		// Embedded
+		power-isa-atb;		// Alternate Time Base
+		power-isa-cs;		// Cache Specification
+		power-isa-e.le;		// Embedded.Little-Endian
+		power-isa-e.pm;		// Embedded.Performance Monitor
+		power-isa-ecl;		// Embedded Cache Locking
+		power-isa-mmc;		// Memory Coherence
+		power-isa-sp;		// Signal Processing Engine
+		power-isa-sp.fs;	// SPE.Embedded Float Scalar Single
+		power-isa-sp.fv;	// SPE.Embedded Float Vector
+		mmu-type = "power-embedded";
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/mpc8540ads.dts b/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
index 18a885130538..e03ae130162b 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8540ADS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
index ac381e7b1c60..a2a6c5cf852e 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8541CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
index 9f58db2a7e66..901b6ff06dfb 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8555CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
index a24722ccaebf..c2f9aea78b29 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8560ADS";
-- 
2.35.1



