Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905C09FD4B
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 10:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfH1IjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 04:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfH1IjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 04:39:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B43323406;
        Wed, 28 Aug 2019 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566981540;
        bh=0ffmz7FFW2huWYfsKiqzTNrryZpRPQYxnFUQLbrkrcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uccBKCbRVdbzV748hw2muZ5udOqnSrUbKqq38pOzm/F9FLxrFGdTZ+x8IyLdWvWke
         t46SPGGjg2StAcBguL/Bf/maNgXd4FSjAdzGpQJ+CdxF5p0RVLVLTtEsR/Nq16rB0D
         OeDKDCgMW0rsLTiPBi+SWNSceaxKguv/MqOjHh3g=
Date:   Wed, 28 Aug 2019 10:38:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 10/13] siphash: implement HalfSipHash1-3 for hash
 tables
Message-ID: <20190828083857.GA29927@kroah.com>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
 <20190827231100.GJ11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827231100.GJ11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 12:11:00AM +0100, Ben Hutchings wrote:
> From: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> commit 1ae2324f732c9c4e2fa4ebd885fa1001b70d52e1 upstream.
> 
> HalfSipHash, or hsiphash, is a shortened version of SipHash, which
> generates 32-bit outputs using a weaker 64-bit key. It has *much* lower
> security margins, and shouldn't be used for anything too sensitive, but
> it could be used as a hashtable key function replacement, if the output
> is never exposed, and if the security requirement is not too high.
> 
> The goal is to make this something that performance-critical jhash users
> would be willing to use.
> 
> On 64-bit machines, HalfSipHash1-3 is slower than SipHash1-3, so we alias
> SipHash1-3 to HalfSipHash1-3 on those systems.
> 
> 64-bit x86_64:
> [    0.509409] test_siphash:     SipHash2-4 cycles: 4049181
> [    0.510650] test_siphash:     SipHash1-3 cycles: 2512884
> [    0.512205] test_siphash: HalfSipHash1-3 cycles: 3429920
> [    0.512904] test_siphash:    JenkinsHash cycles:  978267
> So, we map hsiphash() -> SipHash1-3
> 
> 32-bit x86:
> [    0.509868] test_siphash:     SipHash2-4 cycles: 14812892
> [    0.513601] test_siphash:     SipHash1-3 cycles:  9510710
> [    0.515263] test_siphash: HalfSipHash1-3 cycles:  3856157
> [    0.515952] test_siphash:    JenkinsHash cycles:  1148567
> So, we map hsiphash() -> HalfSipHash1-3
> 
> hsiphash() is roughly 3 times slower than jhash(), but comes with a
> considerable security improvement.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [bwh: Backported to 4.4 to avoid regression for WireGuard with only half
>  the siphash API present]
> Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
> ---
>  Documentation/siphash.txt |  75 +++++++++
>  include/linux/siphash.h   |  57 ++++++-
>  lib/siphash.c             | 321 +++++++++++++++++++++++++++++++++++++-
>  lib/test_siphash.c        |  98 +++++++++++-
>  4 files changed, 546 insertions(+), 5 deletions(-)

Thank you for this patch, and this series, it was on my long-term todo
list that I had not gotten to yet (and probably never would have...)

greg k-h
