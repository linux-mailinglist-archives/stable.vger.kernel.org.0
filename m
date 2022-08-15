Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E2593D21
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbiHOUN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346685AbiHOUL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D93784ED8;
        Mon, 15 Aug 2022 11:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F396126A;
        Mon, 15 Aug 2022 18:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F5BC433D7;
        Mon, 15 Aug 2022 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589887;
        bh=OJljRTS4HyrlDm+ltcUSILqSsYkZQZT6YDGYiSn4cUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZBTZsnghi95o2DQwA062C4wlxLF5dNPQNZIDn2+npXRqymO1qM/OUVTAoXtjdekv
         frW78oxzGMNJWT5DvZU1bVxVQkooDkNhxj/4j5HPkKLHuQs2dq08K6H6t61XoN0jyk
         exqlovFKQwRC5r+EhFzMSur3n8RflOEP/0GOqlBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Kettenis <kettenis@openbsd.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0063/1095] riscv: dts: starfive: correct number of external interrupts
Date:   Mon, 15 Aug 2022 19:51:02 +0200
Message-Id: <20220815180432.107680149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Kettenis <kettenis@openbsd.org>

commit a208acf0eac857dc8cdaddd63a4e18ed03f91786 upstream.

The PLIC integrated on the Vic_U7_Core integrated on the StarFive
JH7100 SoC actually supports 133 external interrupts.  127 of these
are exposed to the outside world; the remainder are used by other
devices that are part of the core-complex such as the L2 cache
controller.  But all 133 interrupts are external interrupts as far
as the PLIC is concerned.  Fix the property so that the driver can
manage these additional interrupts, which is important since the
interrupts for the L2 cache controller are enabled by default.

Fixes: ec85362fb121 ("RISC-V: Add initial StarFive JH7100 device tree")
Signed-off-by: Mark Kettenis <kettenis@openbsd.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220707185529.19509-1-kettenis@openbsd.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7100.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
@@ -118,7 +118,7 @@
 			interrupt-controller;
 			#address-cells = <0>;
 			#interrupt-cells = <1>;
-			riscv,ndev = <127>;
+			riscv,ndev = <133>;
 		};
 
 		clkgen: clock-controller@11800000 {


