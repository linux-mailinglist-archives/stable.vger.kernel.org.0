Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320E6285BA1
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgJGJL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:11:27 -0400
Received: from mail-eopbgr10115.outbound.protection.outlook.com ([40.107.1.115]:54338
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726670AbgJGJL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:11:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJzSWrWw4B2QB9+bq+UO98ab47cuceo9nPQVrjnYC6tFl/qdXoynwl3z6J2ke4vIrZpbQRMZbjom1Td06DvTLBSZpiCATOPg+wnjTMHhP+9GWnCnq/eBOxbICJ1UsnP3jtJa8hynNabrMM8Fajl0vrQN46WST6poyUA7Lx1k5+amPcUKLsse6bUhs8PvhfsD4Sc07yTW3Cerx+zkrQ1z3u0attUoXcRQrSYvkNbPm/o4eI+HFAPnjX9D8N6Xr22HzUtwZPQt6QKP189ACsVm+qd/z9OhxmLTjpiUixiG5DyKFlE9Cvbz1pd2qP+lCNQt1GqWNgyzy0dHMei1gofgSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IH31j7CzgDNeTiD3O+tKa6Fqj7McHBm88QcqBkKP8I8=;
 b=bYYob/YYWRQ8QUimQLQs1FdLNJWigGShuFEclyBVon4C5YH9O7LFZgEgkwfkeyJdeBaVnDYuEw7u/AtBf7VSHBuzIHWKrsfW4A99lqvJRc+gxtiU3QafBnUAonTS1FZ4F5l2t/j7GrZpGMR3dTpoSp8PiKZGgF1PINOggM6CRQgN12coAsAWOCz4pUenuonES4OVrgxlXdOV+/q8DVR/CCg/f0D6Adm5Gu8xfEHTNIknbkjzZYm8lLv/9dy//nQC6RU4QZP+tsPhiOIgl4DUyQZcxufc3B+EGGtm2h4Qp9PcaBfJ9bKnSofsEkdr4KJtKJVXq0iNStbxpxZBJvub/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IH31j7CzgDNeTiD3O+tKa6Fqj7McHBm88QcqBkKP8I8=;
 b=RU+NNRxWX9PdnRh6/0+6ndku2meCJfjvtcssOPgKAOii9B9zGfbzjD0qkRrodCC41VDSzMlmcvfGAY83pURXy2Dq11cWgbvWXajARfWrTBjSFWZYE9mzg1LNMjn9naViX3lZXPHPec+Fox4DfS3OuNxzsCyicTMlWfPBpH2vG0M=
Authentication-Results: nokia.com; dkim=none (message not signed)
 header.d=none;nokia.com; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR0702MB3666.eurprd07.prod.outlook.com (2603:10a6:208:16::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14; Wed, 7 Oct
 2020 09:11:21 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f%5]) with mapi id 15.20.3477.011; Wed, 7 Oct 2020
 09:11:21 +0000
Subject: Re: [PATCH] mtd: spi-nor: Don't copy self-pointing struct around
To:     Tudor.Ambarus@microchip.com, linux-mtd@lists.infradead.org
Cc:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        matija.glavinic-pecotic.ext@nokia.com
References: <20201005084803.23460-1-alexander.sverdlin@nokia.com>
 <f815c4e5-eabe-af3d-efb6-87000f5ba411@microchip.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <ed864816-d363-71e0-c0c9-649486727e29@nokia.com>
Date:   Wed, 7 Oct 2020 11:11:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f815c4e5-eabe-af3d-efb6-87000f5ba411@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: HE1PR05CA0248.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::24) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by HE1PR05CA0248.eurprd05.prod.outlook.com (2603:10a6:3:fb::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Wed, 7 Oct 2020 09:11:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 068ad964-683f-4018-0ddd-08d86aa0f54b
X-MS-TrafficTypeDiagnostic: AM0PR0702MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0702MB36669794521F79FBB1C6EB1E880A0@AM0PR0702MB3666.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHbVdsXFzcQISABsUBl9/N/8mdb6+j1RpAhFVcHyBEf2hk0aOoAzyr5IwWNxXz4+uXH2EoyqyjKbXOJLWGcEzWwMSqWbXG+2CXZDW13UXyqJ6hccVs0+QFAW7b4gRa2hsPGedrJOyk5mZXmBueuC3CERV0YTt8YEUylpC4GzdObLd/xux5iGoLz429jULVFFlxWiNRC/3yn2x9tK8L1ptszJ5YdGZpCYazsY7ToN3QbR2TN0X5xSjBA2W9iqoI+i1kFuMjgstSx1SSTdoGOHFEygHC2n/LRjpnW3KEOvh8t9FcvO4yWK9ZMx0mhB2QBVS0weGUpI3Lr+wV4HRsQw11TK7UDpTwVVQ8lZUCr0FLJoEQ26PYFghN2neetIptoo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(478600001)(4326008)(2906002)(6666004)(66556008)(66476007)(316002)(36756003)(31686004)(66946007)(5660300002)(6512007)(83380400001)(956004)(53546011)(8936002)(44832011)(31696002)(107886003)(86362001)(16526019)(6486002)(2616005)(8676002)(26005)(186003)(52116002)(6506007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a1uYRICdxjLsJpOaFAgVtSWZ6lkwOujeDCQ/Nd018Z0nkbRuwlbYDhSTgOR5B8XLc1DXhL27rEyqlFVfZe9GJt+5jeL5RCxZh1eKOuAlWxnv9kmz3EybuBeeJBakQoOIKcslaKm/qUhqq6uZzSZfpBP+bm2lNBrK0E9TqSsXp1SfFHie1rqz8u3oGhUzoX+UPFD2wLqd6bX0HaNSsqbVSGs6tIlVbdCi8aMDDBY1AXU5HgCI2LoQMrgRbTdXZeuWRJjYqyINE/vhXWIPtJPwRjRdOMmfIa8TQQVniYSDZW6r7wyI0r/qWasvrky1QH6MUhWbUTV7vK7Gq0Z0igr69M0+CGlYwpS52v5GjjBLA0+11GKa632CZDuZSt+d5ZXCe0o6LJhV8yO6PI/aGpP5sHSzW1LIzenMMsbdCCqZzgAPgxS5oIueW6wBibSysMjzVAG1mnfnP8JOo6IiiMsDF61lDhB5hAaCZAq/2VZoMqYb7cLjR1l8LMPOEF1JgtbO+WDpMFnTqgsnLluxtqz8HeR6rypvDxHEUTLc4AFGYjVqNpsj2uMbyGfpkv/u8H06KajP1Zqfgcaqdt1F3fX4VLOfKLki1PS6mFJ6I2EhcprqztqslH28f/z2m16Mo/7bpJoWBcvuuNjBe4JiMn71nQ==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068ad964-683f-4018-0ddd-08d86aa0f54b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 09:11:21.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB/0ouA545FfQPWrd4fMcI0R+SVv3KPC8kTzHL41cbAtpZrKLR+73GQirjcDJmXwrXC8v53ukQQ7UvaiFx5xfatFrwHTbSS+o+AbFNr5FLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0702MB3666
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Tudor,

On 07/10/2020 10:48, Tudor.Ambarus@microchip.com wrote:
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>
>> spi_nor_parse_sfdp() modifies the passed structure so that it points to
>> itself (params.erase_map.regions to params.erase_map.uniform_region). This
>> makes it impossible to copy the local struct anywhere else.
>>
>> Therefore only use memcpy() in backup-restore scenario. The bug may show up
>> like below:
>>
>> BUG: unable to handle page fault for address: ffffc90000b377f8
>> Oops: 0000 [#1] PREEMPT SMP NOPTI
>> CPU: 4 PID: 3500 Comm: flashcp Tainted: G           O      5.4.53-... #1
>> ...
>> RIP: 0010:spi_nor_erase+0x8e/0x5c0
>> Code: 64 24 18 89 db 4d 8b b5 d0 04 00 00 4c 89 64 24 18 4c 89 64 24 20 eb 12 a8 10 0f 85 59 02 00 00 49 83 c6 10 0f 84 4f 02 00 00 <49> 8b 06 48 89 c2 48 83 e2 c0 48 89 d1 49 03 4e 08 48 39 cb 73 d8
>> RSP: 0018:ffffc9000217fc48 EFLAGS: 00010206
>> RAX: 0000000000740000 RBX: 0000000000000000 RCX: 0000000000740000
>> RDX: ffff8884550c9980 RSI: ffff88844f9c0bc0 RDI: ffff88844ede7bb8
>> RBP: 0000000000740000 R08: ffffffff815bfbe0 R09: ffff88844f9c0bc0
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000217fc60
>> R13: ffff88844ede7818 R14: ffffc90000b377f8 R15: 0000000000000000
>> FS:  00007f4699780500(0000) GS:ffff88846ff00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffc90000b377f8 CR3: 00000004538ee000 CR4: 0000000000340fe0
>> Call Trace:
>>  part_erase+0x27/0x50
>>  mtdchar_ioctl+0x831/0xba0
>>  ? filemap_map_pages+0x186/0x3d0
>>  ? do_filp_open+0xad/0x110
>>  ? _copy_to_user+0x22/0x30
>>  ? cp_new_stat+0x150/0x180
>>  mtdchar_unlocked_ioctl+0x2a/0x40
>>  do_vfs_ioctl+0xa0/0x630
>>  ? __do_sys_newfstat+0x3c/0x60
>>  ksys_ioctl+0x70/0x80
>>  __x64_sys_ioctl+0x16/0x20
>>  do_syscall_64+0x6a/0x200
>>  ? prepare_exit_to_usermode+0x50/0xd0
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x7f46996b6817
>>
>> Fixes: 1c1d8d98e1c7 ("mtd: spi-nor: Split spi_nor_init_params()")
> I think the correct Fixes tag is:
> Fixes: c46872170a54 ("mtd: spi-nor: Move erase_map to 'struct spi_nor_flash_parameter'")

yes, I think you are right regarding the exact hash!
Thank you for checking this!

>> Cc: stable@vger.kernel.org
>> Tested-by: Baurzhan Ismagulov <ibr@radix50.net>
>> Co-developed-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
>> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> ---
>>  drivers/mtd/spi-nor/core.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
>> index 2add4a0..cce0670 100644
>> --- a/drivers/mtd/spi-nor/core.c
>> +++ b/drivers/mtd/spi-nor/core.c
>> @@ -2701,11 +2701,10 @@ static void spi_nor_sfdp_init_params(struct spi_nor *nor)
>>
>>         memcpy(&sfdp_params, nor->params, sizeof(sfdp_params));
>>
>> -       if (spi_nor_parse_sfdp(nor, &sfdp_params)) {
>> +       if (spi_nor_parse_sfdp(nor, nor->params)) {
>> +               memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
>>                 nor->addr_width = 0;
>>                 nor->flags &= ~SNOR_F_4B_OPCODES;
>> -       } else {
>> -               memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
> neat!
> With the Fixes tag fixed, one can add:
> Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>

-- 
Best regards,
Alexander Sverdlin.
