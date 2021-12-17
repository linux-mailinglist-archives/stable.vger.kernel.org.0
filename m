Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3947851D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 07:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhLQGia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 01:38:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46288 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhLQGi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 01:38:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B4EB82670;
        Fri, 17 Dec 2021 06:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBFAC36AE7;
        Fri, 17 Dec 2021 06:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639723105;
        bh=fHbtIkvovPfdrfRw8ful3Ocr80jVGppXDijSL9G9558=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GpOKt2zuxjHvmQkIs/WDWniWgWmo1y9qPYZYSvXcMbJN+KS52K9gADBZVsg/bRwoS
         u59YyHZGov2xo9lRSOPxoPKfznTvkOIIRZ3W2EluxihVgvk1gOzmy3I5RCEekPCg2e
         8ibO0BRci84cbqLnByxsbZZiIjXG0+XWjW7euulQ=
Date:   Fri, 17 Dec 2021 07:38:17 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: LTS "Warning: file conntrack_vrf.sh is not executable, correct
 this."
Message-ID: <YbwwWXH4RS+cPn+0@kroah.com>
References: <234d7a6a81664610fdf21ac72730f8bd10d3f46f.camel@nokia.com>
 <YbrzsZf/arqfZ3DT@kroah.com>
 <Ybr1MgpKlNlVHMPq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybr1MgpKlNlVHMPq@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 09:13:38AM +0100, gregkh@linuxfoundation.org wrote:
> On Thu, Dec 16, 2021 at 09:07:13AM +0100, gregkh@linuxfoundation.org wrote:
> > On Thu, Dec 16, 2021 at 08:00:30AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> > > Hi Greg,
> > > 
> > > Incorrect 0644 in LTS for new selftest file, seen in 5.4.165 since
> > > "selftests: netfilter: add a vrf+conntrack testcase" was added to LTS.
> > > It's correct 755 in upstream, but somehow messed up in LTS :-(
> > 
> > That is because quilt/git can not set modes of files.
> > 
> > > linux-5.4.y
> > > ===========
> > > commit 8d3563ecbca3526fcc6639065c9fb11b2f234706
> > > Author: Florian Westphal <fw@strlen.de>
> > > Date:   Mon Oct 18 14:38:13 2021 +0200
> > > 
> > >     selftests: netfilter: add a vrf+conntrack testcase
> > >     
> > >     commit 33b8aad21ac175eba9577a73eb62b0aa141c241c upstream.
> > > 
> > > [...]    
> > > diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
> > > new file mode 100644           <----------------
> > > 
> > > 
> > > linux-5.15.y
> > > ============
> > > commit cffab968e94e513bdcef25e11402243ce2919803
> > > [...]
> > > new file mode 100644           <----------------
> > > 
> > > 
> > > upstream
> > > ========
> > > $ git show 33b8aad21ac175eba9577a73eb62b0aa141c241c
> > > 
> > > commit 33b8aad21ac175eba9577a73eb62b0aa141c241c
> > > Author: Florian Westphal <fw@strlen.de>
> > > Date:   Mon Oct 18 14:38:13 2021 +0200
> > > 
> > >     selftests: netfilter: add a vrf+conntrack testcase
> > >     
> > > [...]
> > > diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
> > > new file mode 100755          <-----------------------
> > > 
> > > 
> > > -Tommi
> > > 
> > 
> > What about the 5.10.y tree?  Does it need this change as well?
> 
> To answer my own question, yes, it is an issue there too.  I'll go do a
> release right now with the mode changed.

This should now be fixed in the 3 kernel releases that went out
yesterday.  Please let me know if you continue to see this problem.

thanks,

greg k-h
