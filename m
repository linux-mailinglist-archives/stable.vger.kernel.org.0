Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C02598FB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgIAQfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730758AbgIAQe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 12:34:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA5E2065F;
        Tue,  1 Sep 2020 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598978095;
        bh=HBkRRvQE+GiQk8IOw0FoaBIHoluBbUBv6L4fFWhsE5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/iEuxCO+KfmZi287JoZ65Tq12nYlzvVrD+ML3ClX0nNGPTK2N2lPuulBIkC9QUl/
         8rBiVmFR7U3ypc52pchwlRwqrwzLOUdwfvGIFFl1E7tbGDO8whMdDje1Zheb5V1Qpm
         2NqKXJIiQXGMoOp5C+4Zd6y6OxtYfiJmivTRVmiM=
Date:   Tue, 1 Sep 2020 18:35:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 016/125] media: pci: ttpci: av7110: fix possible
 buffer overflow caused by bad DMA value in debiirq()
Message-ID: <20200901163523.GA1458104@kroah.com>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150935.368387062@linuxfoundation.org>
 <20200901162512.GA30837@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901162512.GA30837@gofer.mess.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 05:25:12PM +0100, Sean Young wrote:
> Greg,
> 
> On Tue, Sep 01, 2020 at 05:09:31PM +0200, Greg Kroah-Hartman wrote:
> > From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
> > 
> > [ Upstream commit 6499a0db9b0f1e903d52f8244eacc1d4be00eea2 ]
> > 
> > The value av7110->debi_virt is stored in DMA memory, and it is assigned
> > to data, and thus data[0] can be modified at any time by malicious
> > hardware. In this case, "if (data[0] < 2)" can be passed, but then
> > data[0] can be changed into a large number, which may cause buffer
> > overflow when the code "av7110->ci_slot[data[0]]" is used.
> > 
> > To fix this possible bug, data[0] is assigned to a local variable, which
> > replaces the use of data[0].
> 
> See the discussion here:
> 
> https://lkml.org/lkml/2020/8/31/479
> 
> It does not seem worthwhile merging to the stable trees.

It doesn't hurt either :)

thanks,

greg k-h
