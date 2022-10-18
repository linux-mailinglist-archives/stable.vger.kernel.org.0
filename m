Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A26028A3
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJRJqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJRJqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:46:09 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1279E2F1
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 02:45:59 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 247C7E0010;
        Tue, 18 Oct 2022 09:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666086358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS0a7NLTAVtCUU5qXkKelogy8H6f0tCHqv8SAAyPqTM=;
        b=pGgfGSIhPx4M6dnDOmPbf7BofuhBf2pEKBXyxGW9/dBMIExUm4el9ro+NpJBQqBd9u2zp1
        vcdFJUrdt36vWiOROlDSOsW0pfus12KPmATbk+54ayFwoXytY2Pycm373g8raQ10/FBdzy
        TUxt1UVl/bVLl2SnI1K2t2oxOw983nebLQC+F/KdE8hW+38KfVqv33adpVi6cdP5PhWMr4
        ntL9U7Hv39mrxWQy2xPnGL/4XrbxjC4i0B0TKJNEILunRVp49yHJj5xI/+5d4jcRV60BDE
        ll+YD1cq/GPGDPNiJMVL4ME2EOQDbJuI4HGCDkmKWR3Skw8H+HbOD9KDU9FSrw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2] mtd: parsers: bcm47xxpart: Fix halfblock reads
Date:   Tue, 18 Oct 2022 11:45:55 +0200
Message-Id: <20221018094555.542511-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018091129.280026-1-linus.walleij@linaro.org>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'05e258c6ec669d6d18c494ea03d35962d6f5b545'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-10-18 at 09:11:29 UTC, Linus Walleij wrote:
> There is some code in the parser that tries to read 0x8000
> bytes into a block to "read in the middle" of the block. Well
> that only works if the block is also 0x10000 bytes all the time,
> else we get these parse errors as we reach the end of the flash:
> 
> spi-nor spi0.0: mx25l1606e (2048 Kbytes)
> mtd_read error while parsing (offset: 0x200000): -22
> mtd_read error while parsing (offset: 0x201000): -22
> (...)
> 
> Fix the code to do what I think was intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: f0501e81fbaa ("mtd: bcm47xxpart: alternative MAGIC for board_data partition")
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
