Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80BA442DD0
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBM3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:29:50 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:14135
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229530AbhKBM3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 08:29:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtaFAJTbi+fZJA5gf5fHY3gj/N1koBO/oxALE+1mlSyy/RrR8HHb+uxXzwliM07OKXV/Zpf7Nv92HT6KRH4LR0dpwa3oNDtlPDEg7kD26HAYmKd+mgoUg1BCzNynraGWtH/yLsLexhiIwwJhWG5XbTFEAVfUk9i0hb+KaUpELYyKDDzbVC0IInHzBh3Oizk24UI2YYAzNzVS1NUB4N8l9FCE5kLWfXgerlLpzLfsWyir9G94ndwPB9MmTtmoK6P/WtE9mW9KHe+fVvkuQsDIoPrqEv6DdtvtHX45zRD9KBk+CaPqC9P+fmdWdBLBc4KIKVD0iFvx0e47Aqk4ZFHGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVBo6kdx+3GCkp24IovF/tZ5ewvA1iBph25uKrtZz/o=;
 b=CVJJvMUh2pHypRvKYULUfOY3xyy7Mym6uPe6DjckFD5XxVW5tYI2rzfhrA0vNbstcRSAN2pVm+t/rQy4DLRqk/eUyXPqJKyg6LY477bBh39yrjifWkz0apAd2SxhImlVElb1974N8Kd5m1y84Ly1980SIacp5jTRgqtM1PBYd10o3MjHN9aaESBYVs+3EUkm6T2nmW9/QgPO9vicqZ28IAFMSPyiR+69wgWwkrcd6yHXXKaErV7pYqR4hICXKif46ICK+fo0bjdj+Hn1r7QU7NbZh0yGtLOowR/melO7JDj5LQF8SusTPxmTJ4zy1U/60tvyB5sFcHflPXRrdkn8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVBo6kdx+3GCkp24IovF/tZ5ewvA1iBph25uKrtZz/o=;
 b=XL181fyb3Ol1bNnkrhEvWSwZIhUFA9qDHKDxmGo/jv76rWbfiPlTdKuQdsWQzy9ZAyjyUwpdhuqsQk2dqCKGUCglpIYQfbfTNQRlZjDQYu8AI+wce9O8YR1/HIcZphtdxV7hlgi72J/TdRVZ43y5nhm3Qgldf/wDwPm0h/PXyqk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR1201MB0079.namprd12.prod.outlook.com
 (2603:10b6:301:52::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 2 Nov
 2021 12:27:09 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 12:27:09 +0000
Subject: Re: [PATCH v2] PCI: Limit REBAR quirk to just Sapphire RX 5600 XT
 Pulse
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Robin McCorkell <robin@mccorkell.me.uk>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Nirmoy Das <nirmoy.das@amd.com>
References: <20211101215516.GA554197@bhelgaas>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <c87ab346-ab44-1bc7-767a-e40a9c9f5cef@amd.com>
Date:   Tue, 2 Nov 2021 13:27:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211101215516.GA554197@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AS8PR04CA0020.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::25) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [IPv6:2a02:908:1252:fb60:2746:f022:81db:a2f4] (2a02:908:1252:fb60:2746:f022:81db:a2f4) by AS8PR04CA0020.eurprd04.prod.outlook.com (2603:10a6:20b:310::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 2 Nov 2021 12:27:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a13e39-af1b-4230-d8a0-08d99dfc16cf
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0079:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00796036FC3970AB6EE3C9E6838B9@MWHPR1201MB0079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: waUP7knay+zAVp0S2CbQVrLYBZ4gpi5i67nIMpeLAUNrepE/yC8RpI1KKRt0M+kM+ka5F6kxGMmeMyy633v1o41lkpsPpDR/z0F0MuYdrNHnZ4ip9ttbKYQ5/RCGZzInoksLDSNcbysuIDznCFf1wXQXlbrnik05t99bp7/P4Lmd1IIaWJ90D43GGl/x6BhAw0JquQEMHcIWw5pHnqLxb7uyVnMwUpSWMLVXLgp0TNf6PaKYlGcgCGLrKBOAzJUEeyzF3Ogk1/xS9lJk1BlGopwu9V23GCnTIohwYO4wDqauXgucQuJOwqVOqrBE12GT6jNxI3MwsL2zDRG9Zd/WzH50zqvNMAk764TCZolIiNtrNyI4P4BwG2X9hfWPsHcCqCG6745jMKC+rtp1XrDJn96Im3wdhVv1a66pIAwDykxhp0rzU/ys30qf7WlyaZcjWpolVGuSX48APeLigA93Gd3p423mlzqN3Uuc0cF7II5ACsSeZOze8JYYqUOXqk90JVJzdOAUVr0RfxIqw0rszquasrfCKC83fDCLBNWX7Asv20ad0dudfoJkCb1oH5g2F6BMHGp6H9LbB0yQS0fMWi3HQe2usNS15He7cLNvF3FgfyaK/KH9lip2g7sNAgPUTA0sXuwFV9A+WebSPF2ZP7vTf3vz3hBSMGgJqhNnoltTFvLhYFb1Gq5bkueTRCA5yta6vNYvorSSNCb76b1o3NsIBJY1KMwVFUMhVecauQd9waigeTxGrbkV81GakSaq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66476007)(110136005)(6666004)(2616005)(66556008)(186003)(316002)(86362001)(2906002)(83380400001)(66946007)(5660300002)(31686004)(966005)(45080400002)(8936002)(8676002)(508600001)(36756003)(31696002)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmNTdlQrY1BLNUJJT1ZSUERwT09QUUlnUkxtbzlpajliV1IxRGFVM0FpWWZB?=
 =?utf-8?B?NDhubVFHenlWMzNkWG9EaFQ5R25Tdy80bHBSVmJ0K3gzcjJtdWQ0ZlJFOG8r?=
 =?utf-8?B?aTZ2NWE1Q2cvc1ptb0JMWXR4d1BOTU9JMGJsWEIzMklaK2pPQm85MklPRmMr?=
 =?utf-8?B?aTlmaUNkZ1lMTjgwRDQvNnJpYVZxTE1aWDVyNmlvSk1rTHhiRnBiZkx1clhC?=
 =?utf-8?B?eVROS2R4djA1UXd0TVZ2Q29MUitYakpnN3hNUjd1WXNJdEk2K1hic1NaTmN4?=
 =?utf-8?B?YXBkZmtrL0UySVplVWx3SWYrR3d4ODRYK09tcnplM2gxeHZIaGcxNmtSRjRq?=
 =?utf-8?B?c3pBTE1OZlk0bzdscjNVM0dtTiszU0V2ZmFJZGE2ZVp6VzFGOGJScVZBWHdE?=
 =?utf-8?B?MHlQV3Z3blRMRTBZVWRtZktCYjRSbDA5ekZRN0Jyc2x5N0F4ZDBzaEpUbW80?=
 =?utf-8?B?Z2RYV0hYK0U5RC9iZjBGWG9DNnEwaVFWSE1ld04rQUg1akI5WG15bmtvZXNC?=
 =?utf-8?B?d3F3dDNIS3JNR1RaYTJ4WXk5QmtjN3lvdWUzaGszeHZDRWkySVB2V01xRXpP?=
 =?utf-8?B?V1FkTkRzQ3NUVWNIc3llRnRHblJESnY3VHBUMTc4dUlINndvNDJpVkR6L1cy?=
 =?utf-8?B?MU42bVExK0cwZG9Hdk9yODlSM0VBakVtQVUxcnB4ZEVnTDlYS1Yzc09FS1dB?=
 =?utf-8?B?ZHBuRTRNTCtRdUdiM2FjWHJmVExuditjUFRqc0hQaVF0bzJVWGpLLyt4VmFZ?=
 =?utf-8?B?ZnRaWlJwbmpPZ1VIQTN3bUF5V0JzUzR6UmJlOGhRNDFlMHdVbUU5TVFVZ2dC?=
 =?utf-8?B?UnlmN2lza2pMSllqSVlqMjh2Sk9YdDdJU2djQ0NHQ3hzbTZiaUxDRXpRVGZq?=
 =?utf-8?B?WEI5N1VFN0x6em1td2htbThSZy9XVU5mR1h4d1dQTERPNUJMZ3pwVjhFWDdv?=
 =?utf-8?B?RjFRUXZ4ak9aNlZQVStVQ1IzMmlFRjRBRVNEdGFZeHRoZUNWS0dEQlFxTFcr?=
 =?utf-8?B?NVVKeDg0bHppK254b0FZaVBWNG1SMnZWVVNoM1c3UmhIaEZQTVZVcU9mUjdJ?=
 =?utf-8?B?MjZnWS9SZkxVa3hjbmZ6cTVSc2YrbWMxQ1UwUURwLzlNb3Y2V0RsNlovRDEr?=
 =?utf-8?B?aGcyU1JPWEExdy9OUTFzUEE4cjNCbUpHdE9FbjRhd24wb2hJb25mSWU2dURi?=
 =?utf-8?B?YjdEdFVYWTBpNm9xRkNhL09DdE9teldraktRa3VOZlkrajNEbHFGOG1DNS9i?=
 =?utf-8?B?UWxPQkV4VmlKWTFkRnFXcjZ3VkZWd3VVYUkxYS85RGYzUXdKU2wzckFVSzIr?=
 =?utf-8?B?L2NaaTVVR0Z2YU41cXFCdXpBRElxZTVvcjJmSk5JUnFEajJsK1h4VFJadUhh?=
 =?utf-8?B?U2kwam9Ud1pkSDRiQnFxSWppTVdmRmprNHU5NWpmR3Fsa1FlWWIxaEVXUnlP?=
 =?utf-8?B?Kytyc3Vnc2FIaTlxakgwQ0RkN0hnLzBLb1NwVkV6RjZrZEVVa0Fkbzgzb1FE?=
 =?utf-8?B?aXBwdmxpMm13Tkw1SjZiaEhGYW52MnZZa2pRL0pFbDdvRmVOQU5DcUw1RXdI?=
 =?utf-8?B?QjZvZHhrNUdPYVhIS3JXV0k0T3A1d1RPRk5RRlpGZldLNmliTjdzRGJOT3J5?=
 =?utf-8?B?OC9PODZzSmluZFNqYmpQTEpzR1U2U0FXelpYY3dKa01ucHRzaDN0QWZUREt5?=
 =?utf-8?B?TjB3Z01OZUhWaTE3eW1QN01BK1pVVkw5N2wzUmNHcEF6cWFRK1RSVTd5SjRF?=
 =?utf-8?B?TnN3ZkNtY1Y3dXFPbTl2YTFlMDhtQXI0MkREU1Z0MjFwMWtYbVIvZFQxSkUy?=
 =?utf-8?B?ZWVaTUZreTNydERuUW5FNmhuR2J0ZzBSNThiaFE2QXBaRHRaQ0RQRHI4amRv?=
 =?utf-8?B?V1F3ekhmRzQxSVRNMUQ5UGs2U2U0MERKell0c1J4c3Q1bkVhdFoyRGh5Q2x3?=
 =?utf-8?B?UjU1OURTVlRPc09mM043RWhTMHNNdjdaV2R4aTBvamtiRmdQRE10dmk2VEdH?=
 =?utf-8?B?SXdMcWZiMGFzTDZUSno4VWQ4dlE5UWV1elFmdk9pZW5kazBxL3ZTdFFuN2VO?=
 =?utf-8?B?aFZncVZHeXF0OHFjK29CbDI1NngzTjRzNS9HeE5nb0tXYm1GN2RDMlp2Wkht?=
 =?utf-8?B?SFRpL0tHQmYwUTFybDlMYUdqSHJ4eStRRzZEM1JKTnJuSlpvOUZvREM2a1ZF?=
 =?utf-8?Q?FCGzdhRfUtzNjfvPNZa6uxc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a13e39-af1b-4230-d8a0-08d99dfc16cf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 12:27:09.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48SHLh2bVLVY2JLFSBvLIv0lVJtucX3OuBOZNo53CifGb75vz0Epe5/QfYvE1ebe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 01.11.21 um 22:55 schrieb Bjorn Helgaas:
> [+cc Christian, Nirmoy]
>
> On Tue, Oct 26, 2021 at 10:44:59PM +0100, Robin McCorkell wrote:
>> A particular RX 5600 device requires a hack in the rebar logic, but the
>> current branch is too general and catches other devices too, breaking
>> them. This patch changes the branch to be more selective on the
>> particular revision.
>>
>> This patch fixes intermittent freezes on other RX 5600 devices where the
>> hack is unnecessary. Credit to all contributors in the linked issue on
>> the AMD bug tracker.
>>
>> See also: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F1707&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cfa71c149d6084ca3254508d99d824b9b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637714005225516666%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Vu%2FVbyBEGrnTjqcmAkJDJHa1BbUICRkSB1Jfre%2BhDhM%3D&amp;reserved=0
>>
>> Fixes: 907830b0fc9e ("PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse")
>> Cc: stable@vger.kernel.org    # v5.12+
>> Signed-off-by: Robin McCorkell <robin@mccorkell.me.uk>
>> Reported-by: Simon May <@Socob on gitlab.freedesktop.com>
>> Tested-by: Kain Centeno <@kaincenteno on gitlab.freedesktop.com>
>> Tested-by: Tobias Jakobi <@tobiasjakobi on gitlab.freedesktop.com>
>> Suggested-by: lijo lazar <@lijo on gitlab.freedesktop.com>
> I'll wait for an ack from Christian on this one, since it doesn't seem
> to make sense to him.

Please just completely drop the patch for now.

It's really interesting that resizing the BAR makes the problem on that 
hardware more likely to appear, but we have already found people 
reporting issues even with the patch in question completely reverted.

So that is most likely not the root cause and we need to dig deeper.

Thanks,
Christian.

>
>> ---
>>   drivers/pci/pci.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index ce2ab62b64cf..1fe75243019e 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3647,7 +3647,7 @@ u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar)
>>   
>>   	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
>>   	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
>> -	    bar == 0 && cap == 0x7000)
>> +	    pdev->revision == 0xC1 && bar == 0 && cap == 0x7000)
>>   		cap = 0x3f000;
>>   
>>   	return cap >> 4;
>> -- 
>> 2.31.1
>>

