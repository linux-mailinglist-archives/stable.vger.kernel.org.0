Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9951B60474E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiJSNhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiJSNgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:36:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB03814EC46;
        Wed, 19 Oct 2022 06:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15ABFB82476;
        Wed, 19 Oct 2022 09:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89808C433C1;
        Wed, 19 Oct 2022 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170324;
        bh=Wx81bFGklbMM4d2EYeslYJlmfJiZ5tfrj5cy7G8MD9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udaDnnP7Flgmq58VqJjHq6hIfyjvUMVy1P0RKRZ8uOzmzZwSJ3CV0Hw4uBf4AI7YY
         829ZyPQ7AhePSBOcWMuDewDDSAzIK9/OkQHOD3uZQwy9QvI7dtzZoIODMtY6P1x3vn
         x7PHnZcDHkjHfi4KiEHW6uWRAWV0YnG+WRlsd+U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 613/862] powerpc: dts: turris1x.dts: Fix NOR partitions labels
Date:   Wed, 19 Oct 2022 10:31:40 +0200
Message-Id: <20221019083317.008903237@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c9986f0aefd1ae22fe9cf794d49699643f1e268b ]

Partition partition@20000 contains generic kernel image and it does not
have to be used only for rescue purposes. Partition partition@1c0000
contains bootable rescue system and partition partition@340000 contains
factory image/data for restoring to NAND. So change partition labels to
better fit their purpose by removing possible misleading substring "rootfs"
from these labels.

Fixes: 54c15ec3b738 ("powerpc: dts: Add DTS file for CZ.NIC Turris 1.x routers")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220830225500.8856-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/turris1x.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/boot/dts/turris1x.dts b/arch/powerpc/boot/dts/turris1x.dts
index 12e08271e61f..47027b4cebb3 100644
--- a/arch/powerpc/boot/dts/turris1x.dts
+++ b/arch/powerpc/boot/dts/turris1x.dts
@@ -263,21 +263,21 @@
 				};
 
 				partition@20000 {
-					/* 1.7 MB for Rescue Linux Kernel Image */
+					/* 1.7 MB for Linux Kernel Image */
 					reg = <0x00020000 0x001a0000>;
-					label = "rescue-kernel";
+					label = "kernel";
 				};
 
 				partition@1c0000 {
 					/* 1.5 MB for Rescue JFFS2 Root File System */
 					reg = <0x001c0000 0x00180000>;
-					label = "rescue-rootfs";
+					label = "rescue";
 				};
 
 				partition@340000 {
-					/* 11 MB for TAR.XZ Backup with content of NAND Root File System */
+					/* 11 MB for TAR.XZ Archive with Factory content of NAND Root File System */
 					reg = <0x00340000 0x00b00000>;
-					label = "backup-rootfs";
+					label = "factory";
 				};
 
 				partition@e40000 {
-- 
2.35.1



