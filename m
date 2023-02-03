Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA2768916F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjBCH7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBCH7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:59:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D9186AE;
        Thu,  2 Feb 2023 23:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54444CE2F1B;
        Fri,  3 Feb 2023 07:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588CDC433D2;
        Fri,  3 Feb 2023 07:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675411139;
        bh=/R2JWLhMawdOa6fsE3U4ILeUPr9J2AF9dkOPohAi+Yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x//EX1spfRB5uvMdJ9XGOwy2zIbPAvLhlaFtpwBqM3UjYcsr8iwFv8siUL9e4oqHn
         3qHp4jNsqaKU471OxA39SAppzwonmYq8w6OHE2ysU5Mu0T4dP8i3mj+TK+EcGiRnFX
         XmPM28uNbWH7Vp0Z+cjHicIhhg2BM7iyWrjrvqyw=
Date:   Fri, 3 Feb 2023 08:58:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "open list:USB XHCI DRIVER" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH stable 5.4] usb: host: xhci-plat: add wakeup entry at
 sysfs
Message-ID: <Y9y+wRPYzQVwb3JS@kroah.com>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
 <20230201174404.32777-3-f.fainelli@gmail.com>
 <Y9qsZysFUFnq7VQW@kroah.com>
 <319ebea0-61dc-2e08-f48b-4555b8fb894a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <319ebea0-61dc-2e08-f48b-4555b8fb894a@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 03:19:08PM -0800, Florian Fainelli wrote:
> On 2/1/23 10:16, Greg Kroah-Hartman wrote:
> > On Wed, Feb 01, 2023 at 09:44:04AM -0800, Florian Fainelli wrote:
> > > From: Peter Chen <peter.chen@nxp.com>
> > > 
> > > commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream
> > > 
> > > With this change, there will be a wakeup entry at /sys/../power/wakeup,
> > > and the user could use this entry to choose whether enable xhci wakeup
> > > features (wake up system from suspend) or not.
> > > 
> > > Tested-by: Matthias Kaehlcke <mka@chromium.org>
> > > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > ---
> > >   drivers/usb/host/xhci-plat.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Why is this new feature needed on these older kernels?  What does it fix
> > that is broken?
> 
> It fixes the inability to make the XHCI controller a wake-up device since
> there is no /sys/*/*xhci/power/wakeup sysfs entry to manipulate unless this
> patch is applied.

But that is a new feature, not a bugfix.

What systems need this for these older kernels that will actually update
to them in order to pick up this change?

thanks,

greg k-h
