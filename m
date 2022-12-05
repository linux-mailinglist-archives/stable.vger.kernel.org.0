Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D87B642776
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 12:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiLEL05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 06:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLEL04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 06:26:56 -0500
Received: from smtp-out-07.comm2000.it (smtp-out-07.comm2000.it [212.97.32.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB9318370
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 03:26:54 -0800 (PST)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-07.comm2000.it (Postfix) with ESMTPSA id 04B633C2104;
        Mon,  5 Dec 2022 12:26:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670239612;
        bh=T5iUgqLM5/wTl1bWy1r9VQ72eZ+xJCXi7OjAOJZLSnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=fJSptKx3by6D7wAt+PgUu1Zi/Hmuo16Cpn5Yr8io+VGfuAVwzAxZ3fGCeG+XscN4U
         KVBM+qNDjWoBjjF9BOpXet8hlQmnV3l9Q1umhpFEYiY8BLeON7xn99fJAjjOrIK7dB
         JaE8o5dYiAddCRYqUi2N1a7YwNgChD5ANyk6yshdjpRZgSMjgRw1iI8xZl/50U4XD9
         IA1nHrULn1lUHlqdlTzXkhhc8zC9Y5i1OrsXS3dwvyeDUk016Zm6UUzegTH2lGFPnP
         tD7swS4nDZHnyb8SjSJxhAJoHjr3X49unF7SbXOYKS8L+h2jgnFQDUVNyKUHbrcIRL
         VVtdZoIFqidRA==
Date:   Mon, 5 Dec 2022 12:26:44 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
References: <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
 <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
 <20221202175730.231d75d5@xps-13>
 <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote:
> But here I would say this is a firmware bug and it might have to be handled
> like a firmware bug, i.e. with fixup in the partition parser. I seem to be
> changing my opinion here again.

I was thinking at this over the weekend, and I came to the following
ideas:

 - we need some improvement on the fixup we already have in the
   partition parser. We cannot ignore the fdt produced by U-Boot - as
   bad as it is.
 - the proposed fixup is fine for the immediate need, but it is
   not going to be enough to cover the general issue with the U-Boot
   generated partitions. U-Boot might keep generating partitions as direct
   child of the nand controller even when a partitions{} node is
   available. In this case the current parser just fails since it looks
   only into it and it will find it empty.
 - the current U-Boot only handle partitions{} as a direct child of the
   nand-controller, the nand-chip is ignored. This is not the way it is
   supposed to work. U-Boot code would need to be improved.

With all of that said I think that Miquel is right

> When a patch breaks a board and there is no straight fix, you revert
> it, then you think harder. That's what I am saying. This is a temporary
> solution.

?

Francesco


