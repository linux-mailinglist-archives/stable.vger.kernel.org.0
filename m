Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD1612CDE
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfECLsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 07:48:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:42134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727394AbfECLsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 07:48:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4698FAD7B;
        Fri,  3 May 2019 11:48:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EDC08E0117; Fri,  3 May 2019 13:48:17 +0200 (CEST)
Date:   Fri, 3 May 2019 13:48:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 5.0 25/89] RDMA/ucontext: Fix regression with disassociate
Message-ID: <20190503114817.GB15275@unicorn.suse.cz>
References: <20190430113609.741196396@linuxfoundation.org>
 <20190430113611.189238783@linuxfoundation.org>
 <20190503114716.GA15275@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503114716.GA15275@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 01:47:16PM +0200, Michal Kubecek wrote:
> On Tue, Apr 30, 2019 at 01:38:16PM +0200, Greg Kroah-Hartman wrote:
> > From: Jason Gunthorpe <jgg@mellanox.com>
> > 
> > commit 67f269b37f9b4d52c5e7f97acea26c0852e9b8a1 upstream.
> > 
> > When this code was consolidated the intention was that the VMA would
> > become backed by anonymous zero pages after the zap_vma_pte - however this
> > very subtly relied on setting the vm_ops = NULL and clearing the VM_SHARED
> > bits to transform the VMA into an anonymous VMA. Since the vm_ops was
> > removed this broke.
> > 
> > Now userspace gets a SIGBUS if it touches the vma after disassociation.
> > 
> > Instead of converting the VMA to anonymous provide a fault handler that
> > puts a zero'd page into the VMA when user-space touches it after
> > disassociation.
> > 
> > Cc: stable@vger.kernel.org
> > Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
> > Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> 
> This commit breaks build on s390 and mips, please pick also commit
> 6a5c5d26c4c6 ("rdma: fix build errors on s390 and MIPS due to bad
> ZERO_PAGE use").

Oops, it's already there as 71/89, I managed to overlook it. Sorry for
the noise.

Michal Kubecek
