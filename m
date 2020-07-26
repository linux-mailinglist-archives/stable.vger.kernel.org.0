Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4A722DF5E
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGZMy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 08:54:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:53234 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgGZMy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 08:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1595768094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=h9TnkEav1SHZzt6gkuS4z24tiBhYnxV2WzAdfdammBQ=;
        b=dKY2UZnm5xHcCJtRSPVykcxyM32WejoXWpIYtVcJIjvhnDaRCICF2G7Pdyb9WiGUFaoWx6
        vj6/rbMUm7OJ39zEa2zUkmlJ2sVvgBZFcGytUjlqjiLWDHQ1YITkAgiuLzeDL3gWKhcaui
        pj94WsAEfcAmgoROHi+zKTy8lWeqUOw=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-9AyzVvpLPzSShY2EeEDEWQ-1;
 Sun, 26 Jul 2020 14:54:52 +0200
X-MC-Unique: 9AyzVvpLPzSShY2EeEDEWQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUW4FBp/nxhCgADEQ0kQF9EguUJwd9mt9h/79r2HraXA+BeSPI3btGHbzvCIt9loLj/zhUAdSgusVdRayhFsMi7LQ9i2I7JjoBaNKNOcE49Sr52nqodwjjtFu4ebJTAfuay2BDHuIVh0Vs4p7+lHlyq/3uiMZyyyctqYf6AyzXmi+VeJ5cvBrl4MxR7KXhUKw9w+LtfLY7FdclPzsjjINszLJTXNXS3WPUS16hWmXMDVK8lieo/D51CUm9ZdTg7G/5zYFoGQET+QZ/KhxB17qewasWYXFWYCktm9K8egfpscgssDzsBnUELNfVA2C9QhO391PJ8mpt+nqyxBpS3DBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1p2+9Ouj9rIyAqMHNUDNts7eIgbofl0McSMUNwZB40=;
 b=NgbbuAWYQxqX+euU6VEt9/SqwUMI3zcXlbuJpQmyKlY7OpAb95kIiiauUwyiHw1vJBqVtutgMVgXfFflNeOQ7L16RSoZlovTxF+EhTdZo3Z3FX2j3e031CU0/+GUDH5XLpEoXSU0U2ah1pcHdpidmhLwe64aMh5jP+Cwm4SPF3GmKYgqERxZDouiQQtY1tY2she/uCUaDH1xYjlhJcIV5IOpvl2TsCml/DpJMi0Ni1NfJZjFHNoAn6X1CyRQ2jxn4EF38zlZrtlmylotCPPnjRvpFRyQ+VZv+0D2tSixodyKK2hd/W07rZvnukT7F4I+UPGm6gZnvjA0Sxt9LWbpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com (2603:10a6:208:13c::13)
 by AM0PR04MB4162.eurprd04.prod.outlook.com (2603:10a6:208:60::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Sun, 26 Jul
 2020 12:54:50 +0000
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::688e:afdb:90d9:bdef]) by AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::688e:afdb:90d9:bdef%3]) with mapi id 15.20.3216.030; Sun, 26 Jul 2020
 12:54:50 +0000
Subject: Re: Patch "btrfs: qgroup: fix data leak caused by race between
 writeback and truncate" has been added to the 4.14-stable tree
From:   Qu Wenruo <wqu@suse.com>
To:     gregkh@linuxfoundation.org
CC:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <15957672628285@kroah.com>
 <3b1eaf71-0b54-ae4d-0fd5-26103ee8ff3d@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0GFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPokBTQQTAQgAOAIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJdnDWhAAoJEMI9kfOhJf6oZgoH
 90uqoGyUh5UWtiT9zjUcvlMTCpd/QSgwagDuY+tEdVPaKlcnTNAvZKWSit8VuocjrOFbTLwb
 vZ43n5f/l/1QtwMgQei/RMY2XhW+totimzlHVuxVaIDwkF+zc+pUI6lDPnULZHS3mWhbVr9N
 vZAAYVV7GesyyFpZiNm7GLvLmtEdYbc9OnIAOZb3eKfY3mWEs0eU0MxikcZSOYy3EWY3JES7
 J9pFgBrCn4hF83tPH2sphh1GUFii+AUGBMY/dC6VgMKbCugg+u/dTZEcBXxD17m+UcbucB/k
 F2oxqZBEQrb5SogdIq7Y9dZdlf1m3GRRJTX7eWefZw10HhFhs1mwx7kBDQRZ1YGvAQgAqlPr
 YeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4KXk/kHw5h
 ieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T7RZwB69u
 VSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9fNN8e9c0
 MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD/dt76Kp/
 o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgBCAAmAhsM
 FiEELd9y5aWlW6idqkLhwj2R86El/qgFAl2cNa4FCQlqTn8ACgkQwj2R86El/qhXBAf/eXLP
 HDNTkHRPxoDnwhscIHJDHlsszke25AFltJQ1adoaYCbsQVv4Mn5rQZ1Gon54IMdxBN3r/B08
 rGVPatIfkycMCShr+rFHPKnExhQ7Wr555fq+sQ1GOwOhr1xLEqAhBMp28u9m8hnkqL36v+AF
 hjTwRtS+tRMZfoG6n72xAj984l56G9NPfs/SOKl6HR0mCDXwJGZAOdtyRmqddi53SXi5N4H1
 jWX1xFshp7nIkRm6hEpISEWr/KKLbAiKKbP0ql5tP5PinJeIBlDv4g/0+aGoGg4dELTnfEVk
 jMC8cJ/LiIaR/OEOF9S2nSeTQoBmusTz+aqkbogvvYGam6uDYw==
Message-ID: <64ba52d0-04e6-63a8-28f8-36345a708b20@suse.com>
Date:   Sun, 26 Jul 2020 20:54:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <3b1eaf71-0b54-ae4d-0fd5-26103ee8ff3d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To AM0PR04MB6195.eurprd04.prod.outlook.com
 (2603:10a6:208:13c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR03CA0025.namprd03.prod.outlook.com (2603:10b6:a02:a8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24 via Frontend Transport; Sun, 26 Jul 2020 12:54:39 +0000
X-Originating-IP: [149.28.201.231]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03ac09f8-7cc2-4869-d200-08d83163154e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4162:
X-Microsoft-Antispam-PRVS: <AM0PR04MB416282F90E264403A766213FD6750@AM0PR04MB4162.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1Q+4yy6cAGCyBpIXqHys/kDouTJGpehE8JNs8rMwmT25ZOYtj6wYLNbeQAp3n8wYpHCQ2ixVjC+7CfQ1ML1L2foCF3HjorvCXzntyh2Hp10GL1lTxWZOT7ZFEuZnp1qG6xP3/NWq9pG9lVsEhzM6mEBA/p20m1Lp6QmMNIrh8ln20LO14k3yg+Tb1l1vA7aoEbvXxyoq0D8chTE8xgzE0n2AhSAiOY8MdLGg+z9nLEYVwEdj2x72HEaDt40gYN47NZ7fuWR5k3RDco66gtoQfPOKAv5pYyf9ZlOFrZIhp8L7UdSaECpFi1g8nqq1VTJVeZ4qii2C1vNvXOQhNbcap/mFk5blDx68g4U3v3C8LvLEQryNT1+QuA+OTkqTsczECYXiSVaAbMlJkg2dVzV1ZwLOI1cRrQQ24Qsogod2uyKlGxA4Viczrv0YL6E8p6vNSJ2KSL2EI2SUTl5U4CJ8YqatHymm3rNJw4Lo8tOKgo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6195.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39860400002)(366004)(346002)(396003)(86362001)(36756003)(66476007)(66556008)(2616005)(956004)(478600001)(6666004)(31696002)(8936002)(6486002)(5660300002)(66946007)(53546011)(8676002)(2906002)(316002)(6706004)(83380400001)(16576012)(31686004)(6916009)(4326008)(52116002)(26005)(966005)(186003)(16526019)(54906003)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FiBrxB3ZpvGYEj8PrUliVKX+oSMCPNj+b8dF9ctvWsC7zOqy12jRyacwE3W2A2tOXQWYLTOyF+jlymnVex9O/r3CShalIoZu7/bjzsmSqVKUly9TVHcR1BIL8MYYZXlMbZ4CCoUf0lRNIdKS39kR98tdB61NhRIO4pdW5RrteUzE4MHSfDYah2O5yvWrrsNiW5gKyGbjA0NLCi6dfS3eO0ncBkjg28NAjXWm5rjJrigj2su2lIrETEoC6MilIvJwftpJ22ca2PLnBMQnClwt+FcZHSFA0CXhQxbwTm3wDRYIr2FIdb2mYqyf3hpWTW1IcCJHp86LM6JP2jz3FhuWr3I245Ulr+zUfmQTp1FuYe+Ey/CnASUxMwxle0lDsm8YgOl+vmJlYAV2MeCYx/44DXneDrRDtfqyuuAPVaxYYcidUO+cvMdX4eIKQuZJcCTWmwXqMFjWRQVi7xNONAMYf3raYPjPo6/iAXPEPsbF5Sk=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ac09f8-7cc2-4869-d200-08d83163154e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6195.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2020 12:54:50.4734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIjJ4W1zryJuwLEb++0wfrm2N7Gs5rj4blAzp/kMgywpHL0WC8Mbvo5pPQf9Bi2G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4162
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/7/26 =E4=B8=8B=E5=8D=888:51, Qu Wenruo wrote:
>=20
>=20
> On 2020/7/26 =E4=B8=8B=E5=8D=888:41, gregkh@linuxfoundation.org wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     btrfs: qgroup: fix data leak caused by race between writeback and tr=
uncate
>>
>> to the 4.14-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.=
git;a=3Dsummary
>>
>> The filename of the patch is:
>>      btrfs-qgroup-fix-data-leak-caused-by-race-between-writeback-and-tru=
ncate.patch
>> and it can be found in the queue-4.14 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>=20
> Please don't merge this patch for any of the stable branches.
>=20
> This patch needs one unmerged patch ("btrfs: change timing for qgroup
> reserved space for ordered extents to fix reserved space leak", already
> in maintainer's tree) as prerequisite.

Also add btrfs mail list to the discssusion.

>=20
> The behavior without that patch could be problematic.
>=20
> I should have noticed this earlier.
>=20
> Thanks,
> Qu
>=20
>>
>>
>> From fa91e4aa1716004ea8096d5185ec0451e206aea0 Mon Sep 17 00:00:00 2001
>> From: Qu Wenruo <wqu@suse.com>
>> Date: Fri, 17 Jul 2020 15:12:05 +0800
>> Subject: btrfs: qgroup: fix data leak caused by race between writeback a=
nd truncate
>>
>> From: Qu Wenruo <wqu@suse.com>
>>
>> commit fa91e4aa1716004ea8096d5185ec0451e206aea0 upstream.
>>
>> [BUG]
>> When running tests like generic/013 on test device with btrfs quota
>> enabled, it can normally lead to data leak, detected at unmount time:
>>
>>   BTRFS warning (device dm-3): qgroup 0/5 has unreleased space, type 0 r=
sv 4096
>>   ------------[ cut here ]------------
>>   WARNING: CPU: 11 PID: 16386 at fs/btrfs/disk-io.c:4142 close_ctree+0x1=
dc/0x323 [btrfs]
>>   RIP: 0010:close_ctree+0x1dc/0x323 [btrfs]
>>   Call Trace:
>>    btrfs_put_super+0x15/0x17 [btrfs]
>>    generic_shutdown_super+0x72/0x110
>>    kill_anon_super+0x18/0x30
>>    btrfs_kill_super+0x17/0x30 [btrfs]
>>    deactivate_locked_super+0x3b/0xa0
>>    deactivate_super+0x40/0x50
>>    cleanup_mnt+0x135/0x190
>>    __cleanup_mnt+0x12/0x20
>>    task_work_run+0x64/0xb0
>>    __prepare_exit_to_usermode+0x1bc/0x1c0
>>    __syscall_return_slowpath+0x47/0x230
>>    do_syscall_64+0x64/0xb0
>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>   ---[ end trace caf08beafeca2392 ]---
>>   BTRFS error (device dm-3): qgroup reserved space leaked
>>
>> [CAUSE]
>> In the offending case, the offending operations are:
>> 2/6: writev f2X[269 1 0 0 0 0] [1006997,67,288] 0
>> 2/7: truncate f2X[269 1 0 0 48 1026293] 18388 0
>>
>> The following sequence of events could happen after the writev():
>> 	CPU1 (writeback)		|		CPU2 (truncate)
>> -----------------------------------------------------------------
>> btrfs_writepages()			|
>> |- extent_write_cache_pages()		|
>>    |- Got page for 1003520		|
>>    |  1003520 is Dirty, no writeback	|
>>    |  So (!clear_page_dirty_for_io())   |
>>    |  gets called for it		|
>>    |- Now page 1003520 is Clean.	|
>>    |					| btrfs_setattr()
>>    |					| |- btrfs_setsize()
>>    |					|    |- truncate_setsize()
>>    |					|       New i_size is 18388
>>    |- __extent_writepage()		|
>>    |  |- page_offset() > i_size		|
>>       |- btrfs_invalidatepage()		|
>> 	 |- Page is clean, so no qgroup |
>> 	    callback executed
>>
>> This means, the qgroup reserved data space is not properly released in
>> btrfs_invalidatepage() as the page is Clean.
>>
>> [FIX]
>> Instead of checking the dirty bit of a page, call
>> btrfs_qgroup_free_data() unconditionally in btrfs_invalidatepage().
>>
>> As qgroup rsv are completely bound to the QGROUP_RESERVED bit of
>> io_tree, not bound to page status, thus we won't cause double freeing
>> anyway.
>>
>> Fixes: 0b34c261e235 ("btrfs: qgroup: Prevent qgroup->reserved from going=
 subzero")
>> CC: stable@vger.kernel.org # 4.14+
>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>>  fs/btrfs/inode.c |   23 ++++++++++-------------
>>  1 file changed, 10 insertions(+), 13 deletions(-)
>>
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -9197,20 +9197,17 @@ again:
>>  	/*
>>  	 * Qgroup reserved space handler
>>  	 * Page here will be either
>> -	 * 1) Already written to disk
>> -	 *    In this case, its reserved space is released from data rsv map
>> -	 *    and will be freed by delayed_ref handler finally.
>> -	 *    So even we call qgroup_free_data(), it won't decrease reserved
>> -	 *    space.
>> -	 * 2) Not written to disk
>> -	 *    This means the reserved space should be freed here. However,
>> -	 *    if a truncate invalidates the page (by clearing PageDirty)
>> -	 *    and the page is accounted for while allocating extent
>> -	 *    in btrfs_check_data_free_space() we let delayed_ref to
>> -	 *    free the entire extent.
>> +	 * 1) Already written to disk or ordered extent already submitted
>> +	 *    Then its QGROUP_RESERVED bit in io_tree is already cleaned.
>> +	 *    Qgroup will be handled by its qgroup_record then.
>> +	 *    btrfs_qgroup_free_data() call will do nothing here.
>> +	 *
>> +	 * 2) Not written to disk yet
>> +	 *    Then btrfs_qgroup_free_data() call will clear the QGROUP_RESERVE=
D
>> +	 *    bit of its io_tree, and free the qgroup reserved data space.
>> +	 *    Since the IO will never happen for this page.
>>  	 */
>> -	if (PageDirty(page))
>> -		btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
>> +	btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
>>  	if (!inode_evicting) {
>>  		clear_extent_bit(tree, page_start, page_end,
>>  				 EXTENT_LOCKED | EXTENT_DIRTY |
>>
>>
>> Patches currently in stable-queue which might be from wqu@suse.com are
>>
>> queue-4.14/btrfs-qgroup-fix-data-leak-caused-by-race-between-writeback-a=
nd-truncate.patch
>>

