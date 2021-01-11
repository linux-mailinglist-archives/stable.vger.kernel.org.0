Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357F52F2033
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391404AbhAKT65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbhAKT65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9B522B51;
        Mon, 11 Jan 2021 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610395096;
        bh=tNemm3d00HEoWxEcgrioF9dHm3Egmglo6jR1U8qw9Vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GDs8td86YmFvCFTx0riW4WaZBPn/hOl0rpr6C671fpnz07LDmqXtL/XAYjgAAaBMh
         d7xV2cecnYL3iww4o5n13Fbv2Mkqryf6cqGjiwHC3LdmTKuR1HsgVVrtA09axwUo6z
         SzkfdUZWerYeFS8fBrf9QJvBBMNAT77R0muYvTJc=
Date:   Mon, 11 Jan 2021 20:59:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH 5.10 018/145] net: dcb: Validate netlink message in DCB
 handler
Message-ID: <X/yuH4+l0IJ8bFDh@kroah.com>
References: <20210111130048.499958175@linuxfoundation.org>
 <20210111130049.387370344@linuxfoundation.org>
 <20210111093616.552f84da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111093616.552f84da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 09:36:16AM -0800, Jakub Kicinski wrote:
> On Mon, 11 Jan 2021 14:00:42 +0100 Greg Kroah-Hartman wrote:
> > From: Petr Machata <me@pmachata.org>
> > 
> > [ Upstream commit 826f328e2b7e8854dd42ea44e6519cd75018e7b1 ]
> > 
> > DCB uses the same handler function for both RTM_GETDCB and RTM_SETDCB
> > messages. dcb_doit() bounces RTM_SETDCB mesasges if the user does not have
> > the CAP_NET_ADMIN capability.
> > 
> > However, the operation to be performed is not decided from the DCB message
> > type, but from the DCB command. Thus DCB_CMD_*_GET commands are used for
> > reading DCB objects, the corresponding SET and DEL commands are used for
> > manipulation.
> > 
> > The assumption is that set-like commands will be sent via an RTM_SETDCB
> > message, and get-like ones via RTM_GETDCB. However, this assumption is not
> > enforced.
> > 
> > It is therefore possible to manipulate DCB objects without CAP_NET_ADMIN
> > capability by sending the corresponding command in an RTM_GETDCB message.
> > That is a bug. Fix it by validating the type of the request message against
> > the type used for the response.
> > 
> > Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
> > Signed-off-by: Petr Machata <me@pmachata.org>
> > Link: https://lore.kernel.org/r/a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Unfortunately we need to call backsies on this one.
> 
> A fix up was just posted:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org/
> 
> I'll resend both in the next submission.

No worries, thanks for letting me know, I've now dropped it from all
stable tree queues.

thanks,

greg k-h
