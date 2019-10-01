Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE81AC4098
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfJATAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 15:00:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfJATAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 15:00:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91IxYHo170955;
        Tue, 1 Oct 2019 18:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HUjdfKmYAiVYdwx/VKsfp7MDujfbx9y3CuLubHKJmJQ=;
 b=OrmAYS24/I71CUnEQyZTUymcuiWq3LRWiTUg8n1+xpq6/U3nn9Nj4GocSxAnQMyUDQ6D
 dVUMnqhzj9BpFlEoKrm7Q9JWe6SlBVCPOKeSeXXlrZ399R+A7mLrS/tWA2rCp+QjnNa2
 TadeQG8HXt7813ftQ/1ijYxH9XH87l6KkA7kUYw7u35I/9i5+kxdeCTOOejmbUAxTQdI
 3UniJbFJMOLfy2sw3uQ7mrnTqaBRg+opbB30KCJDJhFfYSkRQLLvYr1o2CJx5IJSjJ/g
 6ch4FC0CY/h5kDj+KHdjqhPVqLVTeUD0bM6ibsT/uSWBfDpaxNltJk1JnyDoJEkajDYA +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05rr5k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 18:59:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91IxSHw114015;
        Tue, 1 Oct 2019 18:59:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vbsm2g30p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 18:59:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91IxCMH006633;
        Tue, 1 Oct 2019 18:59:13 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 11:59:12 -0700
Date:   Tue, 1 Oct 2019 21:58:55 +0300
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
Message-ID: <20191001185730.GM29696@kadam>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
 <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
 <20191001135649.GH22609@kadam>
 <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
 <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 06:13:21PM +0300, Denis Efremov wrote:
> Just found an official documentation to this issue:
> https://gcc.gnu.org/gcc-4.9/porting_to.html
> "Null pointer checks may be optimized away more aggressively
> ...
> The pointers passed to memmove (and similar functions in <string.h>) must be non-null
> even when nbytes==0, so GCC can use that information to remove the check after the
> memmove call. Calling copy(p, NULL, 0) can therefore deference a null pointer and crash."
> 

Correct.  In glibc those functions are annotated as non-NULL.

extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
                     size_t __n) __THROW __nonnull ((1, 2));

We aren't going to do that in the kernel.  A second difference is that
in the kernel we use -fno-delete-null-pointer-checks so it doesn't
delete the NULL checks.

regards,
dan carpenter

