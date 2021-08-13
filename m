Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998D33EB420
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhHMKjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:39:48 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:58418 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239568AbhHMKjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1628851160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hI05B3vKevKapNXpCG14aO4HwxPCiPfU++4oWyXo8Eo=;
        b=mwQaAohcrJlZ61m7t0Ts6SVJv215msjSpfUW1AriS89CQIAXN0TxSAaNpB/39J5CZHL89s
        BeO3ny9qNs8jrycPgxKKCXD4W/kBMoD+oNH9gfNT3mzMWWv8mgwNYVXQK93Kp5xP8Dwr6U
        j5pGRNuF8Ol6Zh2t6gqImR4FjeM8Wuc=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2053.outbound.protection.outlook.com [104.47.1.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-LDIrlG2cNGqwwdmg9Qah5w-1; Fri, 13 Aug 2021 12:39:19 +0200
X-MC-Unique: LDIrlG2cNGqwwdmg9Qah5w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRc6TnEAd7AldG9qqvgQWT1ePmcEDjz1DZjVMmV9Fn1C710DI/fKep0VUXOG8w6wwPLp2CwLO6kgqQDXmMamvn91bH+iNoDwEhAN6VzaE7fiwYfJ0Px0IMTnRm6pQt2+CaiSueaOhKVAY1fmUu+sT+1T4urqk/7XinmzBpMTvn0c/1iIDkH4hkMc7EHnmul0U93fX6FGxYjEWwSl3EdaiCYBlxKZ+jD3SEJ2cZzl49ve1LB+cvekoubpfuHv1GA6KelW46eXSbgDr23qw2F92nBvYOmjk8G6X8PVVYTBwraTZkzyJLdIvwuxg3gVwPQ/O6COg90pFBkG1tv2uQjg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlh2hwiPXnPeXIpWig+0a1BxtbkPnvQElJHXCqoXq+8=;
 b=Z/fwB95xSFSnY7LHeAlLGr1N/v0m8BFuddWySoiuvg1QrA46Io44yLw3oX3L6TjJnp/Glda3Ivwbgd4bTH5PwLG8KpSVjtR+OyQRIM2PkZXEGABVcmH4kd51806JskOD3D8Av7YHJVC5sGH0vaHB98j2zoGJtPKtYd/2nJ8njAxT6N+SrnmzrUEN9C1H8wFpW7QAezBcJsQhBvOiT9MDLIYXSo9BKtRt+6af+JnvfW2d+s2pQHVJBxfWZOkZDRr61laOwDCOBoKJ6rnbtP3TbieKkn4EQyXNdMXUSiqHWkbCKX2YFUUHBm62D82q5e7+rsJO9ne/lJaGVbvk161DmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM7PR04MB6773.eurprd04.prod.outlook.com (2603:10a6:20b:dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Fri, 13 Aug
 2021 10:39:17 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::3510:ed3f:66d7:cf48]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::3510:ed3f:66d7:cf48%6]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 10:39:16 +0000
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
To:     Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
 <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
 <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
From:   Qu Wenruo <wqu@suse.com>
Message-ID: <6f45f8c6-03df-b2e0-cfda-85fd0b41212a@suse.com>
Date:   Fri, 13 Aug 2021 18:39:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR01CA0062.prod.exchangelabs.com (2603:10b6:a03:94::39)
 To AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR01CA0062.prod.exchangelabs.com (2603:10b6:a03:94::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 10:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 200eef2c-38f5-4874-e4e0-08d95e469997
X-MS-TrafficTypeDiagnostic: AM7PR04MB6773:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB677327DE202B48D9A99357F6D6FA9@AM7PR04MB6773.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5hbkPSmpIS5UqZE40eAyZ6crRnyzC97QXmDZZxkMuAZZyUeoezjYdWAljx51DAHKne0HaSG96Mi75sHfyTZjScbD6nKc1AjVShN3LjXu4CHZ7V6mP5D9K2sBvtyDRTGK3/D5K8jQEZ7gD1zTRZ2atJoBdi7QC3Zp8QGGxOrzYD35NF6W3T0HzJZXANs+AxOSi2EzttMtdKcvXiN3/4Aj8PHjgCu7CzG4YodeMMjaBDrdm96jnNauR96g1VjQ2IHtBW6vZklkow+ZQHfJBSGf72JvBjg157nb3h1qFkcJ9apwgIYvr2pk7rURqFXjmgLIE/XaqqmRZClO02io6HxAzVB4sr+tdBOTjP/vld1oBOXb7+49Id/g/rUXie2LlRuAWB32qmNG+WnfScrDi/k6sxhP53V6YWomeUWvFo5FjBlyDcPw3K9ja4JuZ1pO931E5Bxtm9AekGdzQJankjkErwstm9fsgSTDDoZ3pK01gCoHnhYzp23sZRbpR7+vhnIH+DiDAw2IcGvKomHPQjh4rip2TJKUadzxzUgbNlE65rVGn9f5nKTq0lb1A8IPotaguBvqfcUJRO6XF/MlOytMTsoXXpwZVuDUymn5+9AjZxLqUTLxaK9PAtY8GYwUqHFhzdX0lU69mv2sH9dnDVY8inHOyBbBvaXv7HnNQJ/0d0twiEp2EtW1/5I5QDOdTxDjq+tgzaLPpEdrzwYoe6E+/Hfr5YENCJugShajspQTyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6821.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(39840400004)(376002)(2906002)(30864003)(2616005)(26005)(956004)(31696002)(6666004)(53546011)(5660300002)(316002)(4001150100001)(16576012)(8676002)(38100700002)(110136005)(66946007)(4326008)(107886003)(6486002)(66476007)(31686004)(6706004)(8936002)(86362001)(186003)(54906003)(36756003)(66556008)(83380400001)(478600001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?++ufpwrKepfO1ScQPujGlUH0JTw1PJxt+uSfcPp83sHi1AuiRcIqGdBTL2D5?=
 =?us-ascii?Q?F+X/wtXXaoM0WpoIvvXg0pux6hX9C5vqQCP0ilocsfZfwWMVfwOEKn+uGCgU?=
 =?us-ascii?Q?2BlfVKvlmTptBX+rML+qRNf1ZD1C3QOaFB/wXRR7qAnmhV7efOvrzy4wPxn2?=
 =?us-ascii?Q?YLcNo/z7rhZpm15JUXzaH4QU6ldP0WZ+gRjvQ1oaYJuLxF1j5wSUCsnUy3Gv?=
 =?us-ascii?Q?Sl4mlcy473DkuBHeTZaCczn0dcKn07AssFDjrMeTFhhA3lPkw0wOKmT/FPP+?=
 =?us-ascii?Q?saI2ajfFHIZqFyBTH1oD3cJmvUnB3L6oPijWZSivlJOp8SVEFxpcKqoreGlF?=
 =?us-ascii?Q?eHFXlZ9Mf9ZEA6RyMzqRKG7Zy0u5HSyv8OunFDdrMAImHK5iGuxthKsHxYwm?=
 =?us-ascii?Q?EzHAlvx7UYuLVQlOY2M0zuhlRoyllaSdQmpvQ5AUmHv/qmg26TMqTDcBTwkj?=
 =?us-ascii?Q?DuuXU+8THD/OaNUAnKktm5dBmfB2ifZHeAGosv0lIZ2fKP1Q2fMohf+pLWU3?=
 =?us-ascii?Q?clPF6DkKETNdHNs4De/UytwNer5WbmLKhkSZC3+wJmwmyOCo++83RF8V7baQ?=
 =?us-ascii?Q?e5K51ljFblZhBPINa3c0aeVKfZqLa9ubVPqJKBF7WUlCOwUT9ApOhO5bZx96?=
 =?us-ascii?Q?es2+DZZxDB76qwPRJqDjbmyaA84u42e5zuI8CKjCd4XK3tr1bMtd2sZESpvy?=
 =?us-ascii?Q?tPXwa/aGfMK7yx8GXmoho/I2YKemh0BZHKuvJ/3JwxLY79d3SYsD0jJpZ9ln?=
 =?us-ascii?Q?0jUk32vKzgqaHieYck+PynMK7h08NXwUepYyEyb19gTo3LaPVa3blhYpIUjL?=
 =?us-ascii?Q?6iXBo+hJkkNmdD06kD/H/zYeQfYMHNYKiCS48+k3E5+Y3WAFmJ0qj6cs/QBv?=
 =?us-ascii?Q?qQKghfF54TPfrRaG/jFR0y4zyZGQSsc9b++acJ2gaxS4F7tAIoO81B/MQerO?=
 =?us-ascii?Q?unlfobbRNySHAEihp33i8U7BH1NzAm/M0MqU+lv9S9kLPydYDy4tJL+GnLxh?=
 =?us-ascii?Q?4Jc684V0SIfAIhaXDok5YybWImAC0f1wmvXTRZbRWmi6kh/JxZMkYUNX8PvD?=
 =?us-ascii?Q?ke4dcXcSE5/oi1ehqF2iluN2NG2gULv1VIcVbqKIBpGafUI3IcM/e/7RPiK3?=
 =?us-ascii?Q?7XXd4pxxmb83krWvRrrBwh2n5OMIFw4MjDRPanQoma7u5u5+chkVs2AtGo/G?=
 =?us-ascii?Q?7WM7cMcKhbNO8G07rjM3vsi1mvQc58ymnyzeVDyFWTOPKzCwPYTSbNg5DTTW?=
 =?us-ascii?Q?IcmkpbixhGnBfSWpDxQjlLuyU+5v/l97Speu5J7jODXgXsJzKulEwYY9YhJr?=
 =?us-ascii?Q?KoguwKdIlWX6DR1oXCzKh4GD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200eef2c-38f5-4874-e4e0-08d95e469997
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 10:39:16.8142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMQb3h+5+lcB5ocKvwNzLL+NgUWObngXHwizY7L/KCVFuqyM6hzzlzz+kxxCkTCh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6773
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/8/13 =E4=B8=8B=E5=8D=886:30, Anand Jain wrote:
>=20
>=20
> On 13/08/2021 18:26, Qu Wenruo wrote:
>>
>>
>> On 2021/8/13 =E4=B8=8B=E5=8D=885:55, Anand Jain wrote:
>>> From: Qu Wenruo <wqu@suse.com>
>>>
>>> commit c53e9653605dbf708f5be02902de51831be4b009 upstream
>>
>> This lacks certain upstream fixes for it:
>>
>> f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
>> cloning inline extents and using qgroups
>>
>> 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
>> btrfs_delayed_inode_reserve_metadata
>>
>> 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
>> transaction when we already hold the handle
>>
>> All these fixes are to ensure we don't try to flush in context where we
>> shouldn't.
>>
>> Without them, it can hit various deadlock.
>>
>=20
> Qu,
>=20
>  =C2=A0=C2=A0 Thanks for taking a look. I will send it in v2.

I guess you only need to add the missing fixes?

Thanks,
Qu
>=20
> -Anand
>=20
>=20
>> Thanks,
>> Qu
>>>
>>> [PROBLEM]
>>> There are known problem related to how btrfs handles qgroup reserved
>>> space.=C2=A0 One of the most obvious case is the the test case btrfs/15=
3,
>>> which do fallocate, then write into the preallocated range.
>>>
>>> =C2=A0=C2=A0 btrfs/153 1s ... - output mismatch (see=20
>>> xfstests-dev/results//btrfs/153.out.bad)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 --- tests/btrfs/153.out=C2=A0=C2=
=A0=C2=A0=C2=A0 2019-10-22 15:18:14.068965341 +0800
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +++ xfstests-dev/results//btrfs/15=
3.out.bad=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2020-07-01=20
>>> 20:24:40.730000089 +0800
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 @@ -1,2 +1,5 @@
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 QA output created by 153
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +pwrite: Disk quota exceeded
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +/mnt/scratch/testfile2: Disk quot=
a exceeded
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +/mnt/scratch/testfile2: Disk quot=
a exceeded
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Silence is golden
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (Run 'diff -u xfstests-dev/tests/b=
trfs/153.out=20
>>> xfstests-dev/results//btrfs/153.out.bad'=C2=A0 to see the entire diff)
>>>
>>> [CAUSE]
>>> Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we=20
>>> have to"),
>>> we always reserve space no matter if it's COW or not.
>>>
>>> Such behavior change is mostly for performance, and reverting it is not
>>> a good idea anyway.
>>>
>>> For preallcoated extent, we reserve qgroup data space for it already,
>>> and since we also reserve data space for qgroup at buffered write time,
>>> it needs twice the space for us to write into preallocated space.
>>>
>>> This leads to the -EDQUOT in buffered write routine.
>>>
>>> And we can't follow the same solution, unlike data/meta space check,
>>> qgroup reserved space is shared between data/metadata.
>>> The EDQUOT can happen at the metadata reservation, so doing NODATACOW
>>> check after qgroup reservation failure is not a solution.
>>>
>>> [FIX]
>>> To solve the problem, we don't return -EDQUOT directly, but every time
>>> we got a -EDQUOT, we try to flush qgroup space:
>>>
>>> - Flush all inodes of the root
>>> =C2=A0=C2=A0 NODATACOW writes will free the qgroup reserved at=20
>>> run_dealloc_range().
>>> =C2=A0=C2=A0 However we don't have the infrastructure to only flush NOD=
ATACOW
>>> =C2=A0=C2=A0 inodes, here we flush all inodes anyway.
>>>
>>> - Wait for ordered extents
>>> =C2=A0=C2=A0 This would convert the preallocated metadata space into pe=
r-trans
>>> =C2=A0=C2=A0 metadata, which can be freed in later transaction commit.
>>>
>>> - Commit transaction
>>> =C2=A0=C2=A0 This will free all per-trans metadata space.
>>>
>>> Also we don't want to trigger flush multiple times, so here we introduc=
e
>>> a per-root wait list and a new root status, to ensure only one thread
>>> starts the flushing.
>>>
>>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> Reviewed-by: David Sterba <dsterba@suse.com>
>>> Signed-off-by: David Sterba <dsterba@suse.com>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> =C2=A0 fs/btrfs/ctree.h=C2=A0=C2=A0 |=C2=A0=C2=A0 3 ++
>>> =C2=A0 fs/btrfs/disk-io.c |=C2=A0=C2=A0 1 +
>>> =C2=A0 fs/btrfs/qgroup.c=C2=A0 | 100 ++++++++++++++++++++++++++++++++++=
+++++++----
>>> =C2=A0 3 files changed, 96 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 7960359dbc70..5448dc62e915 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -945,6 +945,8 @@ enum {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_ROOT_DEAD_TREE,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The root has a log tree. Used only fo=
r subvolume roots. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_ROOT_HAS_LOG_TREE,
>>> +=C2=A0=C2=A0=C2=A0 /* Qgroup flushing is in progress */
>>> +=C2=A0=C2=A0=C2=A0 BTRFS_ROOT_QGROUP_FLUSHING,
>>> =C2=A0 };
>>>
>>> =C2=A0 /*
>>> @@ -1097,6 +1099,7 @@ struct btrfs_root {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spinlock_t qgroup_meta_rsv_lock;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 qgroup_meta_rsv_pertrans;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 qgroup_meta_rsv_prealloc;
>>> +=C2=A0=C2=A0=C2=A0 wait_queue_head_t qgroup_flush_wait;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Number of active swapfiles */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_t nr_swapfiles;
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index e6aa94a583e9..e3bcab38a166 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_root=20
>>> *root, struct btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&root->log_mutex);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&root->ordered_extent_mutex);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&root->delalloc_mutex);
>>> +=C2=A0=C2=A0=C2=A0 init_waitqueue_head(&root->qgroup_flush_wait);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_waitqueue_head(&root->log_writer_wa=
it);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_waitqueue_head(&root->log_commit_wa=
it[0]);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_waitqueue_head(&root->log_commit_wa=
it[1]);
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index 50c45b4fcfd4..b312ac645e08 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct=20
>>> btrfs_inode *inode,
>>> =C2=A0 }
>>>
>>> =C2=A0 /*
>>> - * Reserve qgroup space for range [start, start + len).
>>> + * Try to free some space for qgroup.
>>> =C2=A0=C2=A0 *
>>> - * This function will either reserve space from related qgroups or=20
>>> doing
>>> - * nothing if the range is already reserved.
>>> + * For qgroup, there are only 3 ways to free qgroup space:
>>> + * - Flush nodatacow write
>>> + *=C2=A0=C2=A0 Any nodatacow write will free its reserved data space a=
t=20
>>> run_delalloc_range().
>>> + *=C2=A0=C2=A0 In theory, we should only flush nodatacow inodes, but i=
t's not yet
>>> + *=C2=A0=C2=A0 possible, so we need to flush the whole root.
>>> =C2=A0=C2=A0 *
>>> - * Return 0 for successful reserve
>>> - * Return <0 for error (including -EQUOT)
>>> + * - Wait for ordered extents
>>> + *=C2=A0=C2=A0 When ordered extents are finished, their reserved metad=
ata is=20
>>> finally
>>> + *=C2=A0=C2=A0 converted to per_trans status, which can be freed by la=
ter commit
>>> + *=C2=A0=C2=A0 transaction.
>>> =C2=A0=C2=A0 *
>>> - * NOTE: this function may sleep for memory allocation.
>>> + * - Commit transaction
>>> + *=C2=A0=C2=A0 This would free the meta_per_trans space.
>>> + *=C2=A0=C2=A0 In theory this shouldn't provide much space, but any mo=
re=20
>>> qgroup space
>>> + *=C2=A0=C2=A0 is needed.
>>> =C2=A0=C2=A0 */
>>> -int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>>> +static int try_flush_qgroup(struct btrfs_root *root)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * We don't want to run flush again and again,=
 so if there is a=20
>>> running
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * one, we won't try to start a new flush, but=
 exit directly.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &r=
oot->state)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_event(root->qgroup_flu=
sh_wait,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !te=
st_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_start_delalloc_snapshot(root);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-=
1);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_join_transaction(root);
>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(trans);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_commit_transaction(trans);
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)=
;
>>> +=C2=A0=C2=A0=C2=A0 wake_up(&root->qgroup_flush_wait);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int qgroup_reserve_data(struct btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 struct extent_changeset **reserved_ret, u64 start,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 len)
>>> =C2=A0 {
>>> @@ -3542,6 +3583,34 @@ int btrfs_qgroup_reserve_data(struct=20
>>> btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> =C2=A0 }
>>>
>>> +/*
>>> + * Reserve qgroup space for range [start, start + len).
>>> + *
>>> + * This function will either reserve space from related qgroups or=20
>>> do nothing
>>> + * if the range is already reserved.
>>> + *
>>> + * Return 0 for successful reservation
>>> + * Return <0 for error (including -EQUOT)
>>> + *
>>> + * NOTE: This function may sleep for memory allocation, dirty page=20
>>> flushing and
>>> + *=C2=A0=C2=A0=C2=A0=C2=A0 commit transaction. So caller should not ho=
ld any dirty page=20
>>> locked.
>>> + */
>>> +int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=
uct extent_changeset **reserved_ret, u64 start,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64=
 len)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D qgroup_reserve_data(inode, reserved_ret, st=
art, len);
>>> +=C2=A0=C2=A0=C2=A0 if (ret <=3D 0 && ret !=3D -EDQUOT)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D try_flush_qgroup(inode->root);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0 return qgroup_reserve_data(inode, reserved_ret, sta=
rt, len);
>>> +}
>>> +
>>> =C2=A0 /* Free ranges specified by @reserved, normally in error path */
>>> =C2=A0 static int qgroup_free_reserved_data(struct btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 struct extent_changeset *reserved, u64 start, u64 len)
>>> @@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrfs_root=20
>>> *root, int num_bytes,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return num_bytes;
>>> =C2=A0 }
>>>
>>> -int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes=
,
>>> +static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum btrfs_qgroup_rsv_type type, bool enf=
orce)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D root->=
fs_info;
>>> @@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct=20
>>> btrfs_root *root, int num_bytes,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> =C2=A0 }
>>>
>>> +int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 enum btrfs_qgroup_rsv_type type, bool enforce)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D qgroup_reserve_meta(root, num_bytes, type, =
enforce);
>>> +=C2=A0=C2=A0=C2=A0 if (ret <=3D 0 && ret !=3D -EDQUOT)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D try_flush_qgroup(root);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0 return qgroup_reserve_meta(root, num_bytes, type, e=
nforce);
>>> +}
>>> +
>>> =C2=A0 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root=
)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D root->=
fs_info;
>>>
>=20

