Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F421E4521
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgE0OES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:04:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbgE0OES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:04:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RDvb2N196415;
        Wed, 27 May 2020 14:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z8LSjtyRdkQJDOv1CQQhH2cz7RTrtGNgrKwq0zh9eJg=;
 b=F+jm7JYqK+JTri+qgXMbnuD5RBtxa4/C5Oz9C4Yz6EoaSBWJit0+eiOsxQBSSEeO8x9d
 PGgI7su4bw2GT9hSdOWgsqDNCZ6WmypKBLZbxeTxZ9ZLQZ10TzPfu+qNId/0jSVUBDqw
 KOHwQRHqVxvoBGNABhEENWuASChrB/HFeTC35QTaDN4XJPW+0ok4WD6oj4gbEZlEgtf+
 81kVUkrBe29mRQ8iKHqhglk4/FymiaPgcRQpSiI9zpkTvzriJv59Gq9zj0vv6VzHNBSp
 8BRp8CumKkeuvVpYhdl8PNSebv4TFb3OUfmanhTPU9uZ52spA053ITjLhCuE04b8PON8 pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 316u8qymjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 14:03:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RE3ZUx174350;
        Wed, 27 May 2020 14:03:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 317j5rxyj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 14:03:21 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04RE3JDK007580;
        Wed, 27 May 2020 14:03:19 GMT
Received: from [192.168.1.68] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 07:03:18 -0700
Subject: Re: [PATCH 4.4 26/65] sched/fair, cpumask: Export for_each_cpu_wrap()
To:     Greg KH <gregkh@linuxfoundation.org>,
        nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, lvenanci@redhat.com,
        torvalds@linux-foundation.org, efault@gmx.de, riel@redhat.com,
        tglx@linutronix.de, lwang@redhat.com, mingo@kernel.org,
        sashal@kernel.org
References: <20200526183905.988782958@linuxfoundation.org>
 <20200526183915.976645661@linuxfoundation.org>
 <OSBPR01MB29836310986EC6E2E132A02F92B10@OSBPR01MB2983.jpnprd01.prod.outlook.com>
 <20200527080944.GB119903@kroah.com>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <ee459439-7f33-162f-83de-5106d5125e63@oracle.com>
Date:   Wed, 27 May 2020 10:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <20200527080944.GB119903@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=2
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=2
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270106
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/20 4:09 AM, Greg KH wrote:
> On Wed, May 27, 2020 at 07:50:56AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
>>> Subject: [PATCH 4.4 26/65] sched/fair, cpumask: Export for_each_cpu_wrap()	
...
>>
>> This commit also needs the following commits:
>>
>> commit d207af2eab3f8668b95ad02b21930481c42806fd
>> Author: Michael Kelley <mhkelley@outlook.com>
>> Date:   Wed Feb 14 02:54:03 2018 +0000
>>
>>     cpumask: Make for_each_cpu_wrap() available on UP as well
>>     
>>     for_each_cpu_wrap() was originally added in the #else half of a
>>     large "#if NR_CPUS == 1" statement, but was omitted in the #if
>>     half.  This patch adds the missing #if half to prevent compile
>>     errors when NR_CPUS is 1.
>>     
>>     Reported-by: kbuild test robot <fengguang.wu@intel.com>
>>     Signed-off-by: Michael Kelley <mhkelley@outlook.com>
>>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>     Cc: Peter Zijlstra <peterz@infradead.org>
>>     Cc: Thomas Gleixner <tglx@linutronix.de>
>>     Cc: kys@microsoft.com
>>     Cc: martin.petersen@oracle.com
>>     Cc: mikelley@microsoft.com
>>     Fixes: c743f0a5c50f ("sched/fair, cpumask: Export for_each_cpu_wrap()")
>>     Link: http://lkml.kernel.org/r/SN6PR1901MB2045F087F59450507D4FCC17CBF50@SN6PR1901MB2045.namprd19.prod.outlook.com
>>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>
>> Please apply this commit.
> 
> Good catch, now queued up, thanks.

I left this commit out because the 4.4 kernel only uses
cpumask_next_wrap in padata, which is only enabled for SMP kernels, but
it's probably best to be safe.

Daniel
