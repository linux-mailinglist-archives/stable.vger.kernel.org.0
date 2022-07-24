Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0125E57F4DE
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 14:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiGXMB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 08:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGXMB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 08:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5937E13CC5;
        Sun, 24 Jul 2022 05:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDE9B80D41;
        Sun, 24 Jul 2022 12:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E84C3411E;
        Sun, 24 Jul 2022 12:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658664114;
        bh=GMLEQT2pKFD/Pptp979bJ5ZUw4UMKwp3CoxE5H11hEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YkUdYt0UINez1KTNfwcai06uMt5CK9o2KpPkby3wvrqC2Gv/dNqE0pzG6EfkJhS47
         xetJuGba2JULaZwnofEu1SB5EV2bDwBg/CKsgfeUVmN72n7U432e6Ogj5C80kjNloD
         vBpfuUZ1bQ3BJva9zYExsXbDs6kq6x7svsdnfLHZzeyVWil4hOebLqNR1on9G49V/G
         uUWyQgcRUzFDmOj0uFtsSUjYLK/gLFwEsgLaG0R0BYXv2JAJUIqhdWTLF1YwThzVMx
         /Ri2WBCpuf24ZDusklvkoW3DvUBbAj/1eBeSRqKx+yjGAO9J966Xag4eBrBXI1CU3I
         baesRdrHr6STw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oFaJ7-0006To-VN; Sun, 24 Jul 2022 14:02:02 +0200
Date:   Sun, 24 Jul 2022 14:02:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] USB: serial: ftdi_sio: Fix divisor overflow
Message-ID: <Yt00uQq5eixylBeL@hovoldconsulting.com>
References: <20220712115306.26471-1-kabel@kernel.org>
 <20220712115306.26471-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220712115306.26471-2-kabel@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 01:53:00PM +0200, Marek Behún wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> The baud rate generating divisor is a 17-bit wide (14 bits integer part
> and 3 bits fractional part).
> 
> Example:
>   base clock = 48 MHz
>   requested baud rate = 180 Baud
>   divisor = 48,000,000 / (16 * 180) = 0b100000100011010.101
> 
>   In this case the MSB gets discarded because of the overflow, and the
>   actually used divisor will be 0b100011010.101 = 282.625, resulting
>   in baud rate 10615 Baud, instead of the requested 180 Baud.
> 
> The best possible thing to do in this case is to generate lowest possible
> baud rate (in the example it would be 183 Baud), by using maximum possible
> divisor.

Actually, the best way to handle this is to add a sanity check for the
lowest supported check as you do in the next patch. That one makes this
change superfluous.

> In case of divisor overflow, use maximum possible divisor.

Johan
