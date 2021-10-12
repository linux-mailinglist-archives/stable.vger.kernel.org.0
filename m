Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951AF42A5D1
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbhJLNjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 09:39:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232893AbhJLNjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 09:39:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CCaWHN025969;
        Tue, 12 Oct 2021 09:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WG15WcYuQXs6RQkmhoEJObFDOrJKXzFRAssgl9cooqU=;
 b=nB1QX9Tl5BbbdWowbfS+mKPYPws4PtuAXumAsJTwqJMLyTbNL+kpZ6WklX2kv7kIF8/z
 FgMbSeio6pBYBn+mM8SWHR3GJrdQQpTgC2qelTBfX9DT16lCOI87r6z96Z1z0kC85+jz
 tO6HpmEJeUMMGjORbo0rO08llYBz3IXJ4gf0FePAwwCGfLI2t8w4uVD8jN3i+4vZ4G6m
 vxi4HWxgb1dssuIiI8smqQQrJP90a09Jjv6g7NMg6rL89GUg+FKtEqN4AfsJfGq0LDi0
 a0a8etAOpkwGWRpn8OHXQmvGoHr2CfGwIABo4Q6DIoFwSXJQjb33XwsVk/G3pYrQ0NiT yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn7h0duju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 09:37:04 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CCeSZk006810;
        Tue, 12 Oct 2021 09:37:04 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn7h0duhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 09:37:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CDROpI029859;
        Tue, 12 Oct 2021 13:37:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3bk2q9ff0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 13:37:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CDaloT61669862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 13:36:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B0F11C069;
        Tue, 12 Oct 2021 13:36:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5686211C06C;
        Tue, 12 Oct 2021 13:36:39 +0000 (GMT)
Received: from li-748c07cc-28e5-11b2-a85c-e3822d7eceb3.ibm.com (unknown [9.171.57.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 13:36:38 +0000 (GMT)
Message-ID: <13162b9e48402f306b3f50e6686d76a051138a75.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1]  s390/cio: make ccw_device_dma_* more robust
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, bfu@redhat.com
Date:   Tue, 12 Oct 2021 15:36:36 +0200
In-Reply-To: <20211011115955.2504529-1-pasic@linux.ibm.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g-gKyBT5ISQyVVspeO-V9jTx8KHwnqsJ
X-Proofpoint-GUID: LSIZLlfdhXbLS2fLjgwWsk8pzAAI-jNl
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_03,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=848 bulkscore=0 clxscore=1011 spamscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110120079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good. Thanks.
Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>

Some minor questions below.

On Mon, 2021-10-11 at 13:59 +0200, Halil Pasic wrote:
> Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O
> and
> classic notifiers") we were supposed to make sure that
> virtio_ccw_release_dev() completes before the ccw device and the
> attached dma pool are torn down, but unfortunately we did
> not.  Before
> that commit it used to be OK to delay cleaning up the memory
> allocated
> by virtio-ccw indefinitely (which isn't really intuitive for guys
> used
> to destruction happens in reverse construction order), but now we
> trigger a BUG_ON if the genpool is destroyed before all memory
> allocated
> form it.
allocated from it ?
>  Which brings down the guest. We can observe this problem, when
> unregister_virtio_device() does not give up the last reference to the
> virtio_device (e.g. because a virtio-scsi attached scsi disk got
> removed
> without previously unmounting its previously mounted  partition).
> 
> To make sure that the genpool is only destroyed after all the
> necessary
> freeing is done let us take a reference on the ccw device on each
> ccw_device_dma_zalloc() and give it up on each ccw_device_dma_free().
> 
> Actually there are multiple approaches to fixing the problem at hand
> that can work. The upside of this one is that it is the safest one
> while
> remaining simple. We don't crash the guest even if the driver does
> not
> pair allocations and frees. The downside is the reference counting
> overhead, that the reference counting for ccw devices becomes more
> complex, in a sense that we need to pair the calls to the
> aforementioned
> functions for it to be correct, and that if we happen to leak, we
> leak
> more than necessary (the whole ccw device instead of just the
> genpool).
> 
> Some alternatives to this approach are taking a reference in
> virtio_ccw_online() and giving it up in virtio_ccw_release_dev() or
> making sure virtio_ccw_release_dev() completes its work before
> virtio_ccw_remove() returns. The downside of these approaches is that
> these are less safe against programming errors.
> 
> Cc: <stable@vger.kernel.org> # v5.3
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers")
> Reported-by: bfu@redhat.com
> 
> ---
> 
> FYI I've proposed a different fix to this very same problem:
> https://lore.kernel.org/lkml/20210915215742.1793314-1-pasic@linux.ibm.com/
> 
> This patch is more or less a result of that discussion.
> 

