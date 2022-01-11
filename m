Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0605F48B0DE
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiAKPdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:33:36 -0500
Received: from mail-db8eur05on2117.outbound.protection.outlook.com ([40.107.20.117]:40673
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240480AbiAKPdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jan 2022 10:33:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmhw5JqIeVtm7TcCw/NFFTqwjqTNQrh6THgSBnKOSzmnuPN55gaFpOjdd7H6OlxhDaQIyWc4ExOP6wUATZxvZcm+Qn0rFxmQDFt/9O+YV/7TXOBRo7D/m7gpPfhgxEjUUWXvxCEEmDJIBKlXVTwSmFjES2fcLP72ODgC3rhERZAcXvhdsXduKFkzo2pyBv84iCzuIz2qkQolTw6k3MtDIPB/tG6Gt7sARCxMuJgpSRSMbsbmm7Va4XuOvxN3P97dgF+mlcwZ4OToJ7pvoYPy1EGHvS+sJeMNIStPIuSEf/Kxhst91IO7fp2Ag8bAahDkPbi4d+yEnerPq8DOjUY12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/sdxbBLIh5lDw2dJWXc6zgqfsHLrwQJr75XU1gFZak=;
 b=E9M4bev6FEKk4iqLAmkB7kQE5XK6l1xp5q1K3M0r8bfeDUPpC4nBWOpN8esLSlypANM0XnwRM7Xnk0UEwu774axm1zUb/rRjUF8Ts06eaFCCLJiZBp6Y/x/xwKaEpf8vjNk8AEUsNKTypP03ZNCtQZ1oLhTZcvYMmvEoSYzLlZ8cyLMERo6XHMx21W1xbXVXxTKGYJpSCDmtt6IFJ88xx1XmIwtbn5Nc+In80PmO5/GdXscQ5cLjiG8FBDoLpTjpcO0uVvJiOpUlb7Uohe6/ipdFnQLU3hGgbSan+CsRJzRBBiRAWKIoCS7BiI5tP+iAUp6/0c/3DkBMAtK1lCgIUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/sdxbBLIh5lDw2dJWXc6zgqfsHLrwQJr75XU1gFZak=;
 b=AIwtV4zSFRrUTr37zuusqN+Mx1iu0dNlwM3W+Z79M+tsq7HvvmIvVIdzgK6I6oFftlmld0f2Wgc+LZfyKE7OJB0bkC4yPNnp27Bz3xYL5zsJcLmQA7BttVNhrv/Vr35x1Wz58PnL4fzJP8LUJiIHU+/IQiawEWJ/p15VcfDrzAs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM4PR1001MB1441.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 15:33:28 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b85e:6bff:84d3:e825]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b85e:6bff:84d3:e825%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 15:33:28 +0000
Message-ID: <9af5a4ae-e919-a545-809d-451217cf40f5@kontron.de>
Date:   Tue, 11 Jan 2022 16:33:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 1/2] Fix corner case in bad block table handling.
Content-Language: en-US
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vigneshr@ti.com, miquel.raynal@bootlin.com,
        Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>, richard@nod.at,
        Stoll Eberhard <Eberhard.Stoll@kontron.de>
References: <cover.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
 <774a92693f311e7de01e5935e720a179fb1b2468.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <774a92693f311e7de01e5935e720a179fb1b2468.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0072.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::17) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88b16c98-db3c-43ad-0f58-08d9d517b738
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1441:EE_
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1441641C6F7033062200DF48E9519@AM4PR1001MB1441.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnJgHNvJaAOOvaNPLzaQwEN9+NesV0MFQ7WzhrVY4cICcMnM/8AQzS440rtkn36Lt/fqdSqFUlLdgZRt0gsRVxNJeXyPDpEk4WSzV+JcaeL0vft65/8jgD7rDadajWdmCdcwWW+tc2uSER6yXV4LfXbFK6045zsv0fDwfPg3vePnN5f9PuZAFc/+n/GSSjJdpVWaL3pBYA630YnLThJyu0ZKM9vkJcp/TGLwd712GcDyVnXOFjp3VpXjVt1OG5U8oSt3MdeXIvW8yB/fKWXPysGgcCyQ7eCDrtB3hPqrtQplECRZeHUW+7Rivp5lkZtnZ0W+PiC9YXvmYdjIEtNJiQ0sqR4ZxEjIMgdsykAi+FNKCD8iUtCwGrSEegGMh0Hn8yzlTJ3LRxbZJMufghCAvsl0bpcAcm4Gy8Sf1kZwDGzSPlyVHFGvkwDoYJEbfcH2PY95pZh87xIRv9Fd0JPznpWk5rlIMuUNZiVWTtZMDRJ590iw5wz/nxtZYsa8bNz3eIfqU05+pI1NiW8rh42/BsHkpntiAFcNngHLF2LWszl/bgD4zMAwpHD7AZl0m3emYty+Nygs7xR3qrwUc1IWTEpnwZV6k3+P2ESFxMii18z5kR9wLw1CFYySCI+zkwou2LTZ3j4/vP0rAB2CcV2VbpTSwxNeHz3LaRuaLmfKan9g3M+s8SBIJAC7K35LBHROAlG7LiU2NdsnioL+Xu5WGmQr8K6rSFnB9uJxC/B5HBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(86362001)(8676002)(5660300002)(2616005)(107886003)(38100700002)(31696002)(53546011)(6506007)(4326008)(8936002)(44832011)(83380400001)(508600001)(26005)(6916009)(186003)(6512007)(31686004)(2906002)(66556008)(54906003)(66946007)(66476007)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2VoeURWTXd6c3l4N0MwUCt1NkZRV283aGVzY0hSc1BWeEdSS3FHTTRWQ095?=
 =?utf-8?B?WjdiMDA0MkpKTndDMEhGOFdhRHh3c1NGQXJ3REJxL2NGOXFJUjJtUHliR0hB?=
 =?utf-8?B?YzhqRFpFcXNHL0U3dTErOGRER0NqWmgwVTR2Q1V2Y3MzRnkyTGVHcHBwSTJN?=
 =?utf-8?B?anlHNEk3aDhmREk2R1RaT0tOVE9MaEZLWS9janZNY0pEVzJ4ZXJXZk9RTVVJ?=
 =?utf-8?B?WTVrbXdIWWdQaGVwdkJhREVuZ2ZlRHdLWUhZMDNUSGRzMDg3S1o5S1BBTXVN?=
 =?utf-8?B?dW1xaSszQTgxOWFzcDYvYmxmWXhWK3g1SXFTazBURXVucE4wcjJmZUFGenJP?=
 =?utf-8?B?TGkwVTNqaTNlMUQ2QUlBNklYWkxsckpTM09odW13dk5CdWEycHMzL25NUk5o?=
 =?utf-8?B?NWR2b2g3Q1FPS0tVMGZVMEFNQlcwSDJiZzhrOWwzSVZnWk5aUC9JWGZPUkY1?=
 =?utf-8?B?bnZGNERmRkJBZHZ0Yk9wZzZRYXQwR3dWUGp4bjhQRGZsR0hXdEJXRUlSSVhT?=
 =?utf-8?B?L1dGR1ZHN0l3dWxrVWdwblliQU85QkFsOTd3ZUY4c1k4dzRuYitKUTFYRUcx?=
 =?utf-8?B?TmVLay9DQ3dkcTl1cFQ1SGFuS2RxbFQycCtnYVh0cGYrNSsydis3WVNIU2tW?=
 =?utf-8?B?dW5jUFNjcDVJdVFDSjFRMlZnai8zL0F4elZHenFRM0FxbGlyWGRWRXRmN2lu?=
 =?utf-8?B?cnA5Z3hIZFhYUWlWa2NyY3JZLzlucERmeFVSMFUvYWlaQ2hRbDFObVlYZzl6?=
 =?utf-8?B?cmZiTkRZRXNvaWNTT2dLWitBOUZMY2R2Y2xNTTQ1SFF6VFVEa1QrNkp4aEU1?=
 =?utf-8?B?MzJ5bERHdUNLVE1YamRwWTJCN05ESUlLVnRSNllUbEhMYmxTOTVpTFZyekhh?=
 =?utf-8?B?MVZJMG1iMXRXUTZKWERWYlU2MjdVZTl6OEQyZWJnaU82c3VBOWZvY0d5citI?=
 =?utf-8?B?djJWS0hhWWJLcE52dE54b2g4Y1QxeTJRL2IzekErV3F4MFA5NFQvMDVMaFI1?=
 =?utf-8?B?SXdGNW0wSjJGWmRNUGs4NHdXSHQ4L1l2T0daQzZ1Tk13VHZjTHVUS09rTHNS?=
 =?utf-8?B?ZjVBT09OTXBrU1VGdHdQZUl1Y1ViL1F5R3FBeUZIdUF6dU5kbWhReHpPUFJB?=
 =?utf-8?B?TlRpOFh2bm1EK0hiMjRsek1FTTR6SmJ0N0EwR2FwWktXQXUyZmpFdGFNdGc4?=
 =?utf-8?B?dHNmTHB3SkZkelhLaVBDVWhMWnRTdHg5VmV6TjRJTFhYMG5XS1hSQVpWeWhG?=
 =?utf-8?B?WlM3bFR1dGNGbnZ0ckV5MThOZlBPTm83S3J3Tkt3MVZGUElKNnhzSk13Y0Zh?=
 =?utf-8?B?ZlVhcHlkNTQ4cVByQU1HL0VnM1p3MUNFdklVK2JqR3FEZW0zelVTb1Fwb0lN?=
 =?utf-8?B?RUdIQ3BDRms4enN6TTVURVUxZHdqV1RiODhTWXRJU0hwT29JbnMwY0tQYmJq?=
 =?utf-8?B?K2MwQ1FoUlpzRUw3WmFuVzNiNlllWThGWS9EeVFuT0hWeUxzOHJ1L3ZpU1l2?=
 =?utf-8?B?dngyMGxLZ1ZLYVpZMTlweGZURG1XV1FOMVVPaTVFMHIyTytXMHhTc2ovUHli?=
 =?utf-8?B?cURGUnRDRHJ3M0hWM2taVXY5TzNWTDNKYStMOWpmaVFEcndlZjZDZmo0NXlt?=
 =?utf-8?B?eTZieStYaGRwT2ZHT3ZxNnBnQkxDU1RHbjVybWpnWGdVc013WjVrcDkrQ0NU?=
 =?utf-8?B?dHk4WHEzMllDUGh5MzdDQ2ZwYTQ1R2NnYjdyUmt4bHpUbW81M3IzZWFiWlNU?=
 =?utf-8?B?Y0hMeEF3VmVxZVR3RGJEQlB2SXlPNTFmRi9EM2lMVDloY2VVYVBKYWZBNnZo?=
 =?utf-8?B?TjJySUttTzBRbGNMaUNPZG12TzJ6aVE3NHhpVWViczVQRmx2dzA4cCtqbFZN?=
 =?utf-8?B?KzZ1L2ZSdy8wdjE1R0hVQVBNQnRaVkxQQ0w1N05HS0g4cmxhVTZJaDdRNDBn?=
 =?utf-8?B?QWk3aHpYVTdjNzh6bTZCR0NROS85b3ZHbGFJTy9DcnU0SlpPVkp2MWhNZGVW?=
 =?utf-8?B?TTlxMTVrbEgvMG5ySVkvVTF5K2g1azgvWE40OVh1RWYvTVBPa2x4UE8zanFZ?=
 =?utf-8?B?N2djd1VocWhZbDVJZ2FnS0VLNG9EdFJ6MFExZmhoL1Vsd3NiWkRrTzIycktH?=
 =?utf-8?B?ZCtJUUhqMmhtMGdTRHEzZm0wRDF2em80VjNNeElIUi90cDRiZWVoQkxjd0Jm?=
 =?utf-8?B?UnpUQUNBN21MQ2NSQURSUTRhU3pTenh3bUU5TUlkZ2hXQkFzczlxQ3p6QWVj?=
 =?utf-8?B?ODBjRDZ1aldlTlp3WUFMWXZzTmxnPT0=?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b16c98-db3c-43ad-0f58-08d9d517b738
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 15:33:28.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3emPSmfpTqsGVxnqwW/XWlYHiwz8PxROv/+MVaRKOisYpVrxOaCM95ujFg1ZVo/oYK44/JEDVzCpPjeOmWGgsfDgdvX7OSyKbEzawhEU4uU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1441
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

On 06.04.21 03:47, Yoshio Furuyama wrote:
> From: "Doyle, Patrick" <pdoyle@irobot.com>
> 
> In the unlikely event that both blocks 10 and 11 are marked as bad (on a
> 32 bit machine), then the process of marking block 10 as bad stomps on
> cached entry for block 11.  There are (of course) other examples.
> 
> Signed-off-by: Patrick Doyle <pdoyle@irobot.com>
> Reviewed-by: Richard Weinberger <richard@nod.at>

We have systems on which this patch fixes real failures. Could you
please add the upstream patch fd0d8d85f723 ("mtd: nand: bbt: Fix corner
case in bad block table handling") to the stable queues for 4.19, 5.4, 5.10?

Thanks!

Cc: stable@vger.kernel.org
Fixes: 9c3736a3de21 ("mtd: nand: Add core infrastructure to deal with
NAND devices")

> ---
>  drivers/mtd/nand/bbt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/bbt.c b/drivers/mtd/nand/bbt.c
> index 044adf913854..64af6898131d 100644
> --- a/drivers/mtd/nand/bbt.c
> +++ b/drivers/mtd/nand/bbt.c
> @@ -123,7 +123,7 @@ int nanddev_bbt_set_block_status(struct nand_device *nand, unsigned int entry,
>  		unsigned int rbits = bits_per_block + offs - BITS_PER_LONG;
>  
>  		pos[1] &= ~GENMASK(rbits - 1, 0);
> -		pos[1] |= val >> rbits;
> +		pos[1] |= val >> (bits_per_block - rbits);
>  	}
>  
>  	return 0;
