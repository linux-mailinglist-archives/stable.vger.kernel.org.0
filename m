Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E340528F0E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbiEPTnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiEPTmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB353FBC2;
        Mon, 16 May 2022 12:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF84F61510;
        Mon, 16 May 2022 19:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBA9C36AF6;
        Mon, 16 May 2022 19:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730125;
        bh=KhyYJBe1zq4w8/BrBLLGT3YQik0FWXZFDkLKsh4CQ9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQGXfjVM6y0FP5HQT3daGP+BEGaTnYQgePGKboFDrTJlGFhixMkn2K7/Nv63IArRi
         wQWFzkY8veaGKtm+CzbzSb2H1PcQLrwWaiQ4W6ClQVCpGU5BTZ5BoQPfwIzQztp8ue
         +F9b0p1/f0u7/Ow8RKQqv9pff/yyGhh37tkvxF9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 30/32] MIPS: fix allmodconfig build with latest mkimage
Date:   Mon, 16 May 2022 21:36:44 +0200
Message-Id: <20220516193615.666983839@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/generic/board-ocelot_pcb123.its.S |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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


