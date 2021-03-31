Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772F434FBEB
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 10:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhCaIwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 04:52:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbhCaIv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 04:51:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V8mYs1017983;
        Wed, 31 Mar 2021 08:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dnKkt0M7ZM9uOvBvDE5xPvS4fmbMM0b1FB5vY1/3kZ0=;
 b=OonruPuYEq+kIrF2Zn2rMcgXYPotTFyTocUqYcgcvVsBHxwKod6KRa601Vis4NcFFVx1
 qg9xr9twoZXa+xHhKilYbL/jq48T15LhWsjBb8/NEy5HFZOIHfxZmnLQmLkgTqM37JBC
 HevHcXZd7feZX8QcmgrpjcmxKEckgSix9fJvcCplW3zYrPgyB4duthHRRZEq19TuGqLQ
 oaGMrUoofN+VT/zILNhdhQR+cVPVxwwerO7IBn08OaTwrOludiAizLl2/Rg6wce65JQQ
 CRahUH7DpxRh2jnwtZR5NIdqGmTLNRsjPvWHLhPgknd7tN3KlKMblUM1BTFgPL8wepXB pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37mab3hhbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 08:51:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V8nVT4090806;
        Wed, 31 Mar 2021 08:51:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 37mabkxbq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 08:51:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12V8ppcE001235;
        Wed, 31 Mar 2021 08:51:51 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Mar 2021 01:51:50 -0700
Date:   Wed, 31 Mar 2021 11:51:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>
Cc:     hverkuil-cisco@xs4all.nl, syzkaller-bugs@googlegroups.com,
        dvyukov@google.com, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:EM28XX VIDEO4LINUX DRIVER" <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: em28xx: fix memory leak
Message-ID: <20210331085142.GI2065@kadam>
References: <20210324180753.GA410359@LEGION>
 <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310064
X-Proofpoint-ORIG-GUID: rcRGErqPT3_0x9OwQpvA5bhZ0rguoNSA
X-Proofpoint-GUID: rcRGErqPT3_0x9OwQpvA5bhZ0rguoNSA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 31, 2021 at 01:22:01PM +0500, Muhammad Usama Anjum wrote:
> On Wed, 2021-03-24 at 23:07 +0500, Muhammad Usama Anjum wrote:
> > If some error occurs, URB buffers should also be freed. If they aren't
> > freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
> > buffers as dvb is set to NULL. The function in which error occurs should
> > do all the cleanup for the allocations it had done.
> > 
> > Tested the patch with the reproducer provided by syzbot. This patch
> > fixes the memleak.
> > 
> > Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
> > Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> > ---
> > Resending the same path as some email addresses were missing from the
> > earlier email.
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    1a4431a5 Merge tag 'afs-fixes-20210315' of git://git.kerne..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11013a7cd00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ff6b8b2e9d5a1227
> > dashboard link: https://syzkaller.appspot.com/bug?extid=889397c820fa56adf25d
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559ae3ad00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176985c6d00000
> > 
> >  drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > index 526424279637..471bd74667e3 100644
> > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -2010,6 +2010,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  	return result;
> >  
> >  out_free:
> > +	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
> >  	kfree(dvb);
> >  	dev->dvb = NULL;
> >  	goto ret;
> 
> I'd received the following notice and waiting for the review:

Please wait a minimum of two weeks before asking for updates.

regards,
dan carpenter

