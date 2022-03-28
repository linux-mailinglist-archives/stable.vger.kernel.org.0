Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534D64E92C8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 12:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbiC1Kw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 06:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiC1KwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 06:52:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD8A4E387
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 03:50:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nYmxK-0006yj-FT; Mon, 28 Mar 2022 12:50:38 +0200
Message-ID: <c807ca8c-3065-cdec-8e2b-5d5a77529c69@pengutronix.de>
Date:   Mon, 28 Mar 2022 12:50:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Tokunori Ikegami <ikegami.t@gmail.com>, miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220323170458.5608-1-ikegami.t@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Tokunori-san,

On 23.03.22 18:04, Tokunori Ikegami wrote:
> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> check correct value") buffered writes fail on S29GL064N. This is
> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> write completion, where as, chip_good() check expects actual data
> written to the last location to be returned post DQ polling completion.
> Fix is to revert to using chip_good() for S29GL064N which only checks
> for DQ lines to settle down to determine write completion.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

For this series,

Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Thanks a lot for taking care of this. Could you keep me Cc'd
on future revisions? Convention is via a Reported-by tag
in the regression fix.

Cheers,
Ahmad


> 
> Tokunori Ikegami (4):
>   mtd: cfi_cmdset_0002: Move and rename
>     chip_check/chip_ready/chip_good_for_write
>   mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
>   mtd: cfi_cmdset_0002: Add S29GL064N ID definition
>   mtd: cfi_cmdset_0002: Rename chip_ready variables
> 
>  drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
>  include/linux/mtd/cfi.h             |   1 +
>  2 files changed, 55 insertions(+), 58 deletions(-)
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
