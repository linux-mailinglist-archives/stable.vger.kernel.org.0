Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD826693D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 21:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgIKTxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 15:53:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgIKTxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 15:53:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BEdNEG111365;
        Fri, 11 Sep 2020 14:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DWZD12wORp22AFnbuvXtF9cNTFTZ+VmSgJMhUkzu+EI=;
 b=oGzhhCEXnSIt4ZdIqR25mKdqDYLCqeUinls1RO4x1cevclYg0g/rsJcw+91MDfXl6rdF
 U9ONmGbsfSvhkPbYp1uYhRnubSmdt05aieCE8RrQqVCO3sgfJd3SHa3wttMwVqyW/XLZ
 chOf3iNIHWmi6CdVX/MpYHX2ElrjMfHe/R3T95MmyPZIRo7MvgYHSWdPovP/mv4vFJvc
 0syXXTg2PhScD370E9vxNRn5YK16QItpwjkxQKONILdg/NsonnoTtC/8T3ikBRzG8Wam
 123njcBvAvRXo7L2V3K97qSgdh1DYZ6J6PU7YDnfJgiaqCOheE32YJCHeVBckVMarxiJ Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33c23ren2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 14:41:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BEZigZ074065;
        Fri, 11 Sep 2020 14:41:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33dacq25x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 14:41:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BEfoVd002044;
        Fri, 11 Sep 2020 14:41:50 GMT
Received: from [10.74.86.16] (/10.74.86.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 07:41:50 -0700
Subject: Re: [PATCH 1/2] xen/gntdev.c: Mark pages as dirty
To:     Souptick Joarder <jrdr.linux@gmail.com>, jgross@suse.com,
        sstabellini@kernel.org
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, stable@vger.kernel.org
References: <1599375114-32360-1-git-send-email-jrdr.linux@gmail.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <55deef6a-4199-b003-b187-7e7c4d1725ff@oracle.com>
Date:   Fri, 11 Sep 2020 10:41:47 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <1599375114-32360-1-git-send-email-jrdr.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110120
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/6/20 2:51 AM, Souptick Joarder wrote:
> There seems to be a bug in the original code when gntdev_get_page()
> is called with writeable=true then the page needs to be marked dirty
> before being put.
>
> To address this, a bool writeable is added in gnt_dev_copy_batch, set
> it in gntdev_grant_copy_seg() (and drop `writeable` argument to
> gntdev_get_page()) and then, based on batch->writeable, use
> set_page_dirty_lock().
>
> Fixes: a4cdb556cae0 (xen/gntdev: add ioctl for grant copy)
> Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: David Vrabel <david.vrabel@citrix.com>


Cc: stable@vger.kernel.org

(can be added at commit time)

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>



