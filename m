Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C23259F4C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 21:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgIATgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 15:36:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgIATgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 15:36:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081JT5oT096223;
        Tue, 1 Sep 2020 19:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eolh/l8OzywtSzarHBKcDokhJyO8s5FophmCXrNKB+c=;
 b=qqYoRXBUS+VOQPoPkO41INo2qP8mjky2SF4R/Rwla+aAQEkMcKaLfPqmp9af/Ykrtn3/
 kFwXC0yGzwnhZC4A20F4qkM+XD7QonIgWWaMnPcshzf0E0iLf1q1PROjL3k1Nkj4uq61
 HhfoRokDpP1bmTH1YhkOjF/URzdy0aVls5bqoI532iCWz8HdrdK27uwsO218V3qgGum2
 7ncxgbov2aRNBcG5XZFr780h0Unbek6iPiW0NN8Eiy//WoeMYg9C+TpZA9ozO6w0RcvI
 Rm1ZnIt+830clBzlS9Q+UnMdKVqurTjUWiZHASCfRayXpNpd7fKKmqYmAE5+ok4hJ9Ez Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eeqxhd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 19:36:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081JYauC142889;
        Tue, 1 Sep 2020 19:36:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x49060-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 19:36:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081JaZrG032164;
        Tue, 1 Sep 2020 19:36:35 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 12:36:34 -0700
Date:   Tue, 1 Sep 2020 22:36:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 124/125] HID: hiddev: Fix slab-out-of-bounds write
 in hiddev_ioctl_usage()
Message-ID: <20200901193628.GF8321@kadam>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150940.687698839@linuxfoundation.org>
 <20200901191209.GB5295@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901191209.GB5295@duo.ucw.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=975 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=966 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010164
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 09:12:09PM +0200, Pavel Machek wrote:
> Hi!
> 
> > commit 25a097f5204675550afb879ee18238ca917cba7a upstream.
> > 
> > `uref->usage_index` is not always being properly checked, causing
> > hiddev_ioctl_usage() to go out of bounds under some cases. Fix it.
> 
> Well, the code is quite confusig, but:
> 
> a) does HIDIOCGCOLLECTIONINDEX need same checking?

It's checked in the previous switch statement.

> 
> b) should we check this using some kind of _nospec() variant to
> prevent speculation attacks?

I don't think so.  I wrote up an explanation earlier just because the
code was so confusing.

https://lkml.org/lkml/2020/7/20/523

regards,
dan carpenter

