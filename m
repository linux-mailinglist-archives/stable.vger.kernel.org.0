Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40128476B6C
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 09:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhLPIHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 03:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhLPIHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 03:07:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E80C061574;
        Thu, 16 Dec 2021 00:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A71AB822EF;
        Thu, 16 Dec 2021 08:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52138C36AE2;
        Thu, 16 Dec 2021 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639642035;
        bh=ktW4CxekXVBK60XAx0vZ0um76vO60wIymFUHN2OyOZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQb0f5NrNHeiiRkDrbkfGcYgnPKrUSirXb90Nd/veQZD2YsP4UKrij3THXHWoBJc0
         MOwAbtts66FBU1fQODv2byb5FkmubW9Jpqns9z7oqhT4lKlyK3sZqC6uBP0oeE6QxZ
         fCyBQ9EFXxWFLIlh5chjANk+s1W2DAUDoO8RObbY=
Date:   Thu, 16 Dec 2021 09:07:13 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: LTS "Warning: file conntrack_vrf.sh is not executable, correct
 this."
Message-ID: <YbrzsZf/arqfZ3DT@kroah.com>
References: <234d7a6a81664610fdf21ac72730f8bd10d3f46f.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <234d7a6a81664610fdf21ac72730f8bd10d3f46f.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 08:00:30AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg,
> 
> Incorrect 0644 in LTS for new selftest file, seen in 5.4.165 since
> "selftests: netfilter: add a vrf+conntrack testcase" was added to LTS.
> It's correct 755 in upstream, but somehow messed up in LTS :-(

That is because quilt/git can not set modes of files.

> linux-5.4.y
> ===========
> commit 8d3563ecbca3526fcc6639065c9fb11b2f234706
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Oct 18 14:38:13 2021 +0200
> 
>     selftests: netfilter: add a vrf+conntrack testcase
>     
>     commit 33b8aad21ac175eba9577a73eb62b0aa141c241c upstream.
> 
> [...]    
> diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
> new file mode 100644           <----------------
> 
> 
> linux-5.15.y
> ============
> commit cffab968e94e513bdcef25e11402243ce2919803
> [...]
> new file mode 100644           <----------------
> 
> 
> upstream
> ========
> $ git show 33b8aad21ac175eba9577a73eb62b0aa141c241c
> 
> commit 33b8aad21ac175eba9577a73eb62b0aa141c241c
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Oct 18 14:38:13 2021 +0200
> 
>     selftests: netfilter: add a vrf+conntrack testcase
>     
> [...]
> diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
> new file mode 100755          <-----------------------
> 
> 
> -Tommi
> 

What about the 5.10.y tree?  Does it need this change as well?

thanks,

greg k-h
