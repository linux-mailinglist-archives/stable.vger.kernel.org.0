Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F15E60F4DD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiJ0KYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiJ0KYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8730D0CE8;
        Thu, 27 Oct 2022 03:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E7AFB82566;
        Thu, 27 Oct 2022 10:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A144BC433D6;
        Thu, 27 Oct 2022 10:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666866246;
        bh=1dRlyoqNo2lQZVhFChkdWsF93QswXi8tXslZBqO7X2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNiE6qwhVR8USwszuNV7xFA/dGukC36gq4+yqssWN5gYOZf8TCTRVkGoSJGWLGeS1
         XGMZg+6MCu86lbDtO6wsL9IOcnZVT+xWz37+3itfR2LYcUZhlXiappCCWYx+0zNt21
         qyyx413yIv/axzDy/Qdaj5ya6eLPA0JJvDpbC44U=
Date:   Thu, 27 Oct 2022 12:24:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.10 v2 1/2] serial: core: move RS485 configuration tasks
 from drivers into core
Message-ID: <Y1pcQyaYTXE+KoBa@kroah.com>
References: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
 <Y1lmM7Qu1yscuaIU@kroah.com>
 <Y1nPFe6IaRI7j6fE@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1nPFe6IaRI7j6fE@atmark-techno.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 09:21:41AM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Wed, Oct 26, 2022 at 06:54:11PM +0200:
> > On Mon, Oct 17, 2022 at 02:17:36PM +0900, Dominique Martinet wrote:
> > > From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > > 
> > > Several drivers that support setting the RS485 configuration via userspace
> > > implement one or more of the following tasks:
> > > 
> > > - in case of an invalid RTS configuration (both RTS after send and RTS on
> > >   send set or both unset) fall back to enable RTS on send and disable RTS
> > >   after send
> > > 
> > > - nullify the padding field of the returned serial_rs485 struct
> > > 
> > > - copy the configuration into the uart port struct
> > > 
> > > - limit RTS delays to 100 ms
> > > 
> > > Move these tasks into the serial core to make them generic and to provide
> > > a consistent behaviour among all drivers.
> > > 
> > > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > > Link: https://lore.kernel.org/r/20220410104642.32195-2-LinoSanfilippo@gmx.de
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > [ Upstream commit 0ed12afa5655512ee418047fb3546d229df20aa1 ]
> > > Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
> > > Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> > > ---
> > > Follow-up of https://lkml.kernel.org/r/20221017013807.34614-1-dominique.martinet@atmark-techno.com
> > 
> > I need a 5.15.y version of this series before I can take the 5.10.y
> > version.
> 
> Thanks for the probing, I did not know about this rule (but it makes
> sense); I've just sent a 5.15 version:
> https://lkml.kernel.org/r/20221027001943.637449-1-dominique.martinet@atmark-techno.com
> 
> I'd really appreciate if Lino could take a look and confirm we didn't
> botch this too much -- we've tested the 5.10 version and it looks ok,
> but this is different enough from the original patch to warrant a check
> from the author.

Ok, I'll wait for an ACK from Lino for both of these series before
taking them.

thanks,

greg k-h
