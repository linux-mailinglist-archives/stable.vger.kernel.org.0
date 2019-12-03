Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BDE10FD97
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfLCM1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfLCM1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:27:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0A520684;
        Tue,  3 Dec 2019 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575376066;
        bh=3P5USAcp0mKQWvyvt0d9zvEji4+zn7AmEjAHvZ5jy0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DNCO7eScWmDjfnTQrODrhFR5I8C4DXW3CqkpLt56rYTP9+CWC+KQvWUFagjM/Xwq2
         ovJrHhkctL6Jqehif5CNDbNDboPzo+jYbx3gtsfQWzMy/kWQdKCyL077QZBYyiOva5
         jIJmdr4vu8KNOQAr2GAEZmlztbrDaAageBc33Onw=
Date:   Tue, 3 Dec 2019 13:27:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 185/306] net: hns3: bugfix for buffer not free
 problem during resetting
Message-ID: <20191203122744.GB2131225@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203128.798931840@linuxfoundation.org>
 <20191129110010.GA4313@amd>
 <20191129143108.GA3708972@kroah.com>
 <20191129222401.GA29788@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129222401.GA29788@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 11:24:01PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > From: Huazhong Tan <tanhuazhong@huawei.com>
> > > > 
> > > > [ Upstream commit 73b907a083b8a8c1c62cb494bc9fbe6ae086c460 ]
> > > > 
> > > > When hns3_get_ring_config()/hns3_queue_to_ring()/
> > > > hns3_get_vector_ring_chain() failed during resetting, the allocated
> > > > memory has not been freed before these three functions return. So
> > > > this patch adds error handler in these functions to fix it.
> > > 
> > > Correct me if I'm wrong, but... this introduces use-after-free:
> > > Should it do devm_kfree(&pdev->dev, cur_chain); ?
> > 
> > I think Sasha tried to backport a fix for this patch, but that fix broke
> > the build :(
> > 
> > If you want to provide a working backport, I'll be glad to take it.
> 
> Actually it looks like problem originated in mainline, and there was
> more than one problem with this patch.
> 
> cda69d244585bc4497d3bb878c22fe2b6ad647c1 should fix it; it needs to be
> back-ported, too.

Yes, that is the one, can you provide a working backport for this?

thanks,

greg k-h
