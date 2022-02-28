Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072A24C7592
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiB1Rzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiB1Rya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB38255BF;
        Mon, 28 Feb 2022 09:42:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BCDFCE17D2;
        Mon, 28 Feb 2022 17:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAA6C340E7;
        Mon, 28 Feb 2022 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070159;
        bh=V6newwJbWXuT//dCdjfZeDJPjFDcTXvCBqBZ7lsONFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1B9Qe/J0NiWXx6HbMW9l5KvSZtjH0NkkdJ87li8xVQLNPa+c/qKX6Z6kx4dPVIgs1
         zODWR2wP7d+X/RwmJudrAe/T6X4ReZI8X/LyE6nvuz3zW+zMgmc1Oexo534zcv7ozY
         zSYMqgwqyn/qdXpTknOa2/iIjiRLwQ6RTtDHpcTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 126/139] riscv: fix nommu_k210_sdcard_defconfig
Date:   Mon, 28 Feb 2022 18:25:00 +0100
Message-Id: <20220228172400.913599597@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 762e52f79c95ea20a7229674ffd13b94d7d8959c upstream.

Instead of an arbitrary delay, use the "rootwait" kernel option to wait
for the mmc root device to be ready.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Fixes: 7e09fd3994c5 ("riscv: Add Canaan Kendryte K210 SD card defconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/configs/nommu_k210_sdcard_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/configs/nommu_k210_sdcard_defconfig
+++ b/arch/riscv/configs/nommu_k210_sdcard_defconfig
@@ -23,7 +23,7 @@ CONFIG_SLOB=y
 CONFIG_SOC_CANAAN=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_CMDLINE="earlycon console=ttySIF0 rootdelay=2 root=/dev/mmcblk0p1 ro"
+CONFIG_CMDLINE="earlycon console=ttySIF0 root=/dev/mmcblk0p1 rootwait ro"
 CONFIG_CMDLINE_FORCE=y
 # CONFIG_SECCOMP is not set
 # CONFIG_STACKPROTECTOR is not set


