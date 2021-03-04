Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BAE32D41F
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCDN1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238063AbhCDN1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B450164F09;
        Thu,  4 Mar 2021 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614864380;
        bh=sVSyGc1qz7boPL1hO2wYonHUdQBiOTrBcWGg6oMkgv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjQewFc1CxyoH1UK7jjKf9dk+6Mg+uAQ0v9aUUM5XzK4oGzGMBWopmSz3FuZuNsrH
         mVjFO2PITYShMpSoF8On9/C73N6ieKbTRnh7QoIBlkpm3wv6PWDYjoFROtD5DvOk1T
         7CJFIlHXgLqdomY5PeaBjpp0q5lpGX6KnMD8kSLI=
Date:   Thu, 4 Mar 2021 14:26:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, pablo@netfilter.org, paulburton@kernel.org
Subject: Re: stable request: mips strncpy is broken
Message-ID: <YEDf+XYB/dl5vx0u@kroah.com>
References: <20210303172336.GF17911@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303172336.GF17911@breakpoint.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 06:23:36PM +0100, Florian Westphal wrote:
> Hello,
> 
> Please consider queueing
> 
> commit 3c0be5849259b729580c23549330973a2dd513a2
> Author: Paul Burton <paulburton@kernel.org>
>  MIPS: Drop 32-bit asm string functions
> 
> The commit is part of 5.5-rc1.
> 
> We got a bug report about following nftables rule not matching
> even if it should on Linux 5.4.y mips32:
> 
>   meta iifname "br-vlan"
> 
> 'iifname' uses strncpy(..., IFNAMSIZ) to copy dev->name to the register.
> The MIPS asm function doesn't zero-pad the remaining bytes, but that is
> needed for the compare op to work reliably.
> 
> The reporter confirmed that this removal fixes the issue, the generic C
> version behaves as expected.
> 
> The patch doesn't apply cleanly to 5.4, there is a minor conflict
> related to FORTIFY macro, but its easily resolved as all code
> is removed.
> 
> I did not try earlier 4.4.y releases but I susepct they should also get
> this patch applied.
> 
> I can send a 5.4.y backport if thats preferred.

Please do, that way I know it is done correctly and has been tested.

And here I thought no one was actually using MIPS anymore :)

thanks,

greg k-h
