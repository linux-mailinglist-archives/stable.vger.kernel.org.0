Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8404741DE
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 12:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhLNLzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 06:55:01 -0500
Received: from mail-bn1nam07on2071.outbound.protection.outlook.com ([40.107.212.71]:6622
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229648AbhLNLzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 06:55:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7zmERrYXcY6cxCC0U6rz7krvdt/1hgayB+bknhWqI8wli4C8VnzDTSfujdw3rcJKecVlpVt+qclCsr5Zv1tQk4e7egA/1LmYlXvYyhDn1pFvNLv60Nb6EMc7QL5rYP3horBdeXa1hkmKOKorN/K9wilxYRRYAF7cf4biitVvW0bsy6Ob3pPsxphA7hJ7h8nFkT9mqE+C++M+QmXuvwk5UP9dgtJhUkBZPVYN/P/PHqBsqB8B5GGKcfK7i0NkzhsWyb7wIi1QKxdxbBGDKG+SntVYBYMol1yjlFbNQxrwrnWj+xwqI1Rxc4Pg1zk5FXUoAyajb8KfqAiAhZYC7az2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzROYXc7j3KvCFZsd2iIfI7g8sfZa2BUS70Tu/VUUuM=;
 b=J8N5vuUOqLr8wIgN7bBbeYtqzk4xwHOV8rfmf4W5T22ICRNJ/nuo+N1Jk/r7wl61oTVgDU4uaXPhmLusDlOBP8RTam+gjpCgBuiSjAY9coSyFMYi7pnBum8rmwmipoI3EyeDs1xKVlI4mChXRBtmxuoe/P9qQvKxB2IS3DT34bVV1KlNRQ9Ml7SNzl36ZhLAY2uPiQnTBFIKqUPmZ6aRlvljajTJVAcgdqwOSBrDDImSjml7tWTfw8Sl3rm41Ys0OrW1KCo7tgjomFBykAlW4vVVPyagb9H7Q4mHmyjXZDqKPESN18uhkAj2hcl3ro3IUCiBrRzCgo6qeZsdVal90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzROYXc7j3KvCFZsd2iIfI7g8sfZa2BUS70Tu/VUUuM=;
 b=Zg9BXRQc5e9oowNTzz1CQsNQxuaWRyolZ9SM8WAbLxdpScw80iD9YYgZZXitBRTIHZkkbhCFm9fMYOeQqFHnOquFhPYnrkXxp2waq+6jZgOBTzIJ2jAItMD8j3BBh6o10zhwuLyjge+ry/dMYJy6wso7TIvG7fZcaRNysuwQ2b4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5101.namprd12.prod.outlook.com (2603:10b6:5:390::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Tue, 14 Dec
 2021 11:54:58 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Tue, 14 Dec 2021
 11:54:58 +0000
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
References: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
 <YbhfWHTL8Kobq9vv@kroah.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b50c83fa-ada2-23e8-c797-767190c08934@amd.com>
Date:   Tue, 14 Dec 2021 05:54:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YbhfWHTL8Kobq9vv@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9P223CA0015.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 11:54:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad2b36a2-01c1-4090-7d0e-08d9bef88d6a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5101:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB510152CDEDB16842792651C1EC759@DM4PR12MB5101.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbwNFNtoGjrrROXd4BfC3tNxcpuzKl77ytdG68Ghgsb5wptXVB9C4fTLAs/rgXSB46E9Ame+YuSn5X1mPDU1/8FEl4LaDfd8Xu2rgM/x5t/07Bz/cUTKidO7mzn71kLiwQSEKI3AK9DNerQ8bZuZ9rzdkhAmumJxgH7KGAFpkZvEHvGls6437HceZiGgPgT88RbIbvGAOP6vjyo7pLsFL3Xo7zuzo3a+pqT3mOsSpk2wRWefmKVduEcUJpPgHspMErukd0umeCCmJCAgfgfiC5CGnQJk5Utt6HtGNiNYuyQT02F1hVJIcbmnxQ8Wun7p48e8sgqS2Jiwh+pSQ7oBstnLklwKfE6K3ib8M/1+cexD75X96j4KLcPgrWYdXJX2BNYLgEkCKrF/ihNJfrwZ8e/b842AHxZmWbP5YVgTXuxsK6YOjAnvAXxmmT4nqOZ1tf7yoverbkHC4s/xis9s3iBxC9rgRFwNE/7tVGz2HRAOT/xQuuwJZ51S7CqkpEe5YWRRoaRY1FSJInvwkib3DpJI53qx4vYlJv9Kih+SCe+aFTfoU/q8fZ6BwDLY7cr4dZH2L4LxxZauwtA0jFZaM76CY7qrd2cRmwXhOH+o+cZvXlzlBm7yW8X/30r7O40boQRAIFzL8XbvStO/GVwfP8AVJmaaMB7SAK1zEmES3WobDyRpFXAmNmL4Vk4J01qkrMFDGYa+ONf9dU+3Dj+2m15McJBkCMGCp2ur0Kn+7HRLG48FCXG9FTXN9YvsvjozzbnoyFacNEKzHH0uQVkfqFwxSBKGsuHAIErHza51VJKSk4JBuqUAKxTCBiuCnrosnK/bnG4Oq/hR/hGCfDdOLGn8oRDKnxGDWfNoF38oO915W+vUJasyRfXcD6m2cAAI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(86362001)(2616005)(66476007)(8936002)(4326008)(186003)(5660300002)(2906002)(6486002)(508600001)(6512007)(4744005)(956004)(66556008)(6506007)(83380400001)(31696002)(38100700002)(31686004)(110136005)(316002)(36756003)(8676002)(966005)(26005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGgwSzA1RThPR08zVHlSRExJL2JJYXNkUlljakQ1eWhxRGcvdUNkRFhsaFNp?=
 =?utf-8?B?RXgvY1JkRjFpdytZWXRPNTV2TnhKMWd6QXBOREV4OWRFbVFBU1puNE9HeWVY?=
 =?utf-8?B?cExsMzBqWWlteURKQVBHaGl3Y0N3d2RWNG9YSHFHZUtNVHY3eThZVDNwYlZU?=
 =?utf-8?B?L0ZUMjFMRjRudzRIQWlWSG1FMG1zWFFrc1AyRFc0TlE4ZnlhYVJ1NTdiQlB2?=
 =?utf-8?B?Kzg4aEIwK0gxWnpMKzUvVVdiQlBkQS9zdmZtby9keUN5ZXpROHB2WEU3WXp1?=
 =?utf-8?B?U2o5U1FoRitKbEs3SmtsdmhOV1c2WWRuNjN2Sk05anc5eDFrMlVxSTJZUlFN?=
 =?utf-8?B?SmJyOHBudWxYelBqL2lIMDAwWTlpQWI1Q2gzdng1M1hVd1ZkTHpaYU9YRjB2?=
 =?utf-8?B?YzRlanRJQnRXTkRmRDlBUGJldkxHZng2bkxOUXZ2WmdHeUlJZUZNWE9Mdm1S?=
 =?utf-8?B?L2hhVTBuaDNOR3E3a2g5VVdTVzN4b2ZPUHV1VzRVaU0rWXN4eFo3UU5KRlh1?=
 =?utf-8?B?QUp4WDRjVFJzM2gwN0J1WU5IeEtWbzM3bEVtVUFiRzdlcWRJczk5SnBuRHI1?=
 =?utf-8?B?SWJ6STZMdDFNajFDWmZsNDkzb2dKN1JLK2pSWXg5cllERTNMc0p5Y3BBa1ZQ?=
 =?utf-8?B?bnMxN09iUzZ4QThuZG1HVWR3bmpJc2c4SWRnM1Z6NElaSnByRmVJZVZDZi94?=
 =?utf-8?B?bkYwOHMvTUJOd3YxREFlSlJJVE1nSTU4bHl0WHZhcFc5ZVVPcFZkNXl2V3dK?=
 =?utf-8?B?MWswU2IvMGEyMk9JZEhtYWFRd3lpQ3VQOUJBSkpKaitON0REWm1nb0VZL3dT?=
 =?utf-8?B?K0g1QVp3dkpEQ1BQMTJaNyt5R3VUZGZvMW1ab2J0ell6RjRTZjAxblpnK3dW?=
 =?utf-8?B?U3hCaVhXODZuRHN4VzYxdGFQVDNIdC9tZ0JQMjNHdWRBanpLcW1WeXRaQjU2?=
 =?utf-8?B?WUtTNWFnOHRlLzM2V1VYY2o2bWg4NHNvMHQ2ZFovN2o3bkY1WWh1YzBKUnlS?=
 =?utf-8?B?NXh0dXoyYk0vSFp0T1RzOVBKUk9SWmpCTFlxY25XV1VCVnp3YnNud3lCeHJi?=
 =?utf-8?B?ZjVLN01Tak52eXB0a1pONDBNN09yazRYUW5vbUI3d3FIendYcUJXT1dVcys3?=
 =?utf-8?B?THJoaUhCUnEzNTdoaVA1ZXFveWNjSkE5UUlEOG0zbFJid3ZwcGlsRlhRdDVV?=
 =?utf-8?B?NXF5eWRNWUxxRVFYZi9jNWxLYXFNWkExMjNLM1ZYVWV4cjJVcDJENkp4U3Vj?=
 =?utf-8?B?NjdMN25IZkZHTUpMS2JPdnhJVDdpbVRxZTRMNFhUOC91NFJBMkRqS1hBWjQz?=
 =?utf-8?B?cmxOelUxdzRHYVcvYks2RjFTR2NvVmY0NDQ2b01HaVMzaEU1NEpteGZNaFdm?=
 =?utf-8?B?b2xBZE12NkdBNzlKVmRNdUpIem9JZEZHVzFOcGFNb24yMHFUT1A1QklBdFZV?=
 =?utf-8?B?QmdLZkpRbCsxQjR4dm9VTk9YOG9iQ2Frb3dacUpDRktZTnk2WnFNTzg1SEln?=
 =?utf-8?B?NHFabld0ckFONmNkbExWUmNnRGlHNDdBY0ZOSnlKZldGb1Z6a0pmZndnZFBM?=
 =?utf-8?B?ZENsSVlCWVhxNy91djFCaXhXeVdkR0tMUjUvNWZLYjZGaTE0eXFhWDBLMzhC?=
 =?utf-8?B?dDRkREVjQ21UZXJLZ3V0S2g5UXA4SG8wWmRzdHI5QkFESVMxd3RiRDFNWmRI?=
 =?utf-8?B?b1B3bFJlZVRvenFlTGMvalp3dkljMFFoalkyNE9qZzI0aWJmUXJydTBmc1F0?=
 =?utf-8?B?NGNqdkFHTHFrdDVsQlZFTnJtU0RPSXYvR0lmRDNaV2xMdDNHNklZaFFzelJP?=
 =?utf-8?B?bnlMN3pYNXRKdEtFU1lMOVVCZUVOWmFTZmlNRms4b2N5QWtTUFFDVlVEWHNs?=
 =?utf-8?B?OEFZazk3YTBlSC80SGdkRWdHWmlnZGRiMDJhT2dqUlFsWEdnNUN4aWQyYU04?=
 =?utf-8?B?RGFyU01lN3VVcjE4VS9Kdi9iUXQxcVBqRW5RSmdlWjQ2QVJRWERvbnFVK2E1?=
 =?utf-8?B?UUlHWCt1TCtackJhNEI3MHFOVVlBa1BGbk9lWjA0RTdqRGtFL0lVeFpJenFr?=
 =?utf-8?B?WnR1b0d0TDhSaGZtNHZzcGNMTjVIeENINzdZVnl2TTdRR0Q2czBTY1hjZWJK?=
 =?utf-8?B?OWpoVzFYMnN0UFcxU1podzNBS3BhSFV3cTh4K0JidFlqeVAvTUJ4NlpCTWxj?=
 =?utf-8?Q?JjzoMxlHUHOizO4KmG12dYk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2b36a2-01c1-4090-7d0e-08d9bef88d6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 11:54:58.5549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlyvuHlyTSbtYp4YXlFxk8weM4L2NVkQsU1XrOmfi6Sb+JsayUiz24MYZa1M5zN5dqqWOHtpgTzxyGDlzrHWyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/21 3:09 AM, Greg Kroah-Hartman wrote:
> On Sat, Dec 11, 2021 at 11:19:00AM -0600, Tom Lendacky wrote:

> 
> This seems to cause config warnings as reported here:
> 	https://lore.kernel.org/r/CA+G9fYsEQCjOi_58WcMb4i-2t1Gv=KjPuWa6L792YAZF=zzinw@mail.gmail.com
> and:
> 	https://lore.kernel.org/r/CA+G9fYuCFSbLMarXOnapUXN_NRgQMkjfr_rSTPjzBJQ-FT-Q3g@mail.gmail.com
> 
> so I will be dropping this commit from the 4.14, 4.19, and 5.4 trees.
> Can you please fix this up and resend?

Yes, I'll look into this.

Thanks,
Tom

> 
> thanks,
> 
> greg k-h
> 
