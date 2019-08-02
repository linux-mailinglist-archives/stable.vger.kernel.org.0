Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C337F610
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfHBLea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 07:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfHBLea (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 07:34:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 985282087C;
        Fri,  2 Aug 2019 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564745669;
        bh=jvdfRbhCdVfaC4jnfWn0lWKgluhsRXKIpW+7VxrZoLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmOKmvJVSg2c+bfgAWqrbrqtHsDhgUS4gyA7TKMIgVfI++9GOIG2ojnm8uouKoc+F
         zzijxYA8k+YQ3pkFuZU+2rct+VrHII4BUzpNE0HJSG0AkpVfY8Al2WBcK/0EL/e1PZ
         DrTmBM50Isjg1keXm+ZHjAnsK0yQyTjORiXuD3Eg=
Date:   Fri, 2 Aug 2019 13:34:27 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com" 
        <syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com>,
        "syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com" 
        <syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com>,
        "syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com" 
        <syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com>,
        "syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com" 
        <syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com" 
        <syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com" 
        <syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com>
Subject: Re: [PATCH 4.14 43/43] tipc: pass tunnel dev as NULL to
 udp_tunnel(6)_xmit_skb
Message-ID: <20190802113427.GA32398@kroah.com>
References: <20190702080123.904399496@linuxfoundation.org>
 <20190702080126.138655706@linuxfoundation.org>
 <0f105a3696611dc10aa4d7c5c22ffac031b3c098.camel@nokia.com>
 <20190802072834.GC26174@kroah.com>
 <88c88ec44e93c07170891bdf391d2b6251c7041a.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88c88ec44e93c07170891bdf391d2b6251c7041a.camel@nokia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 11:03:15AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Fri, 2019-08-02 at 09:28 +0200, gregkh@linuxfoundation.org wrote:
> > On Thu, Aug 01, 2019 at 10:17:30AM +0000, Rantala, Tommi T. (Nokia -
> > FI/Espoo) wrote:
> > > Hi,
> > > 
> > > This tipc patch added in 4.14.132 is triggering a crash for me,
> > > revert
> > > fixes it.
> > > 
> > > Anyone have ideas if some other commits missing in 4.14.x to make
> > > this
> > > work...?
> > 
> > Do you also hav a problem with 4.19.y?  How about 5.2.y?  If not, can
> > you do 'git bisect' to find the patch that fixes the issue?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi, please pick this to 4.14.y and 4.19.y, tested that it fixes the
> crash in both:
> 
> commit 5684abf7020dfc5f0b6ba1d68eda3663871fce52
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Mon Jun 17 21:34:13 2019 +0800
> 
>     ip_tunnel: allow not to count pkts on tstats by setting skb's dev
> to NULL
> 
> 
> For 5.2.y nothing is needed, these commits were in v5.2-rc6 already.

Thanks for the info, now snuck into the latest round of -rc releases.

greg k-h
