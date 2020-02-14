Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0046A15E4D0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393709AbgBNQiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:38:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393822AbgBNQiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:38:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EGVRU9177974;
        Fri, 14 Feb 2020 16:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q7LK0zVHD6kckSz3zHVmf2SZkUr5cu8r6SR5IXnD0kA=;
 b=qX70sO0Gr9p+AflLX+hORJrXc7RNqSWSNezzJKw5GgwEj5RP37gxO55L3hCYUbxN0trR
 TOZ7mgOsFqd8x/Tjgt5g6ZEooKuUjt6KuqG10uG8eB2n8Fag9oWiui/mUWqs5Ed6vlx2
 vykicqj+OMKDLqY8Mpo77qzRIr2RL0ubuzmHzSZT5OJkSXvv4u4FJFC/p9Dfae0kfDWv
 o8IwC7UbX/dYIXheOAj14fFyRvFl64t5HmBw6+TNFQrXx9GGkbxlo47W32ldbqNYZ/R2
 kdvmQLRV1pSK09zNxst28Q9JBLHwzG1GLYTmzKFkhzbI4wxU4E3zg+hk+5mpmI3XK4PT EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3t29d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 16:37:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EGbUei097455;
        Fri, 14 Feb 2020 16:37:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k3dasps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 16:37:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01EGbhxs006002;
        Fri, 14 Feb 2020 16:37:43 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Feb 2020 08:37:42 -0800
Date:   Fri, 14 Feb 2020 11:37:58 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 4.19 091/195] padata: Remove broken queue flushing
Message-ID: <20200214163758.455gqh73dhzvbvtv@ca-dmjordan1.us.oracle.com>
References: <20200210122305.731206734@linuxfoundation.org>
 <20200210122314.217904406@linuxfoundation.org>
 <5E4674BB.4020900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E4674BB.4020900@huawei.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140126
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Yang,

On Fri, Feb 14, 2020 at 06:21:47PM +0800, Yang Yingliang wrote:
> On 2020/2/10 20:32, Greg Kroah-Hartman wrote:
> > @@ -501,8 +509,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
> >   	timer_setup(&pd->timer, padata_reorder_timer, 0);
> >   	atomic_set(&pd->seq_nr, -1);
> >   	atomic_set(&pd->reorder_objects, 0);
> > -	atomic_set(&pd->refcnt, 0);
> > -	pd->pinst = pinst;
> This patch remove this assignment, it's cause a null-ptr-deref when using
> pd->pinst in padata_reorder().

Thanks for reporting.  This change is based on an enhancement in mainline that
moved this assignment but isn't in 4.19:

  bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")

A version of _this_ patch (i.e. remove broken queue flushing) has been posted
for 4.14, 4.9, and 4.4, all of which would likely result in the same issue, so
let's hold off on merging those until I can post fixed versions.

I'll start working on the 4.19 fix now.
