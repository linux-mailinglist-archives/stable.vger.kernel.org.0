Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30A5272A8
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 17:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiENPed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiENPec (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 11:34:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A612D1A81E
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:34:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so5805924wma.4
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=taaUmm6/MPp1Wi5Mc3fnfGlDEbaPD3hQMKRhGbwYs9g=;
        b=H1ZT1/mPg/YRAGPCGcQHkd+IlgMJpNUTWSD2EdYGxDoty1pWZwvakoz5QX+GnkXF41
         Ztf4d+DTxW89VFuPyBglrDuCApxaNRzEVrHKq0J9hr2LOVv94PypGL8GGuIAATQyrl2U
         xL5icCDq0sAm/dQELh3EpFOQAB8GyE3lTopkBZsf53R5kKaWF4qFWMU/0z9p0kQbyI4I
         qh5QR6Dckwn388s0LuGyfCRVsT61PkaWgRGYj/WABnuCgULnoEis4bZBVJkvmAQ/1Zjw
         zfF8OZWjzx5VvUiQO+S+PwjlYS4hMUyX8IjXJO0DTmsWh0OJXMHDWy0CKXHafxL6RvXk
         9BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=taaUmm6/MPp1Wi5Mc3fnfGlDEbaPD3hQMKRhGbwYs9g=;
        b=3ekuS2Sx+wFeKVROp+hITfIrATEbduwK1zWzIbmwy+FPlCJ/Kh3nWyMEe5vLbIQmoJ
         ZeOB0665cvQWXKDZIK5/F0xDZufhc497Dj/uaaCfcNimXAH+AWyriPhEqHjqti1qLh1T
         Zi1GVhZCyte+cHkS9M9qEgISj1aN21s2xWilBaXx1HAPzhcuCW+mkqns6duowEDUYeZm
         5mam6fpCsax+mpuOvVlTTjQylzJJK4wUQj6pmvJweAUMZCRT6t77wXjuJceWOnEhfWCK
         OhnWcdrLIZIcpcE3s8R+8K51oR+DH01/7nb3/hQO8tnR0F0vPqXj515Z1zcY5WxlGDVy
         w0fg==
X-Gm-Message-State: AOAM531l7ZPt3kW/rUKZEEQvaxiAxxdOuG58tKA8+4i2PbkbhIi32Iso
        ATCoDJTTrYDA7Kx1W+BYnKs=
X-Google-Smtp-Source: ABdhPJwMx215YMK1JcczCAUwdynx6qPH4R3t6wQYhilO4RvkitfZitPchDGCbAMUk4mFwU4gqurrEQ==
X-Received: by 2002:a05:600c:2248:b0:394:31c6:b6ae with SMTP id a8-20020a05600c224800b0039431c6b6aemr19638233wmm.99.1652542467577;
        Sat, 14 May 2022 08:34:27 -0700 (PDT)
Received: from localhost.localdomain (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id n5-20020adfc605000000b0020c6a524fe0sm4914082wrg.98.2022.05.14.08.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 08:34:27 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip.mukherjee@sifive.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19] MIPS: fix allmodconfig build with latest mkimage
Date:   Sat, 14 May 2022 16:34:14 +0100
Message-Id: <20220514153414.6190-1-sudip.mukherjee@sifive.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

With the latest mkimage from U-Boot 2021.04+ the allmodconfig build
fails. 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit
addresses") was applied for similar build failure, but it was not
applied to 'arch/mips/generic/board-ocelot_pcb123.its.S' as that was
removed from upstream when the patch was applied.

Fixes: 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit addresses")
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/generic/board-ocelot_pcb123.its.S | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/generic/board-ocelot_pcb123.its.S b/arch/mips/generic/board-ocelot_pcb123.its.S
index 5a7d5e1c878af..6dd54b7c2f076 100644
--- a/arch/mips/generic/board-ocelot_pcb123.its.S
+++ b/arch/mips/generic/board-ocelot_pcb123.its.S
@@ -1,23 +1,23 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 / {
 	images {
-		fdt@ocelot_pcb123 {
+		fdt-ocelot_pcb123 {
 			description = "MSCC Ocelot PCB123 Device Tree";
 			data = /incbin/("boot/dts/mscc/ocelot_pcb123.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		conf@ocelot_pcb123 {
+		conf-ocelot_pcb123 {
 			description = "Ocelot Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@ocelot_pcb123";
+			kernel = "kernel";
+			fdt = "fdt-ocelot_pcb123";
 		};
 	};
 };
-- 
2.30.2

