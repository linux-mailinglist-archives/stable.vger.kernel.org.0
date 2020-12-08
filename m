Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33B42D2462
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 08:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgLHHdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 02:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgLHHdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 02:33:24 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E404C061749
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 23:32:44 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id CC329100FBFEF;
        Tue,  8 Dec 2020 08:32:40 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 87B9B1F5C; Tue,  8 Dec 2020 08:32:41 +0100 (CET)
Date:   Tue, 8 Dec 2020 08:32:41 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208073241.GA29998@wunner.de>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208004901.GB587492@ubuntu-m3-large-x86>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 05:49:01PM -0700, Nathan Chancellor wrote:
> On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
> > [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
> > 
> > bcm2835aux_spi_remove() accesses the driver's private data after calling
> > spi_unregister_master() even though that function releases the last
> > reference on the spi_master and thereby frees the private data.
> > 
> > Fix by switching over to the new devm_spi_alloc_master() helper which
> > keeps the private data accessible until the driver has unbound.
> > 
> > Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
> > Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
> > Cc: <stable@vger.kernel.org> # v4.4+
> > Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
> assignment in bcm2835aux_spi_probe") is picked up with this patch in all
> of the stable trees that it is applied to.

That shouldn't be necessary as I've made sure that the backports to
4.19 and earlier do not exhibit the issue fixed by d853b3406903.

However, nobody is perfect, so if I've missed anything, please let
me know.

Thanks!

Lukas
