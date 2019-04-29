Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F59CEC03
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 23:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfD2VY1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Apr 2019 17:24:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:24871 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbfD2VY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 17:24:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 14:24:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="227854322"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 29 Apr 2019 14:24:25 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 29 Apr 2019 14:24:25 -0700
Received: from fmsmsx108.amr.corp.intel.com ([169.254.9.202]) by
 fmsmsx120.amr.corp.intel.com ([169.254.15.34]) with mapi id 14.03.0415.000;
 Mon, 29 Apr 2019 14:24:25 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 5/5] IB/hfi1: Fix improper uses of
 smp_mb__before_atomic()
Thread-Topic: [PATCH 5/5] IB/hfi1: Fix improper uses of
 smp_mb__before_atomic()
Thread-Index: AQHU/shvAt4TgS2+J0CTgfGUA/O3t6ZTpX9w
Date:   Mon, 29 Apr 2019 21:24:24 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663BE6AADCE@FMSMSX108.amr.corp.intel.com>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
In-Reply-To: <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzIyOGY0ZWMtODc4Yi00ODI5LWE5NDUtMzhjMTEyODZhODYwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaFBWNTRvNnNoQ3JqXC9ZUHVjbjNSWmF4R2duZlJ0eE1CSlNJMU9MU3VNYWFoMjFBaFhVRWdvdVU5RFAzTDh6ak0ifQ==
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

>-----Original Message-----
>From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>owner@vger.kernel.org] On Behalf Of Andrea Parri
>Sent: Monday, April 29, 2019 4:15 PM
>To: linux-kernel@vger.kernel.org
>Cc: Andrea Parri <andrea.parri@amarulasolutions.com>;
>stable@vger.kernel.org; Dalessandro, Dennis
><dennis.dalessandro@intel.com>; Marciniszyn, Mike
><mike.marciniszyn@intel.com>; Doug Ledford <dledford@redhat.com>;
>Jason Gunthorpe <jgg@ziepe.ca>; linux-rdma@vger.kernel.org
>Subject: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
>
>This barrier only applies to the read-modify-write operations; in
>particular, it does not apply to the atomic_read() primitive.
>
>Replace the barrier with an smp_mb().

This is one of a couple of barrier issues that we are currently looking into.

See:

[PATCH for-next 6/9] IB/rdmavt: Add new completion inline

We will take a look at this one as well.

Thanks,

Mike

>Fixes: 856cc4c237add ("IB/hfi1: Add the capability for reserved operations")
>Cc: stable@vger.kernel.org
>Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
>Reported-by: Peter Zijlstra <peterz@infradead.org>
>Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
>Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
>Cc: Doug Ledford <dledford@redhat.com>
>Cc: Jason Gunthorpe <jgg@ziepe.ca>
>Cc: linux-rdma@vger.kernel.org
>---
> drivers/infiniband/sw/rdmavt/qp.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/infiniband/sw/rdmavt/qp.c
>b/drivers/infiniband/sw/rdmavt/qp.c
>index a34b9a2a32b60..b64fd151d31fb 100644
>--- a/drivers/infiniband/sw/rdmavt/qp.c
>+++ b/drivers/infiniband/sw/rdmavt/qp.c
>@@ -1863,11 +1863,11 @@ static inline int rvt_qp_is_avail(
> 	u32 reserved_used;
>
> 	/* see rvt_qp_wqe_unreserve() */
>-	smp_mb__before_atomic();
>+	smp_mb();
> 	reserved_used = atomic_read(&qp->s_reserved_used);
> 	if (unlikely(reserved_op)) {
> 		/* see rvt_qp_wqe_unreserve() */
>-		smp_mb__before_atomic();
>+		smp_mb();
> 		if (reserved_used >= rdi->dparms.reserved_operations)
> 			return -ENOMEM;
> 		return 0;
>@@ -1882,7 +1882,7 @@ static inline int rvt_qp_is_avail(
> 		avail = slast - qp->s_head;
>
> 	/* see rvt_qp_wqe_unreserve() */
>-	smp_mb__before_atomic();
>+	smp_mb();
> 	reserved_used = atomic_read(&qp->s_reserved_used);
> 	avail =  avail - 1 -
> 		(rdi->dparms.reserved_operations - reserved_used);
>--
>2.7.4

