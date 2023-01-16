Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04066C143
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjAPOJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbjAPOHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:07:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C67C241FE;
        Mon, 16 Jan 2023 06:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A786B80F3B;
        Mon, 16 Jan 2023 14:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4DFC433F2;
        Mon, 16 Jan 2023 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877833;
        bh=AgbP4UF0OGtNMc5oV5qYFEIgH8m/mSymZ+QODpU4BOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjN+gSBbyyAU+n3Il6ODuYNp0SfT2FjVYbp+rDRx8lyljoFWUY7kD7ClAftBp1ESl
         a0IyzThqvRxxzppZeqYiCQuVIdRRDUCOA/y5316Ndryi7TQNJWIIpPtYs50OucebjC
         bwe0neVn3pG+1PsDGB/GrirMyaSXMCkTsGn4hTF/hDJRFsUFCDHVrGqvHqS6B94guP
         jCfSlxIoR544hieK5SagsMkOgD578NQ35QjR0sF5xkUrx94iyTEfYXR2p5Q7F2qvG3
         JRzlEimWbYq9Pfc6Fjr6I9u/PO6ParvRg7TXCL/aCOM1Pjlc95n4PHgNoKv3htYig1
         xmcQAWdjbieyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 52/53] ata: pata_cs5535: Don't build on UML
Date:   Mon, 16 Jan 2023 09:01:52 -0500
Message-Id: <20230116140154.114951-52-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Foley <pefoley2@pefoley.com>

[ Upstream commit 22eebaa631c40f3dac169ba781e0de471b83bf45 ]

This driver uses MSR functions that aren't implemented under UML.
Avoid building it to prevent tripping up allyesconfig.

e.g.
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x3a3): undefined reference to `__tracepoint_read_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x3d2): undefined reference to `__tracepoint_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x457): undefined reference to `__tracepoint_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x481): undefined reference to `do_trace_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x4d5): undefined reference to `do_trace_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x4f5): undefined reference to `do_trace_read_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x51c): undefined reference to `do_trace_write_msr'

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36833a862998..d9b305a3427f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -650,6 +650,7 @@ config PATA_CS5530
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
 	depends on PCI && (X86_32 || (X86_64 && COMPILE_TEST))
+	depends on !UML
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
-- 
2.35.1

