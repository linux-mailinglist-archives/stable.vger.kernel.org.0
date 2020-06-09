Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292921F423C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgFIR3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgFIR3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:29:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B14207C3;
        Tue,  9 Jun 2020 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591723749;
        bh=Vw7yRGT39B0nrm3Jr3B5wmFDo3UBhr8bk7LpQ9RmVwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gKNYsE1ETyhhLm+V9K+UZUA2DdVI+16HFdpHxv6wUUD28rWZGglbVC21mKO9TYYdM
         jT0Pmh6RXf34S0gpMlidvuMWbBiv8tuAupogU7TXTh+DNxBmsEC8pQwSFdK2N+WVGA
         8iOrbsycssx0awpNwIGWaYgVXcy4Ze32MwSrtgFU=
Date:   Tue, 9 Jun 2020 19:29:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: Possible linux-stable mis-backport in ethernet/mellanox/mlx5
Message-ID: <20200609172907.GA873279@kroah.com>
References: <20200607203425.GD23662@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607203425.GD23662@windriver.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 07, 2020 at 04:34:25PM -0400, Paul Gortmaker wrote:
> I happened to notice this commit:
> 
> 9ca415399dae - "net/mlx5: Annotate mutex destroy for root ns"
> 
> ...was backported to 4.19 and 5.4 and v5.6 in linux-stable.
> 
> It patches del_sw_root_ns() - which only exists after v5.7-rc7 from:
> 
> 6eb7a268a99b - "net/mlx5: Don't maintain a case of del_sw_func being
> null"
> 
> which creates the one line del_sw_root_ns stub function around
> kfree(node) by breaking it out of tree_put_node().
> 
> In the absense of del_sw_root_ns - the backport finds an identical one
> line kfree stub fcn - named del_sw_prio from this earlier commit:
> 
> 139ed6c6c46a - "net/mlx5: Fix steering memory leak"  [in v4.15-rc5]
> 
> and then puts the mutex_destroy() into that (wrong) function, instead of
> putting it into tree_put_node where the root ns case used to be handled.

Ugh, good catch.  I'll go revert this from everywhere.  If you could,
can you provide a working backport?

thanks,

greg k-h
