Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078CC161FE2
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 05:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBREsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 23:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgBREsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 23:48:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687CA20722;
        Tue, 18 Feb 2020 04:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582001282;
        bh=IBqutbhtZToy71xdjspXrNCtyphaRbou9lIOOc3XX5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuzdEIMOKt1UMm3T4IoAJZOo0GRUP/lrLMmXo7+TdBbIeDlVEbgOj7d3ujk6RpEkJ
         VAG7Kc0hDqDHgdknrIH8HFWRU4DQ9fjLh2UXOzuxgERWczdfZa2J6qT880U/xVRckE
         Spoc5SAG+XGAanDmPHWIHaHL/Uxq7w9rEBR29Yiw=
Date:   Tue, 18 Feb 2020 05:48:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 4.14] padata: Remove broken queue flushing
Message-ID: <20200218044800.GA2048254@kroah.com>
References: <20200213151948.275124464@linuxfoundation.org>
 <20200214194651.442848-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214194651.442848-1-daniel.m.jordan@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 02:46:51PM -0500, Daniel Jordan wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> [ Upstream commit 07928d9bfc81640bab36f5190e8725894d93b659 ]
> 
> The function padata_flush_queues is fundamentally broken because
> it cannot force padata users to complete the request that is
> underway.  IOW padata has to passively wait for the completion
> of any outstanding work.
> 
> As it stands flushing is used in two places.  Its use in padata_stop
> is simply unnecessary because nothing depends on the queues to
> be flushed afterwards.
> 
> The other use in padata_replace is more substantial as we depend
> on it to free the old pd structure.  This patch instead uses the
> pd->refcnt to dynamically free the pd structure once all requests
> are complete.
> 
> Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> [dj: leave "pd->pinst = pinst" assignment in padata_alloc_pd()]
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Thanks, all 3 backports now queued up.

greg k-h
