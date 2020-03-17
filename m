Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E5D187D7C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 10:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgCQJzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 05:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgCQJzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 05:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C680820663;
        Tue, 17 Mar 2020 09:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584438947;
        bh=mWvAhJ+7nf9Y1RWYBs8qomsP+jEjQk7vHEzNrcTd+z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ch2K/9vsI6tp70aVOo1mm2V4zXGZjDVv4hMtK8XYDN6u37TLIsW+1uvZZqggJCUIS
         eu3ULXei+MUSFEttZRZSyTCl5Zw2ecLc/b5ni8/NtBqfvbBSHbRLO4MUa7Ti6FnZtd
         Hlsy5n0kW41OwS9/O7EnwEY6tXLl6sNjBszBYfHg=
Date:   Tue, 17 Mar 2020 10:55:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org, Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH 4.19 1/1] batman-adv: Avoid free/alloc race when handling
 OGM2 buffer
Message-ID: <20200317095544.GA1068955@kroah.com>
References: <20200316225115.32530-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225115.32530-1-sven@narfation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 11:51:15PM +0100, Sven Eckelmann wrote:
> commit a8d23cbbf6c9f515ed678204ad2962be7c336344 upstream.
> 
> A B.A.T.M.A.N. V virtual interface has an OGM2 packet buffer which is
> initialized using data from the netdevice notifier and other rtnetlink
> related hooks. It is sent regularly via various slave interfaces of the
> batadv virtual interface and in this process also modified (realloced) to
> integrate additional state information via TVLV containers.
> 
> It must be avoided that the worker item is executed without a common lock
> with the netdevice notifier/rtnetlink helpers. Otherwise it can either
> happen that half modified data is sent out or the functions modifying the
> OGM2 buffer try to access already freed memory regions.
> 
> Fixes: 0da0035942d4 ("batman-adv: OGMv2 - add basic infrastructure")
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> ---
>  net/batman-adv/bat_v_ogm.c | 42 ++++++++++++++++++++++++++++++--------
>  net/batman-adv/types.h     |  4 ++++
>  2 files changed, 38 insertions(+), 8 deletions(-)

Now applied, thanks!

greg k-h
