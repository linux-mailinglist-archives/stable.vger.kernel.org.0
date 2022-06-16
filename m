Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F2154E544
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiFPOqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiFPOqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:46:52 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44B341993
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 07:46:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B498D1BF205;
        Thu, 16 Jun 2022 14:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655390809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AgQDX0Gq/OI8+a8WozmyXT5Ol2nvRQf46aPsDnWWlA=;
        b=FW+RdGfEDOT2EJzxbG8UuFhOhmQLknYXMup9cU9f7Pe+BJxanVliVRibxSUTVLCYEM3i8E
        7j+HsYDiMPIWJrhcbZkTZ5liG/u3yyiWFcAvsDgP1Lblv2jIEe95kfcEldOPLUUcv4OoMY
        uLGvEih61OsDvQLDlNhMzbD/eF6kbN+Zk2mB8dai86R9uKAwbjUqE0PHMjLPFpDR1gJtNY
        ickClivueBUTgBlLqb/4mJ4ynUsiPm2rtnP2eEu55gclBILEXOBFRrPNav7GcCUnfo9Ocx
        +jcSAC6hiAPZHkfvzkn/mCvWapS0FE/he7dyKazNaDyc8w5t10TvzQTEInDwAg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd@lists.infradead.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, Han Xu <han.xu@nxp.com>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting
Date:   Thu, 16 Jun 2022 16:46:47 +0200
Message-Id: <20220616144647.402987-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220614083138.3455683-1-s.hauer@pengutronix.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'06781a5026350cde699d2d10c9914a25c1524f45'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-06-14 at 08:31:38 UTC, Sascha Hauer wrote:
> The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:
> 
> | Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
> | mode. This value is the number of GPMI_CLK cycles multiplied by 4096.
> 
> So instead of multiplying the value in cycles with 4096, we have to
> divide it by that value. Use DIV_ROUND_UP to make sure we are on the
> safe side, especially when the calculated value in cycles is smaller
> than 4096 as typically the case.
> 
> This bug likely never triggered because any timeout != 0 usually will
> do. In my case the busy timeout in cycles was originally calculated as
> 2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
> taken for the 16 bit wide register field, so the register value was
> 0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
> setting") however the value in cycles became 2384, which multiplied
> with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
> intermediate timeout when reading from NAND.
> 
> Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of an empirical derivation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
