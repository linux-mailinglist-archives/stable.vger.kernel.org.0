Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E73276446
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 01:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIWXBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 19:01:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIWXBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 19:01:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NMx7UG165398;
        Wed, 23 Sep 2020 23:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mBSwv35Q29nwIcce+8KYJoJfCZxCFQtOXzsXw+eLujk=;
 b=xPIK+BL2eYvj+UUCNb+KTm0Mlr/2VkOkBhKj0UcjyLV0ArAcxALTbNqYqUZ4Z1uLyWSu
 qcm5r6DRvnMBJITlGYlV+eA3fVVhBiiEA96Qtv7M2rXNd6kMEp8wR2RcocZXrVUWFKJ5
 k+hiqiz2WE8ju1nXCbTgbtFJvXkibWA4dj20ZxwP+yzLQU91Uj+WuXUJwGCwuiejBulx
 kvonQqK0xUQtglKsH3DnCGITTBAZhO1Gaflqz8mmtXTYGhYeLwK9C9smsx/zgv4aJX1s
 XxJj0xKDGj/SNjP5re0JGUP6l5zePJC9UBpu3NoLfUYdFD5MZN1o6k2zaoyo7R8K1oFU gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnun9et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 23:01:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NMua58124544;
        Wed, 23 Sep 2020 22:59:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33nurvd56c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 22:59:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NMxerd002461;
        Wed, 23 Sep 2020 22:59:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 15:59:40 -0700
Date:   Wed, 23 Sep 2020 15:59:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH STABLE] xfs: trim IO to found COW exent limit
Message-ID: <20200923225939.GY7955@magnolia>
References: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
 <34c164fb-d616-1467-c96a-77c99e436421@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34c164fb-d616-1467-c96a-77c99e436421@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230175
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 05:37:39PM -0500, Eric Sandeen wrote:
> Here's a reproducer for the bug.
> 
> Requires sufficient privs to mount a loopback fs.

Please turn this into an fstest case, but otherwise this looks
reasonable.

--D

> 
> ======
> 
> #!/bin/bash
> 
> mkdir -p mnt
> umount mnt &>/dev/null
> 
> # Create 8g fs image
> mkfs.xfs -f -dfile,name=fsfile.img,size=8g &>/dev/null
> mount -o loop fsfile.img mnt
> 
> # Make all files w/ 1m hints; create original 2m file
> xfs_io -c "extsize 1048576" mnt
> xfs_io -c "cowextsize 1048576" mnt
> 
> echo "Create file mnt/b"
> xfs_io -f -c "pwrite -S 0x0 0 2m" -c fsync mnt/b &>/dev/null
> 
> # Make a reflinked copy
> echo "Reflink copy from mnt/b to mnt/a"
> cp --reflink=always mnt/b mnt/a
> 
> echo "Contents of mnt/b"
> hexdump -C mnt/b
> 
> # Cycle mount to get stuff out of cache
> umount mnt
> mount -o loop fsfile.img mnt
> 
> # Create a 1m-hinted IO at offset 0, then
> # do another IO that overlaps but extends past the 1m hint
> echo "Write to mnt/a"
> xfs_io -c "pwrite -S 0xa 0k -b 4k 4k" \
>        -c "pwrite -S 0xa 4k -b 1m 1m" \
>        mnt/a &>/dev/null
> 
> xfs_io -c fsync mnt/a
> 
> echo "Contents of mnt/b now:"
> hexdump -C mnt/b
> 
> umount mnt
> 
