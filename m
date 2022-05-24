Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB81953254B
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 10:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiEXIcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 04:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiEXIcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 04:32:20 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48E85A08B;
        Tue, 24 May 2022 01:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/1bZ5YoiKpA1UZU41hY8G4povdapXg6ciu3dYNaQLW5OxZdTyVQK0BD+1jcnNT4NgKWzLjmLpPd8uxIrRCQEvD715l+Idsf2H3ve7CM5fU/+QA4N01UIc6rqO9iv9HaR0sgLLo+o18Ty6m6S0WqRo/wSoguwpHGQSzvSA9YazkwbF4UZ/pEOSWDxi3ZTcPScpqJyFhjUc4VMtlVJdV7CaLQLmS/a3BnGRHXK4Zilpx+AfSS7ti1wbI0gZCWs9fEev8LybUsY2h3FQd6qNLtTVHOLRMpH7qLbgMB9n4urBDpa8D+vwEJF+UK+O0dp1mWec4b3gTaseSIYkzAxKFnBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sljT3AYcUx8FrqWUCfVxc/Tw7HgZupyvceZVECnWrc0=;
 b=AumV/5nzFby0NgpQ2qYSmOMLz7JNNw0u8meECWvRkFTOTSR02N5wmBiQqGo+K7/Y7moWcY+oA5LCNckqC/I2s2UeyBSCmKQTQN69a6M7H/44nKph1sovZmI7VQg2YGr+HHYjbHWXxomv3xo4ZlippTVBqibE83d8ayN9CrdJkzHQqmTtpf5sqcg30ODW6PDhJCC6BJxRC0tvKv/ANnjSWyIrn7g//CAwdIlyIaZa63OldWqS1Hh79jqozOM4qxBeugVmpWy51wpHb3roYgK0UepMJowRgBBgRfvdaWmJOOjb8x1PmmvBWObDSSQatQaIhm/I7qIrskjo0M23NC4Wpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sljT3AYcUx8FrqWUCfVxc/Tw7HgZupyvceZVECnWrc0=;
 b=Aji0WhzGd+dLdMVo9e/kzJrQYTL8rKk+y5bu2D8kq06c6X54qJ1ZZvMLCbINxUkX/fV0HGJZ19HQTS50niM7B0Xx+90TaW+UPEUXDXrTm58moKfyH4xGA7BBltdvFFxbyGliDC3B9meAF7ETAPraHFZOt7ydAmzrCbW6ORIJ33IswmJy5Opg35OOd386KgyHthduTxMp3DXOW0lS02h0M+sJWltNagjgqhJobZG8Qk2XrEqZktqNTJWnY6pRzMxlGuq28AqEDRHoExS03+pxW0Xu9J3xUgjTC9zVZgjUKKSK1t5bmB0sxTre+GiBPVHw9bBDOWe7tpidhbtuEAlYag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Tue, 24 May 2022 08:32:16 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a4b2:cd18:51b1:57e0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a4b2:cd18:51b1:57e0%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 08:32:15 +0000
Message-ID: <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
Date:   Tue, 24 May 2022 09:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0218.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::7) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c27f4ade-9958-466e-1b56-08da3d5fe84e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB251870F70B300BB1440FD36FD9D79@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HELn/jHSsB8CIN3DG++1qcFqrydrj57kUxOjtinli3FDlK8wrZz1gaiDgLv5O3B58s5BXKJod0feoeWqrdbQFFcCv79UhRFvTuXywztsmPXqRPg/0Fao/aOUmcwGl/rD8OWxnwEwXXxZeh5u6IQShpEQJ3bQUt17tYqMF4SkCkO79enwNuWrV3OPzmlNBU0Zl2RhbTgc0KQNLIVLEazUULaF+Iw4VA7xvL/acAMXbJWxB8bFBCyfcQ/utKn4awYW+rif1eU3Z3EOhBlNiLkImdjmptAHLyQ+ky1cahV/TR3V2u51c2vxNdSxCqDKaKLg4zuGmD5tOEtTzN71CRI6eIR0DvmhdqgHQjj48YK3gKhdpVtoNo21ObVkD/T+IL4S2dARWxY5SneXusH9cjnOb2DUdVrjC+cs6vefCXgLvucG3ntsdSCc2nxpvV9VIZx1qNSv46H0gt5ni1P5acdgWyhWqvBPZsjR/EQnUOit9O8zc8DqDR/Vok5IxWp/HbTaIGXErtu9XeQfFfN6thM65bJHxhqcvmCQ0RRaEBng9Fjm7bal4bAXqH9t2To3oIhvfpStn3xd5T/cYb8CBtUwvNfwIb2ybBy9akoKKM+8auKs/wwEAwZhXQNOz9eRDtPd8FapJldC+VMsdu2ByED1+N0b47y+0PHMXbzOO1/cFpE6oZ81guskpSlJVM10S9KswlU3Pt7W2P4DHFd5d/VujGDbpZsj4OjUcZxMBFZG6WlY+c5huAedOTFkuEkRbRU9rJe9YwBiQOPr9LT5ajBCeod0jyQYkO0BMtpGODkw3KC0kKok+bJcspZ6SThVZWIe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(6666004)(31686004)(26005)(6512007)(2616005)(508600001)(36756003)(55236004)(53546011)(8676002)(6506007)(8936002)(66556008)(66946007)(66476007)(4326008)(5660300002)(186003)(31696002)(316002)(83380400001)(86362001)(966005)(38100700002)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q201RCtyaXlmWjVhUi9oMVA0N2JTNGdudEpHaHlRV2oxRE9CS0lWL2ZUcS9y?=
 =?utf-8?B?UE0rNnd0OWt3a2NaMU1yeVV4bGJ2QURqbmNPbzZMakJrcE1WenNYOFVYdm5k?=
 =?utf-8?B?djdVaGptYW1Jd1Z5emJEVXZVcGtTbGl3VzFCRnJyWXFDdFoxeElqNmNZR0lV?=
 =?utf-8?B?TFR1QTdCbkJZTUl2aVV4QWx4b011Zk8vVkk2bmNJbFJhYW1lVS9sWXJmdnAr?=
 =?utf-8?B?TFBjbU5jL2N0YStKOVZoR2JKUk1Gais0bnZML0VGUUd2dVRGVThmb3FmVUVJ?=
 =?utf-8?B?OGR1KzU0ay84b09EZHhTSzdWL0lPbG41OTNqUDJiM1ByRlF3SXNUVm9pdnNa?=
 =?utf-8?B?QytSUDlzVUw2YjNnSTl4M0krRFZ1RXFWVVQwc2drZExqSmZWRmN4REpPZ3RG?=
 =?utf-8?B?U3NmZUljb0N1TEM2VCtrK2p0SzlvamFpTmVnT1E0UExCY2k0Y0RDczVQNmc0?=
 =?utf-8?B?N1U2ZDgwcmxzU09PWUpSR05wNlVvTXExY1pkMmZxOVNNZ3NTajNiOVg1T09p?=
 =?utf-8?B?WmlPSERSdnhnM2xzSjdZWTE5enNpdTFaWW9sY2RpN2VLa3JJcExKK1FzSjQ5?=
 =?utf-8?B?L0ljKzZ0MU1DL1FJd3BNTWRJMzQyTi9sbHZ5OVFlZzBCN3FzandYZ0N0Yk41?=
 =?utf-8?B?MGFtWmRlalVFNmlHbURkTGo0Y2xkTm9DSEV6M0hsM0lCVkg3TGdveFlCSTRp?=
 =?utf-8?B?Z3ZodzBweHRKWUlSY3V3d1lROGd5QXZnNE9EekhwUGkybGtVamVhM2lFTldp?=
 =?utf-8?B?UGVNYzUxR0EySGhFQ0dnbmNYTGVpU2tmQnZhVDVnU1FiNEkwWEFDQm84QmVV?=
 =?utf-8?B?aW52cVgyQjdqbmhNbFByOXoxdkEveUFvTW1TTmdrMm9FUExBbHZFdms3czNM?=
 =?utf-8?B?MkNocDBWY25yQmRXUndiMHdnMjZWRllzb0ZOaEc2aWtYbExZRHBDRkNML29W?=
 =?utf-8?B?eFRUNGFzZzRxKzlKd0Y2VVRzS2xRVEpOdUpiSVpnaWJFeU1XeE1zbXgzM3hS?=
 =?utf-8?B?T2k3czhpR3ZFOUZzVmh4MC9iR1k0R3BiTTRqWTByeXRKUm51OC9PcFdidXpW?=
 =?utf-8?B?WldqaE5ZS2V2WHRHMUxkclh4MDFucWZpa3JZdmRTRkVjV0VoT0kxc2JhWU1N?=
 =?utf-8?B?d3hRWmxKTkhFUy9TOEVidWoweXVtbHBhaVJyMXF1RzRjNGxHbnFQY2lpMDVP?=
 =?utf-8?B?eEdNQmtabDU2c3ZYWUpSNkRlV2gwcko0Z0pTa3ExMndOaHBMZkZlMjlybnpP?=
 =?utf-8?B?ZWtXWk50KzIxVzN5b2hnQ3F6eXRsdDFvRWRuakNWOTR6MUw1d0ZtV294alp0?=
 =?utf-8?B?anlkMHlVbUhoRWpERWVUaXVPVkh1RVhYL3BHQ25OanVEWS9qSjh4cDN1TlpN?=
 =?utf-8?B?dXFrUTNJSzhaZkVQRjNIcy9UZG9URWgvMUt2dkhXWlQ2RjJGWDRTZ2liYjZT?=
 =?utf-8?B?Z3lPY29odFovK1c1aG1JSytlRXYvUHBMNDV6Rm1Xb1Ewa1czN1lyUHg0ZW4z?=
 =?utf-8?B?UnQrK2pmNFN3R3B3Qm5HUC85cVVRSkxaWGl5S29yRXRDemM2Q2ZKcTNoampR?=
 =?utf-8?B?U2piMGJYRVhvWHhwclh0TC9tQi8wQ3JGYVlXZHFhUzh6SXFBaklLdzViUlpq?=
 =?utf-8?B?NlFsd2cvOEhDUnU4MFdKZzkwWExBUXUvekJJU04xcEdxVVFSZkZmWmp0V1I4?=
 =?utf-8?B?d3RUREJTK0Z0eDc5SUFzUlFJRUJmNmdRZnp1TWFvSGxCcmxsaWlLckRjL2ls?=
 =?utf-8?B?c0V6c2hXaU9xTVZCbnRkUTRUSjFJM05kM0czY1FEK0FTaHB3NFY1cVZyVUhq?=
 =?utf-8?B?aVFJeWdnSGdCUDloU3pNZ3NoL2hkK2NZQTJnbTZsUERiaGJnblEwa2xzRzJu?=
 =?utf-8?B?d0lucUF2ZWpTTE9oMjc5Z0NQcFRIc0RocUpKcnR0bXlwdzczNjZpQ1lLTnZV?=
 =?utf-8?B?S3YxdTJPVk1wdzBscDg3dk9qT0w2QUVKNWYvb09LRDFsTWFlcEhoQnJXNlI2?=
 =?utf-8?B?WmNSYjB0NVdYSzhSK3V4bTRFU25abjBSMDNKRUJraVd4blR6ZXdJb2RUTjBJ?=
 =?utf-8?B?NW1JWVUwTFQ5azJRbDdNQjhnUm45WTJHU3ZTUDVncTJ1OGhXUXFuVXJjT00w?=
 =?utf-8?B?S0diMDdUOE82NTN3Qk1XYnJxOGtuVHR4enk1NUk1RVJ5cWp0NUptSDFreExD?=
 =?utf-8?B?NU1iSkpPTUtmbXZCanpib2djV3ZpUlA0cGluZ0o1cmVmU1V0YWtQTHprNUNm?=
 =?utf-8?B?M0U0Q2F4T3ZqeHNsSVlEaVJpbWc5Sjd3ZGF4VUFPMFZSOVV5OWZlOEI1WVlP?=
 =?utf-8?B?czBhRTd5TUVGY0hRMStIOXErbEc2UUE4MGMxNThmajIvOTM1bXQvUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27f4ade-9958-466e-1b56-08da3d5fe84e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 08:32:15.7778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3tOXJyORpu2fYNM6mcPRzZtnmbQ4ZO/SWRrUMAP+rYc9bLiweDpoVyARwEwC31PJHJNRliVEAZ7wixzeDlnlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 23/05/2022 18:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.316 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.316-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Ard Biesheuvel <ardb@kernel.org>
>      ARM: 9196/1: spectre-bhb: enable for Cortex-A15


I am seeing a boot regression on tegra124-jetson-tk1 and reverting the 
above commit is fixing the problem. This also appears to impact 
linux-4.14.y, 4.19.y and 5.4.y.

Test results for stable-v4.9:
     8 builds:	8 pass, 0 fail
     18 boots:	16 pass, 2 fail
     18 tests:	18 pass, 0 fail

Linux version:	4.9.316-rc1-gbe4ec3e3faa1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Boot failures:	tegra124-jetson-tk1

Thanks
Jon

-- 
nvpublic
