Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A636D7ED6F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbfHBH2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732932AbfHBH2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:28:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6B820657;
        Fri,  2 Aug 2019 07:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564730916;
        bh=I9CoSWbf9W6mjmxzJqFaXYB32Oa+U0NF3HCUKJAqSS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IoB94gQcJeTOd4Mve4JFeXfmqeL7Y38ltfLSqKFUIZJlq+TH+dVhtxetNahwdPrvX
         eb7lewD8y2rVR3CFXGtIjxHXmA997e9dGvNHfeJU1IOwdIRGiG2DYtwGEPgZDzPZMs
         mhzG9H89x4jjmJ9HGSb4j2gQdpNTfwVePx1Hmzhc=
Date:   Fri, 2 Aug 2019 09:28:34 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com" 
        <syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com>,
        "syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com" 
        <syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com>,
        "syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com" 
        <syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com" 
        <syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com>,
        "syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com" 
        <syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com" 
        <syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com>
Subject: Re: [PATCH 4.14 43/43] tipc: pass tunnel dev as NULL to
 udp_tunnel(6)_xmit_skb
Message-ID: <20190802072834.GC26174@kroah.com>
References: <20190702080123.904399496@linuxfoundation.org>
 <20190702080126.138655706@linuxfoundation.org>
 <0f105a3696611dc10aa4d7c5c22ffac031b3c098.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f105a3696611dc10aa4d7c5c22ffac031b3c098.camel@nokia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 10:17:30AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Tue, 2019-07-02 at 10:02 +0200, Greg Kroah-Hartman wrote:
> > From: Xin Long <lucien.xin@gmail.com>
> > 
> > commit c3bcde026684c62d7a2b6f626dc7cf763833875c upstream.
> > 
> > udp_tunnel(6)_xmit_skb() called by tipc_udp_xmit() expects a tunnel
> > device
> > to count packets on dev->tstats, a perpcu variable. However, TIPC is
> > using
> > udp tunnel with no tunnel device, and pass the lower dev, like veth
> > device
> > that only initializes dev->lstats(a perpcu variable) when creating
> > it.
> 
> Hi,
> 
> This tipc patch added in 4.14.132 is triggering a crash for me, revert
> fixes it.
> 
> Anyone have ideas if some other commits missing in 4.14.x to make this
> work...?

Do you also hav a problem with 4.19.y?  How about 5.2.y?  If not, can
you do 'git bisect' to find the patch that fixes the issue?

thanks,

greg k-h
