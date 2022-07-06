Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF35567F42
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiGFHC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiGFHCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:02:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D3020BFF;
        Wed,  6 Jul 2022 00:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADF67B81AEA;
        Wed,  6 Jul 2022 07:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B0BC3411C;
        Wed,  6 Jul 2022 07:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657090966;
        bh=JeR0KbyZZV+KLlUkl6IIhRepoS9mcKYxvPfwaYMy0wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K4UXxN2dwZ+aBd8wt5ncN5WslDPK6JbOTgItp1aJmrKlxozGdRWgthg7L77IBEaQ3
         pafPWWhcxcfobuMlb24VBIW62VhLUWSDYubS8Zk46r5+8HYLK+a64TTF4ikJBB/sXP
         IXlkSzIjF4epS10WYQ7gV7BcKGWz8c8Szy1CZQFg=
Date:   Wed, 6 Jul 2022 09:02:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 96/98] hwmon: (occ) Remove sequence numbering and
 checksum calculation
Message-ID: <YsUzk3JXbxmVvwSS@kroah.com>
References: <20220705115617.568350164@linuxfoundation.org>
 <20220705115620.297922907@linuxfoundation.org>
 <CACPK8Xf0eujAq_oHzQn15hZyTL+QtDEaL5eUFCiODS+C06fW2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xf0eujAq_oHzQn15hZyTL+QtDEaL5eUFCiODS+C06fW2Q@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 06, 2022 at 06:43:47AM +0000, Joel Stanley wrote:
> On Tue, 5 Jul 2022 at 12:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Eddie James <eajames@linux.ibm.com>
> >
> > [ Upstream commit 908dbf0242e21dd95c69a1b0935814cd1abfc134 ]
> >
> > Checksumming of the request and sequence numbering is now done in the
> > OCC interface driver in order to keep unique sequence numbers. So
> > remove those in the hwmon driver. Also, add the command length to the
> > send_cmd function pointer, since the checksum must be placed in the
> > last two bytes of the command. The submit interface must receive the
> > exact size of the command - previously it could be rounded to the
> > nearest 8 bytes with no consequence.
> >
> > Signed-off-by: Eddie James <eajames@linux.ibm.com>
> > Acked-by: Guenter Roeck <linux@roeck-us.net>
> > Link: https://lore.kernel.org/r/20210721190231.117185-3-eajames@linux.ibm.com
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> If this patch is being backported then we must also backport:
> 
>   62f79f3d0eb9 ("fsi: occ: Force sequence numbering per OCC")
> 
> I was only cc'd on this one so I assume that means 62f79f3d0eb9 is not
> already in the queue.

It was not, so I have now added it, thanks.

greg k-h
