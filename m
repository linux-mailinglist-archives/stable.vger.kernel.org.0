Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E51389F68
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhETIGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:06:02 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:34092 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhETIGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 04:06:02 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 14K84AxD017204; Thu, 20 May 2021 17:04:10 +0900
X-Iguazu-Qid: 2wGqimLSomUC8jraHi
X-Iguazu-QSIG: v=2; s=0; t=1621497850; q=2wGqimLSomUC8jraHi; m=yiJB+VldlNNmh0zuATGeRcy5kRgIebjrnRpfj8E++sY=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 14K8454q010202
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 17:04:08 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id F0FB61000F9;
        Thu, 20 May 2021 17:04:04 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 14K844bV023050;
        Thu, 20 May 2021 17:04:04 +0900
Date:   Thu, 20 May 2021 17:04:03 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg KH <greg@kroah.com>
Cc:     Pavel Machek <pavel@denx.de>, wens@csie.org,
        stable@vger.kernel.org, mark.tomlinson@alliedtelesis.co.nz,
        pablo@netfilter.org
Subject: Re: [PATCH 4.4] netfilter: x_tables: Use correct memory barriers.
X-TSB-HOP: ON
Message-ID: <20210520080403.w546dfihecpkvsh6@toshiba.co.jp>
References: <20210509082436.GA25504@amd>
 <YJjmJvw/urUncdcd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJjmJvw/urUncdcd@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, May 10, 2021 at 09:52:06AM +0200, Greg KH wrote:
> On Sun, May 09, 2021 at 10:24:36AM +0200, Pavel Machek wrote:
> > 
> > From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
> > 
> > commit 175e476b8cdf2a4de7432583b49c871345e4f8a1 upstream.
> > 
> > When a new table value was assigned, it was followed by a write memory
> > barrier. This ensured that all writes before this point would complete
> > before any writes after this point. However, to determine whether the
> > rules are unused, the sequence counter is read. To ensure that all
> > writes have been done before these reads, a full memory barrier is
> > needed, not just a write memory barrier. The same argument applies when
> > incrementing the counter, before the rules are read.
> > 
> > Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
> > reported in cc00bcaa5899 (which is still present), while still
> > maintaining the same speed of replacing tables.
> > 
> > The smb_mb() barriers potentially slow the packet path, however testing
> > has shown no measurable change in performance on a 4-core MIPS64
> > platform.
> > 
> > Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> > Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > [Ported to stable, affected barrier is added by d3d40f237480abf3268956daf18cdc56edd32834 in mainline]
> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > ---
> >  include/linux/netfilter/x_tables.h | 2 +-
> >  net/netfilter/x_tables.c           | 3 +++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> What about 4.14 and 4.9?  I can't take patches only for 4.4 that are not
> also in newer releases.

I have confirmed that this patch can be applied to 4.9 and 4.14.
Do I need resend this patch again?

> 
> thanks,
> 
> greg k-h
> 

Best regards,
  Nobuhiro
