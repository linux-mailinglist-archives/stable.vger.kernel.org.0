Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3641168AA1
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 01:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgBVAA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 19:00:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBVAA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 19:00:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01M00Vfk122309;
        Sat, 22 Feb 2020 00:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EWJFhG6yhtm3ul3h7WoSZAkEKq6UjIeEomHo8PWThow=;
 b=KPQE/C9esyf64uM6XExvFniOurRwQ4sK/tyKdJRr2W6jcDL2NAtcHqTmJxu84c0z95SL
 Ezdjvhg3Hfmyo0IK55dFbfPyIPiQwRn6Vd01zixrO0RMHatzpLdHQklZ5LXFjDFTHaib
 hA2HlPYiBLkw9Q7SPRKWNPBFYbtqXxB10icU1Nj51wIuDO2k4cu4M57NLMNxFYWExww+
 X6F7t3f5NIFYdfgIxkK4dyUCcr06WYsvan6dDCslbVnTJgWksoWj0KAfixsAKQpC/VCs
 dtdLgxj2X5C05I12xICyQy52WetIBXXYPVhMXYbDpsXO9/G9uRmxjlw2c9XP/noh+run 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udkufqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Feb 2020 00:00:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LNvpU6153765;
        Sat, 22 Feb 2020 00:00:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y8ud7vec6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Feb 2020 00:00:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01M00SuG007204;
        Sat, 22 Feb 2020 00:00:29 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 16:00:28 -0800
Date:   Fri, 21 Feb 2020 19:00:45 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 061/191] padata: always acquire cpu_hotplug_lock
 before pinst->lock
Message-ID: <20200222000045.cl45vclfhvkjursm@ca-dmjordan1.us.oracle.com>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072258.745173144@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221072258.745173144@linuxfoundation.org>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=503 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=552 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:40:34AM +0100, Greg Kroah-Hartman wrote:
> From: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
> [ Upstream commit 38228e8848cd7dd86ccb90406af32de0cad24be3 ]
> 
> lockdep complains when padata's paths to update cpumasks via CPU hotplug
> and sysfs are both taken:
> 
>   # echo 0 > /sys/devices/system/cpu/cpu1/online
>   # echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   5.4.0-rc8-padata-cpuhp-v3+ #1 Not tainted
>   ------------------------------------------------------
>   bash/205 is trying to acquire lock:
>   ffffffff8286bcd0 (cpu_hotplug_lock.rw_sem){++++}, at: padata_set_cpumask+0x2b/0x120
> 
>   but task is already holding lock:
>   ffff8880001abfa0 (&pinst->lock){+.+.}, at: padata_set_cpumask+0x26/0x120
> 
>   which lock already depends on the new lock.

I think this patch should be dropped from all stable queues (4.4, 4.9, 4.14,
4.19, 5.4, and 5.5).

The main benefit is to un-break lockdep for testing with future padata changes,
and an actual deadlock seems unlikely.

These stable versions don't fix the ordering in padata_remove_cpu() either
(nothing calls it though).

I tried the other stable padata patch in this cycle ("padata: validate cpumask
without removed CPU during offline"), it passed my tests and should stay in.

thanks,
Daniel
