Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35923B5CB
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390235AbfFJNKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390052AbfFJNKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 09:10:12 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85D920679;
        Mon, 10 Jun 2019 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560172211;
        bh=XjHZp31gFE7ARYByVLbUxEVbPCKvDSu2e3FtszFnNNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7/ysCgJ5RAdWpl1xKc9C2N8wgftk31FSnaiqa+j86MV9TQrz8gKDtcCl9kpFBLJg
         8iPMIH3Fs/eEXTcmwjuEmaqRmM89ke07oEQKNqA4Ikjs28VKFtS2vBJM3Aa8zDSxsQ
         ppoXNRwSVXYAaaLhvyFy8QyO85mdhr1C/gkWnLgs=
Date:   Mon, 10 Jun 2019 16:10:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Message-ID: <20190610131007.GW6369@mtr-leonro.mtl.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
 <20190608081533.GO5261@mtr-leonro.mtl.com>
 <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 01:03:54PM +0000, Marciniszyn, Mike wrote:
> > > diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c
> > b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > > index 6fb9303..d77276d 100644
> > > --- a/drivers/infiniband/hw/hfi1/tid_rdma.c
> > > +++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > > @@ -312,9 +312,8 @@ static struct hfi1_ctxtdata *qp_to_rcd(struct
> > rvt_dev_info *rdi,
> > >  	if (qp->ibqp.qp_num == 0)
> > >  		ctxt = 0;
> > >  	else
> > > -		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
> > > -			(dd->n_krcv_queues - 1)) + 1;
> > > -
> > > +		ctxt = hfi1_get_qp_map(dd,
> > > +				       (u8)(qp->ibqp.qp_num >> dd-
> > >qos_shift));
> >
> > It is one time use functions, why don't you handle this (u8) casting
> > inside of hfi1_get_qp_map()?
> >
>
> I assume the suggestion is to remove the u8 cast at the call site?

Yes, sorry for not being clear.

>
> The function return value already is a u8 and there is a cast of the 64 bit CSR read result.
>
> Mike
