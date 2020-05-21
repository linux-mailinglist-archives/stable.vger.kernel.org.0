Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA51DCE0D
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgEUNcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 09:32:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36370 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgEUNcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 09:32:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LDRKP6170852;
        Thu, 21 May 2020 13:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GjO090cWDER39JcJyP9Sclz0pjBt+/gcXOCebGP4+78=;
 b=sHEHaPj5llNQrgSNHrEf7GW/SGrLZ5x9Yx415lk3x/zKGvuOYtE9uMzFIDB23wQegMHR
 vP/vLCJws66shbrPpIkCA7Q723+3jevq+xOHH+9XlkGMXULEYlivKYW57y4OscEhORgS
 s2CupOdfxWgW2eq3QMNZS5TB2FAgQM9IzYjq/9TaqrDeCVVKLNZSxlxfV1eJNuq7Fel8
 rfK19ZNg3TnFn/sW5dHLkDLQMC9ZvRKf1n4dUtj11zMWFqwNpzlttDM2RYFT9Ob6Lr/v
 QkSBBBItL3HIJ6FL0NA3vCem7pKrSFAKhlahcVCQ7x8UtUZf6EPi7xZFwjjSqMvCFBFS Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krghcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 13:31:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LDSfgp045941;
        Thu, 21 May 2020 13:31:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj5k5x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 13:31:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LDVaD7027451;
        Thu, 21 May 2020 13:31:38 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 06:31:36 -0700
Date:   Thu, 21 May 2020 09:32:00 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Backporting "padata: Remove broken queue flushing"
Message-ID: <20200521133200.xposxym3x3zylfd7@ca-dmjordan1.us.oracle.com>
References: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
 <20200519200018.5vuyuxmjy5ypgi3w@ca-dmjordan1.us.oracle.com>
 <87267d7217e4a3d58440079c16d313e411eab004.camel@decadent.org.uk>
 <20200521080046.GA2615557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521080046.GA2615557@kroah.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=940
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=965 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 10:00:46AM +0200, Greg Kroah-Hartman wrote:
> but these:
> 
> > [3.16-4.19] 6fc4dbcf0276 padata: Replace delayed timer with immediate workqueue in padata_reorder
> > [3.16-4.19] ec9c7d19336e padata: initialize pd->cpu with effective cpumask
> > [3.16-4.19] 065cf577135a padata: purge get_cpu and reorder_via_wq from padata_do_serial
> 
> Need some non-trivial backporting.  Can you, or someone else do it so I
> can queue them up?  I don't have the free time at the moment, sorry.

Sure, I'll do these three.

Daniel
