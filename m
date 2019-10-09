Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FEBD1173
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfJIOjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 10:39:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfJIOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 10:39:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99ET4r9103806;
        Wed, 9 Oct 2019 14:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Y+rzZ/MPMEJEoxqM7MiXbauMggc4Ms25TgKhJewfStg=;
 b=cwclw6ihXm3WOexfBJoU3Majil8ooUSZpwpupkQGjaThlEdV2awtBgl9LauvrX1Uknka
 Vm46VhcjUPEHkRHc2qI0jy4enEVS/LQUK4Gbp4dB2tTQbLOx9p6zFAydHNJxzg5375za
 BuTScWZSpBPEZfvRy5qNIpk/V0vIl1oPCviYXS0/gU81stCVrkp+756WuRSkR9gFWIwp
 I9t2pfAVKul7pJ22RGXdk2L4Sc6Seey0MeLXm/LSYR6cmBbl+VEzFi+rugu0vxiJFRXh
 UUIa5uFhP5gZJo5ypdhnxlwqGWUKUr8hjF3jwMBypwQtN8nErt+AQYyZO6gHSFOjcUuV 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vejkun3te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 14:39:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99EWlXb159064;
        Wed, 9 Oct 2019 14:39:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vgefctcrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 14:39:16 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99Ed5MH031000;
        Wed, 9 Oct 2019 14:39:05 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 07:39:04 -0700
Date:   Wed, 9 Oct 2019 17:38:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Message-ID: <20191009143855.GE13286@kadam>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
 <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
 <20191001135649.GH22609@kadam>
 <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
 <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
 <20191001185730.GM29696@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001185730.GM29696@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090140
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 09:58:55PM +0300, Dan Carpenter wrote:
> On Tue, Oct 01, 2019 at 06:13:21PM +0300, Denis Efremov wrote:
> > Just found an official documentation to this issue:
> > https://gcc.gnu.org/gcc-4.9/porting_to.html
> > "Null pointer checks may be optimized away more aggressively
> > ...
> > The pointers passed to memmove (and similar functions in <string.h>) must be non-null
> > even when nbytes==0, so GCC can use that information to remove the check after the
> > memmove call. Calling copy(p, NULL, 0) can therefore deference a null pointer and crash."
> > 
> 
> Correct.  In glibc those functions are annotated as non-NULL.
> 
> extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
>                      size_t __n) __THROW __nonnull ((1, 2));

I was wrong on this.  It's built into GCC so it doesn't matter how it's
annotated.

> 
> We aren't going to do that in the kernel.  A second difference is that
> in the kernel we use -fno-delete-null-pointer-checks so it doesn't
> delete the NULL checks.

But it's true that the kernel has -fno-delete-null-pointer-checks so I
don't think this is worth patching.

regards,
dan carpenter

