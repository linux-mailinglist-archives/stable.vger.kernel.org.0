Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0123214990
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 03:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgGEBzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 21:55:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgGEBzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 21:55:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0651nemV141060;
        Sun, 5 Jul 2020 01:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6iSTK2WupYjVu21PmxTXt2YmgujtTgv3yHEIzWAXVSU=;
 b=o6aIveU6v/Ra+yti/BMt6UbM+7+2odQVrGwH2MwayKvVqkpaOFWPUEV+XEO+JcfHadAM
 Cwg2ansCCqbq3xjiWx3dYoT1GhlL4HVTUHqIXyNxBO4kk0jHmvyT7hnnDe34jelknc7K
 xDE6aJu5nAGtEsEM6RXb/1ciRianAllNWfvc/706S1VZJ11Uc+cJWwDE2xbo5MkkPbZm
 BwyFiK1Egcl9s3LwXdRrXvPh7rXRQN0TKiNmtMZWvZsEQPmnDE/GXFcHmNF6aE857/Os
 QxdeqdzKOJovnk4z08G9W+nNY7CHhEE7aipcvj+ugM/TsKOu7NYBBerBmw4LwIL3d/Cd qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 322h6r1vk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 01:49:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0651mxVb174347;
        Sun, 5 Jul 2020 01:49:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3233bjkcg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 01:49:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0651nVgl011889;
        Sun, 5 Jul 2020 01:49:31 GMT
Received: from Junxiaos-MacBook-Pro.local (/73.231.9.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 04 Jul 2020 18:49:31 -0700
Subject: Re: [PATCH 4.19 114/131] ocfs2: avoid inode removal while nfsd is
 accessing it
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-115-sashal@kernel.org> <20200702211717.GC5787@amd>
 <CAHk-=wj1VVZoNvtVYL9wCPVjBHwxhCXd4TfKbY0-OsG4nGyf2w@mail.gmail.com>
From:   Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <c2a0af77-2714-202b-43d9-7100daeb80b1@oracle.com>
Date:   Sat, 4 Jul 2020 18:49:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj1VVZoNvtVYL9wCPVjBHwxhCXd4TfKbY0-OsG4nGyf2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=999 clxscore=1011
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050011
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/2/20 3:24 PM, Linus Torvalds wrote:

> On Thu, Jul 2, 2020 at 2:17 PM Pavel Machek <pavel@denx.de> wrote:
>>
>>> commit 4cd9973f9ff69e37dd0ba2bd6e6423f8179c329a upstream.
>>>
>>> Patch series "ocfs2: fix nfsd over ocfs2 issues", v2.
>> This causes locking imbalance:
> This sems to be true upstream too.
>
>> When ocfs2_nfs_sync_lock() returns error, caller can not know if the
>> lock was taken or not.
> Right you are.
>
> And your patch looks sane:
>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index c141b06811a6..8149fb6f1f0d 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -2867,9 +2867,15 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
>>
>>          status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
>>                                      0, 0);
>> -       if (status < 0)
>> +       if (status < 0) {
>>                  mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
>>
>> +               if (ex)
>> +                       up_write(&osb->nfs_sync_rwlock);
>> +               else
>> +                       up_read(&osb->nfs_sync_rwlock);
>> +       }
>> +
>>          return status;
>>   }
> although the whole thing looks messy.
>
> If the issue is a lifetime thing (like that commit says), the proper
> model isn't a lock, but a refcount.
>
> Oh well. Junxiao?

There is a block number embedded in nfs file handle, to verify it's an 
inode, need acquire this nfs_sync_lock global lock to avoid any inode 
removed from local node and other nodes in the cluster, before this 
verify done, seemed no way to use a refcount.

Thanks,

Junxiao.

>
>                 Linus
