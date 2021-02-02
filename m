Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2830CB0E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhBBTLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:11:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51688 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239455AbhBBTGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:06:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112J5pbf165687;
        Tue, 2 Feb 2021 19:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lTXFyLWT518NKXvm0c3fg2WFTQkpwhdndPk47PQMG5c=;
 b=nl/wjwXdpNl342uuaqCmTi9xd2tEOyAM+BWsnbse2PqQAtf9P9KRzOj7qx5vb3no7FTP
 OJpyaNIm3XE6hZNEyksO2IOYM37UQoIc+xMQMmZLYBLyN79LgdnW+Y7cIoS0ikOZkEic
 ZVTXdnXSCLKaxz+6DR+ZjzOtQlsR4VmhbvwNj7UdwTxh1lmWfyC7IjxqnxYig7pa8LlE
 odx1r5ydfrH9pINFJBZs+TKyWDVv5sK0tN/H2UUwC0R3oGi7ckabePRxvyvNCsWTwPWR
 ZQGWWcDWacvAN1h/XbhjXIeLZYmExCKNYai20LnDbpU3wg20sGfZXltbfBS4eGZrF258 mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyavm8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 19:05:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112IGaFb104648;
        Tue, 2 Feb 2021 19:05:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 36dhcx7k20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 19:05:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 112J5kln002703;
        Tue, 2 Feb 2021 19:05:47 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 11:05:46 -0800
Date:   Tue, 2 Feb 2021 22:05:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 24/28] can: dev: prevent potential information leak
 in can_fill_info()
Message-ID: <20210202190539.GE20820@kadam>
References: <20210202132941.180062901@linuxfoundation.org>
 <20210202132942.158736432@linuxfoundation.org>
 <20210202185317.GB6964@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202185317.GB6964@duo.ucw.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020120
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 07:53:17PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > [ Upstream commit b552766c872f5b0d90323b24e4c9e8fa67486dd5 ]
> > 
> > The "bec" struct isn't necessarily always initialized. For example, the
> > mcp251xfd_get_berr_counter() function doesn't initialize anything if the
> > interface is down.
> 
> Well, yes... and = {} does not neccessarily initialize all of the
> structure... for example padding.
> 
> It is really simple
> 
> struct can_berr_counter {
> 	__u16 txerr;
> 	__u16 rxerr;
> };
> 
> but maybe something like alpha uses padding in such case, and memset
> would be better?

I'm pretty sure nothing uses padding in this situation.  If it does then
we need to re-work a bunch of code.

regards,
dan carpenter

