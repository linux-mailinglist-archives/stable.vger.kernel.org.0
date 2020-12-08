Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70682D2C30
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 14:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgLHNsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 08:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgLHNsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 08:48:21 -0500
Date:   Tue, 8 Dec 2020 08:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607435261;
        bh=XjtyEJooE8AMquKc7hSMGk/bMpF3csd5xIObrb8IsSM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAzqeRmveAFqBP4Fxj+jgeB1dITYVwxMGmCg/MvGLd1uamtmWgitj/1UG4jX9mVC9
         WZrvaATK1EDcWtDgpiG+g4LVJcPRhHsVgwZTIeFZJ2PzKrR14OsOmebVxUdPYAT6Zk
         cwsERAUkNo4K5OGf0+Emu40VRambR47WGtDmV5RnfPBC90F/jm2By/2Tn/EQrsDFQ8
         j3K5kcyUq/t+3Z6Tcgeefu3Z6nbYuXBSMN6cm93IdNj62q3KO4VrDijEh4FSrKaiWd
         4C1jlsFQ9Ch3JOi/u0EnvSzGyjjl14XJouxxeLsnnzPkMwElRbyoeJo4UeECIqUnyj
         s5NroMyfq6b3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208134739.GJ643756@sasha-vm>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201208073241.GA29998@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 08:32:41AM +0100, Lukas Wunner wrote:
>On Mon, Dec 07, 2020 at 05:49:01PM -0700, Nathan Chancellor wrote:
>> On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
>> > [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
>> >
>> > bcm2835aux_spi_remove() accesses the driver's private data after calling
>> > spi_unregister_master() even though that function releases the last
>> > reference on the spi_master and thereby frees the private data.
>> >
>> > Fix by switching over to the new devm_spi_alloc_master() helper which
>> > keeps the private data accessible until the driver has unbound.
>> >
>> > Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
>> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
>> > Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
>> > Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
>> > Cc: <stable@vger.kernel.org> # v4.4+
>> > Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
>> > Signed-off-by: Mark Brown <broonie@kernel.org>
>>
>> Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
>> assignment in bcm2835aux_spi_probe") is picked up with this patch in all
>> of the stable trees that it is applied to.
>
>That shouldn't be necessary as I've made sure that the backports to
>4.19 and earlier do not exhibit the issue fixed by d853b3406903.
>
>However, nobody is perfect, so if I've missed anything, please let
>me know.

Could we instead have the backports exhibit the issue (like they did
upstream) and then take d853b3406903 on top?

-- 
Thanks,
Sasha
