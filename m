Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90771A74F6
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 09:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406765AbgDNHjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 03:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406729AbgDNHjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 03:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB56120575;
        Tue, 14 Apr 2020 07:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586849984;
        bh=edxQpEFkBSzkFVtvya0lPsDxwYwBrW2CbC6KjSBuEsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iNjCDYtZ8DdCwmEp4Ck3M8nYgvdW85PFQQuvaPwItUwhJGktTWB8vSrLIPQz1X034
         3wJ5tJN0KzmtXdCUJLNTS1sKt5UlHy+Qr+xN9heYpeBNVf/mMRgzRkUZ5kBR4RRtKV
         azHWi8Roh6E2kRAGASx2RAv4aEPP1tc7Nm3cp2Kc=
Date:   Tue, 14 Apr 2020 09:39:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     valex@mellanox.com, jgg@mellanox.com, lariel@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] IB/mlx5: Replace tunnel mpls capability
 bits for" failed to apply to 4.19-stable tree
Message-ID: <20200414073942.GD4111599@kroah.com>
References: <1586509303211183@kroah.com>
 <20200414022659.GB1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414022659.GB1068@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 10:26:59PM -0400, Sasha Levin wrote:
> On Fri, Apr 10, 2020 at 11:01:43AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 41e684ef3f37ce6e5eac3fb5b9c7c1853f4b0447 Mon Sep 17 00:00:00 2001
> > From: Alex Vesker <valex@mellanox.com>
> > Date: Thu, 5 Mar 2020 14:38:41 +0200
> > Subject: [PATCH] IB/mlx5: Replace tunnel mpls capability bits for
> > tunnel_offloads
> > 
> > Until now the flex parser capability was used in ib_query_device() to
> > indicate tunnel_offloads_caps support for mpls_over_gre/mpls_over_udp.
> > 
> > Newer devices and firmware will have configurations with the flexparser
> > but without mpls support.
> > 
> > Testing for the flex parser capability was a mistake, the tunnel_stateless
> > capability was intended for detecting mpls and was introduced at the same
> > time as the flex parser capability.
> > 
> > Otherwise userspace will be incorrectly informed that a future device
> > supports MPLS when it does not.
> > 
> > Link: https://lore.kernel.org/r/20200305123841.196086-1-leon@kernel.org
> > Cc: <stable@vger.kernel.org> # 4.17
> > Fixes: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads")
> > Signed-off-by: Alex Vesker <valex@mellanox.com>
> > Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> The conflict was around the cqe_checksum_full cap bit being exposed by
> db849faa9bef ("net/mlx5e: Rx, Fix checksum calculation for new
> hardware").
> 
> I've resolved it by exposing cqe_checksum_full, but *not* taking
> db849faa9bef.

Thanks for doing this!

greg k-h
