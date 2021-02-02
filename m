Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7680130CC5A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbhBBTxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:53:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33274 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240123AbhBBTwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:52:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112JnXCQ062055;
        Tue, 2 Feb 2021 19:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hUD94XtAq9TQ5xmSNjjuDRv6Kc5OZGNoLG59OnZOa6Y=;
 b=tqsFOad/Em2voW8/al72tuFLvDoEzcuWf3+Ycnyx8MoXMk4Rv1D+P17dfPk+1bdWPwHJ
 hVYzKIbRWmNBe8ik4zmgZvR08umhFx4T3h4hyyTxJlq+CHXR3cLdhrXvdusMkERGZzSM
 Fbwse9fniaMQI45poQwa55AXpHsj0M/Mor0v2loR/Dm0yOVhSQHQdn9I43P47sp5ZpNp
 HPNlWFfK8/nRWpj9ifR9QwKfktWVIM6kY4OvamRsvOOqXk8T3NMoH6otT1IcXmLCYDHp
 0K8xYvVTP1ETx5G20YKqqq+mjo+uyfq4CLjEipWCQgPtwcsDynHZ0DgYxdW9AWnk8TRo 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyavtc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 19:51:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112JnUXF054853;
        Tue, 2 Feb 2021 19:51:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 36dh1pk2v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 19:51:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 112Jp8AZ012011;
        Tue, 2 Feb 2021 19:51:08 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 11:51:08 -0800
Date:   Tue, 2 Feb 2021 22:51:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 24/28] can: dev: prevent potential information leak
 in can_fill_info()
Message-ID: <20210202195101.GF20820@kadam>
References: <20210202132941.180062901@linuxfoundation.org>
 <20210202132942.158736432@linuxfoundation.org>
 <20210202185317.GB6964@duo.ucw.cz>
 <20210202190539.GE20820@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202190539.GE20820@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 10:05:39PM +0300, Dan Carpenter wrote:
> On Tue, Feb 02, 2021 at 07:53:17PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > [ Upstream commit b552766c872f5b0d90323b24e4c9e8fa67486dd5 ]
> > > 
> > > The "bec" struct isn't necessarily always initialized. For example, the
> > > mcp251xfd_get_berr_counter() function doesn't initialize anything if the
> > > interface is down.
> > 
> > Well, yes... and = {} does not neccessarily initialize all of the
> > structure... for example padding.
> > 
> > It is really simple
> > 
> > struct can_berr_counter {
> > 	__u16 txerr;
> > 	__u16 rxerr;
> > };
> > 
> > but maybe something like alpha uses padding in such case, and memset
> > would be better?
> 
> I'm pretty sure nothing uses padding in this situation.  If it does then
> we need to re-work a bunch of code.

Not necessarily related but in theory a "= {};" assignment is a GCC
extension and it is supposed to zero out struct holes.  If the code
does "= {0};" then that's standard C, and will not necessarily fill
struct holes but I think GCC tries to.  The other complication is that
some GCC versions have bugs related to this?  We had a long thread about
this last August.

https://lore.kernel.org/lkml/20200801144030.GM24045@ziepe.ca/

Anyway, this code has no holes so it's not affected.

regards,
dan carpenter

