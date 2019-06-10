Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574673AECC
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbfFJF4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 01:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387667AbfFJF4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 01:56:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDA4207E0;
        Mon, 10 Jun 2019 05:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560146214;
        bh=otPJTHxlokMjeljQtLNP9Lovq2qwmoC6xNsCFs/aF0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vmpstn2Luy8OSYtFL5NCL4Kf6dphtYgGHs0Oi4/pglIW83K+jfrqsLMCbDRIyueUc
         4adiZKoT1JCaKrsjwfVysykGTcyKOEI2EzFR0JCjJGFfeuIT7nuowRap84NY8Aj+rg
         RsxVqXq6PvHJxGzUPCpQIJMtEWP519BHrHWruKdI=
Date:   Mon, 10 Jun 2019 07:56:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan.maguire@oracle.com, dsahern@gmail.com, davem@davemloft.net
Subject: Re: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
Message-ID: <20190610055652.GD13825@kroah.com>
References: <20190609164125.377368385@linuxfoundation.org>
 <20190609164125.756810906@linuxfoundation.org>
 <20190610011024.utn5fft7nocabqxb@toshiba.co.jp>
 <OSBPR01MB418448C373F7E3F2D4BCFE0592130@OSBPR01MB4184.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB418448C373F7E3F2D4BCFE0592130@OSBPR01MB4184.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 01:13:16AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi again.
> 
> > -----Original Message-----
> > From: stable-owner@vger.kernel.org
> > [mailto:stable-owner@vger.kernel.org] On Behalf Of Nobuhiro Iwamatsu
> > Sent: Monday, June 10, 2019 10:10 AM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Alan Maguire
> > <alan.maguire@oracle.com>; David Ahern <dsahern@gmail.com>; David S.
> > Miller <davem@davemloft.net>
> > Subject: Re: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref
> > in neigh_xmit
> > 
> > Hi,
> > 
> > On Sun, Jun 09, 2019 at 06:42:09PM +0200, Greg Kroah-Hartman wrote:
> > > From: David Ahern <dsahern@gmail.com>
> > >
> > > [ Upstream commit 4b2a2bfeb3f056461a90bd621e8bd7d03fa47f60 ]
> > >
> > > Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
> > > INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was
> > > not updated to use the altered key. The result is that every packet
> > Tx
> > > does a lookup on the gateway address which does not find an entry, a
> > > new one is created only to find the existing one in the table right
> > > before the insert since arp_constructor was updated to reset the
> > > primary key. This is seen in the allocs and destroys counters:
> > >     ip -s -4 ntable show | head -10 | grep alloc
> > >
> > > which increase for each packet showing the unnecessary overhread.
> > >
> > > Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for
> > NEIGH_ARP_TABLE.
> > >
> > > Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for
> > > loopback/point-to-point devices be INADDR_ANY")
> > > Reported-by: Alan Maguire <alan.maguire@oracle.com>
> > > Signed-off-by: David Ahern <dsahern@gmail.com>
> > > Tested-by: Alan Maguire <alan.maguire@oracle.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > 
> > This commit also requires the following commit:
> > 
> > commit 9b3040a6aafd7898ece7fc7efcbca71e42aa8069
> > Author: David Ahern <dsahern@gmail.com>
> > Date:   Sun May 5 11:16:20 2019 -0700
> > 
> >     ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled
> > 
> >     Define __ipv4_neigh_lookup_noref to return NULL when CONFIG_INET is
> > disabled.
> > 
> >     Fixes: 4b2a2bfeb3f0 ("neighbor: Call __ipv4_neigh_lookup_noref in
> > neigh_xmit")
> >     Reported-by: kbuild test robot <lkp@intel.com>
> >     Signed-off-by: David Ahern <dsahern@gmail.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > And this is also necessary for 4.4.y, 4.14.y, 4.19.y and 5.1.y.
> 
> 4.4.y, 4.9.y, 4.19.y and 5.1.y.

Thanks for the information, now queued up everywhere.

greg k-h
