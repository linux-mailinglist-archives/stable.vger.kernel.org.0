Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0404C3B5B3
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389952AbfFJND5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Jun 2019 09:03:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:12749 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389045AbfFJND4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 09:03:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 06:03:56 -0700
X-ExtLoop1: 1
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 10 Jun 2019 06:03:56 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 10 Jun 2019 06:03:56 -0700
Received: from fmsmsx120.amr.corp.intel.com ([169.254.15.191]) by
 FMSMSX157.amr.corp.intel.com ([169.254.14.229]) with mapi id 14.03.0415.000;
 Mon, 10 Jun 2019 06:03:55 -0700
From:   "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>
Subject: RE: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Thread-Topic: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Thread-Index: AQHVHSwkXmtY1awy9UKwGIUn0lnqQKaR36+AgAL9GBA=
Date:   Mon, 10 Jun 2019 13:03:54 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
 <20190608081533.GO5261@mtr-leonro.mtl.com>
In-Reply-To: <20190608081533.GO5261@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzc4NmFjMDEtYjNhZC00ZjQ3LWFhMjUtMzY3OWFkMTg1YjljIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidlVmKzd6RmdrN3J4aVVaMzBwWEpwUWdVZ0VVZlJ0ankyeGV5c1Z3MSt1dkN3NmtkdkdBUDBBc2JkMkVpMXdSKyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c
> b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > index 6fb9303..d77276d 100644
> > --- a/drivers/infiniband/hw/hfi1/tid_rdma.c
> > +++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > @@ -312,9 +312,8 @@ static struct hfi1_ctxtdata *qp_to_rcd(struct
> rvt_dev_info *rdi,
> >  	if (qp->ibqp.qp_num == 0)
> >  		ctxt = 0;
> >  	else
> > -		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
> > -			(dd->n_krcv_queues - 1)) + 1;
> > -
> > +		ctxt = hfi1_get_qp_map(dd,
> > +				       (u8)(qp->ibqp.qp_num >> dd-
> >qos_shift));
> 
> It is one time use functions, why don't you handle this (u8) casting
> inside of hfi1_get_qp_map()?
> 

I assume the suggestion is to remove the u8 cast at the call site?

The function return value already is a u8 and there is a cast of the 64 bit CSR read result.

Mike
