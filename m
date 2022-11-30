Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900F963D765
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 15:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiK3OBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 09:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3OBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 09:01:37 -0500
X-Greylist: delayed 563 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Nov 2022 06:01:35 PST
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25528E17;
        Wed, 30 Nov 2022 06:01:35 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id A26D5BA4158;
        Wed, 30 Nov 2022 14:52:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669816330;
        bh=pcIv7hJRQNuZYsBE+Cp2em/Jodkzbz5zoqpa315x034=;
        h=Date:From:To:Cc:Subject;
        b=cXhNocGTWt2Nr8ouAL8y7TnBnl3z3pr3rU+5N/qzSlTnToLORs78kRNeWI54XuXoA
         nOw/7/5toNmmQheiBdCPix8t5LpHtY8uA21gP1TQ1xEo54gd4+lcrAxnQ8nGCyjxYn
         8RdHpcjV7EG2zAmvV2c7Ex/mnuTse1cciYaJpIUa7ik2zdNpNJ7/FTen97Obk6bw8a
         5ZCx2ao33Iq3hQO/ffx5OH0GwRLaH2l5Ba6nvajCPyc3GK5NUbjel0aylpskCc3ecB
         kma0dK4VPkFb9JiCopzDrlUXByeqB7VkN/i12gtz5S6SoFbBMssEBp2+ntAnx67/6Q
         8bdQxmyrZUNVQ==
Date:   Wed, 30 Nov 2022 14:52:05 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>, Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Boot failure regression on 6.0.10 stable kernel on iMX7
Message-ID: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Marek,
it looks like commit 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller
size-cells"), that was backported to stable 6.0.10, introduce a boot
regression on colibri-imx7, at least.

What I get is

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 6.0.10 (francesco@francesco-nb) (arm-linux-gnueabihf-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.
4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #36 SMP Wed Nov 30 14:07:15 CET 2022
...
[    4.407499] gpmi-nand: error parsing ofpart partition /soc/nand-controller@33002000/partition@0 (/soc/nand-controller
@33002000)
[    4.438401] gpmi-nand 33002000.nand-controller: driver registered.
...
[    5.933906] VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0): error -19
[    5.946504] Please append a correct "root=" boot option; here are the available partitions:
...

Any idea? I'm not familiar with the gpmi-nand driver and I would just revert it, but
maybe you have a better idea.

Francesco


