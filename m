Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31E04D8353
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbiCNMOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241417AbiCNMNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781AD377D1;
        Mon, 14 Mar 2022 05:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA683B80DF7;
        Mon, 14 Mar 2022 12:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23102C340E9;
        Mon, 14 Mar 2022 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259874;
        bh=lzXN0yqho0btcDFNZrpwcXbRMY5b7bhdoQTFdHr3z+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI6Ys++P2bwk0+uR64/DqEkbiTTxZbe7GIgizZflsc1ka+YfZQQwdaNoxdXrolhc+
         AC6DqPmA8D+ZxYHVuoCMBA64BWN5W6zouZDZzaCQ4hnEjT0RN6TcgV2hSOrBqt30Ht
         tWheJGIM6NVl6YS7lUgezKYu5JvqMlj//M8kBhxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 108/110] riscv: dts: k210: fix broken IRQs on hart1
Date:   Mon, 14 Mar 2022 12:54:50 +0100
Message-Id: <20220314112746.041465285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 74583f1b92cb3bbba1a3741cea237545c56f506c upstream.

Commit 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
incorrectly removed two entries from the PLIC interrupt-controller node's
interrupts-extended property.

The PLIC driver cannot know the mapping between hart contexts and hart ids,
so this information has to be provided by device tree, as specified by the
PLIC device tree binding.

The PLIC driver uses the interrupts-extended property, and initializes the
hart context registers in the exact same order as provided by the
interrupts-extended property.

In other words, if we don't specify the S-mode interrupts, the PLIC driver
will simply initialize the hart0 S-mode hart context with the hart1 M-mode
configuration. It is therefore essential to specify the S-mode IRQs even
though the system itself will only ever be running in M-mode.

Re-add the S-mode interrupts, so that we get working IRQs on hart1 again.

Cc: <stable@vger.kernel.org>
Fixes: 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/canaan/k210.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -113,7 +113,8 @@
 			compatible = "canaan,k210-plic", "sifive,plic-1.0.0";
 			reg = <0xC000000 0x4000000>;
 			interrupt-controller;
-			interrupts-extended = <&cpu0_intc 11 &cpu1_intc 11>;
+			interrupts-extended = <&cpu0_intc 11>, <&cpu0_intc 9>,
+					      <&cpu1_intc 11>, <&cpu1_intc 9>;
 			riscv,ndev = <65>;
 		};
 


