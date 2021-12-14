Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0D473CE5
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 07:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhLNGCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 01:02:50 -0500
Received: from mail-sn1anam02on2061.outbound.protection.outlook.com ([40.107.96.61]:16888
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230196AbhLNGCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 01:02:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob2PvEapX38rUkaogCI1dxOawAHwbEJ+TuVvvX8es9O28Zk7ofUN6Sa6fbClMyERirZbyrQYjcU+fBNnI84fokYjEsauxU2HxUcyK/foshSFAKr97Bszj3o0XcjTKAol9JDLDtVDnyoA2laCz8SiuTJ2+R4o86LeMv3eMgT+9PO1EhkHQdTzf9yPQwdU4ae0dIDdzBSw0Bdo8XLKfbsNKx4o2TgGe2TktoIlfi+EPpnVk6Eu9Vw7w02xRr+mbezdZZyZsv78F3WEmiMSa95T2utsdTU/RIpV+oUL7gGNVGSiV2IIt1fe+5gjiTVQcjwUAz61UYeUC3D2eFj2R8pK/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Smt5XZzYKHLdEg9mEE3sGkvg54xbpjdpycOzVmqBxk0=;
 b=oFlZcbAWPizAZDzsJ3sxpWqg0pfXF+7hoCWbGjkchsDnEj+EyjzFHgm4jrTQI8zVW37qPk5Ie0cZzNHnqmAc4/lj9pH0uHWveVIdDEzmmVsnRZlrWq2OUg7M2qeuu8rrl8iP/kYm1aersAuREx+1qBa2C3eEyd9AIJZTNZYjodJjUfVaP6e14fCA13SKQrEh02WzLRmmUcJiApUP4AK4hg0RZagUXi/qtYvOl8T1tBYjX8HGe9U2A497wmuzW3P0sUlgEAYd8lVOJKdsgPAXn4D5/lL8u2G+EnOzXGxa3DhrBumfkgbC7LOxAF1KHUB0m0UQ+YhW+yxNryrYL7ghog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Smt5XZzYKHLdEg9mEE3sGkvg54xbpjdpycOzVmqBxk0=;
 b=AarXXQpggH8EY0RpqnjwNQUwGxD24wDNSfEQnBFcDcbM/xYVJgVIl8ai27WUNscG77b6e/WODY4a9dnBKvFgvIuQGmef/g/QbdadJLyF8DezROKVvHXjQ7LZSkqwVqy7blwaHme+X/pPfpdElHzh494KXCXEwR+QYNXLCAIT7C/KO62k0E0mKAdVYdv8Mh59mdC78iKxIjxsu1noyyt6CArlN39DisRq3ubAqcrnIAUWZHGppKMY3LmICSbFAh8OXqmbYKB+ukuqAlTsuwiq9yJgWkWZWgCjk0SlpvElVK4zzyDBDtd6yQcE/4tcnj9AiF1XWH0jsZVCGme/mFQTVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0039.namprd12.prod.outlook.com (2603:10b6:910:1e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 06:02:48 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 06:02:47 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
Date:   Tue, 14 Dec 2021 11:32:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR0101CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::27) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f373b919-3937-4efb-b375-08d9bec75a85
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0039:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0039C7A92DFCCF5FBF1E491CA7759@CY4PR1201MB0039.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gf33dH2P8Notczhimyr+gXzEvrgQoEdVeTi7hF+eQpSOwZHZYiP88u9oEki6/kO8ENlEaaxjQ4aJwDdPjFerVz+pGS+BOd2UW+bkMwDRDrmx52nCXIAFg9NtrLDCxkb2Uz9FoerwWiVT6RSc9AM4fHUn28MRa+JznKy9xpRutnYFO2wTR40ZokT/AdG/XKwv4YAoZwN6Eceujv0ralp4O1GQuzNBQYXbw4IhU3SssR6kItaJtX5mCG7yKILHJllY+evsp8M7oajUDVjz19wlCzBDOfsuiCVuajLKnehCn1DG1WTNpN6UDMRS5vALztOLlY6C4/pgnUD/JAPncEa4Yvhaxh25yeH9QhKU5NEn0gPEi7a2g7hJ8ipMRU3iQCruJjwItoltQGwwrwunc92U8MMAO9VvyeA5n6ca3k7bZO0OGlB1wnujmF48xDsKHTqR9TKJk2Czwtin+1D21ZVbxcY0hGvPvwSzNrzzSBN0J2PFHN7APyP8XvpZKB50pn9RMrP3Cn0Nl/wDJuzREUw8SncaujNpMW2wgWDkyM+qgMvQcXcR19dG0YqdLUDQtMYD3HCRujQZngPpe7lNCHGmojxBkRB58Ctkg9h+gQ5DFMlQcZjEnk2vsqxTXUUQHr6vff/W9Q/GLVg0mVrhXm127ypurHmoM39C9Bt+DmFdq2beGRr3stW/LC6Q1KRRoK8r+q9+Kwk61xpaEPqw4X46Hn+9giOQkK2lLVkTw9eZ2rE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(31686004)(7416002)(6666004)(66946007)(186003)(26005)(5660300002)(4326008)(316002)(8676002)(4744005)(66476007)(8936002)(6486002)(53546011)(36756003)(38100700002)(2616005)(2906002)(86362001)(31696002)(6512007)(508600001)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjFwUDhFVzVqU0d0NnZYUDk3WjZNdlNFRWxGMnFwOUQyaE9UaE5NVEY4Vnpy?=
 =?utf-8?B?eldDOXpoT3lPcWJCMjc3OUp2cmlxemRUSm44dWh6cnVodm5kMFFRN2ExekVB?=
 =?utf-8?B?YWVibnIxckR4NTEyZ0tJNkRGNXNibWorbXZVMy9Nd212b0VDNFJaM3ZmN2VU?=
 =?utf-8?B?emZCaCsrN1IzVVcrdVo4WmEwZUJYQVF3c2ZyVEFBTlFMVVo5bkFOYUNKeGlo?=
 =?utf-8?B?dEJsNlpyNUtEMjkyVGZqaEcvKzdzVjRaQlFmTGd3WnRoL3Q2SWt6NHhULzBp?=
 =?utf-8?B?c3FJbkkweGZmZWtoWGI0SnY2QWYxRE1TUDJkQ1dVL0x1QlpiZkFqbHNqcUVT?=
 =?utf-8?B?RkVhVk1rN3pzR2JjL1BiZU5qalA5Y295MzczTWdDQjJvZlJ6U1ZMY0hKZHpw?=
 =?utf-8?B?NXQ2VXpzZGUrT3FmK3FwSXlQQUs2d0dHeFdwRXNuaWUvVnowQXY2bU9Ydkx6?=
 =?utf-8?B?VzZ2UmtMUkFaWHVsRFdPakhsVFI5NkF0K2tkZGdZM0ZoaGJLOGVxQnlpcVlE?=
 =?utf-8?B?ZmNSNVFpMlRBeldQUXlZMFdMRW9Jd3lJL2VmcFQ3d2ZURkxPVXBOb2Z5TFJt?=
 =?utf-8?B?VjFaWDBrMWhmSEhtZGQ0N09sNlN6WGpQTmJ4ZGlXM0x1VnZrbDZVSkEwbFk2?=
 =?utf-8?B?ckVMWVRQekJOaExUNkZsQVhEcjBoL1RZSkJuYW1tOE9yMUF1VFNOMHRuNE1q?=
 =?utf-8?B?emVFcEQ1OXduNmRjRDJSREFIOW5yWS9mdFl1dWo1emN0Q0NiUUdjaGNPMUc3?=
 =?utf-8?B?Rmh1SHM4MFdCa1VaZWVEcEdCN21jU1QxMXBZdmlwb0JYTE1XOVpKZndXUTdO?=
 =?utf-8?B?bjgxNXU3NzQybldVU25mV0dRQVB2SnRFNXlCL2doSVdpei96TUF5UFh2c2hT?=
 =?utf-8?B?NklFWFBGbnpsL1pBblBZNDlkNGFJTjlaaTIrb2tISmIvekcxaEd3L2Rnck1M?=
 =?utf-8?B?V2F1SGk5Ym1CdUNKOUxOUVEzY2VtLzBScmN6QlUweE9zZ1dqNldEbUtnemJL?=
 =?utf-8?B?dTNMR0ZtYU9IUCtRcVlteWFyMitDMzljQTRwWEhlMkh0RVJLNHpycWN6dVFS?=
 =?utf-8?B?QXRBRjAreGJnL0o2MVZFL2tGaFRvblF4QXA0a0hRUThyL2U0dm8weU9hdzVV?=
 =?utf-8?B?b0ErelJULzJHTVo3TmRKcjRGRnlWeEhaTUdNcHE2Ykx6Z1gxT1hLaloycXRS?=
 =?utf-8?B?Mm1rR2xzMGFnTFhBUWd5MHY0RWR0TGVWZ0lsZkJTRURnd3d5ZWI4OU5XQXZE?=
 =?utf-8?B?QU85aFh2QTAwZVZ3MzlxeG1GdVQxYkdISm9LMXJyZWtIeDhsdWhjeCtaQzlE?=
 =?utf-8?B?OHV1aUZ6UERsRm90SXUxaHBza003YjgrSGFRcWVGd3MyNVQ2dGpxdUk1Qndz?=
 =?utf-8?B?YVVwRVdRUFJTVE1yMHE3QVlqcldYVU81YmdRZ0NUZzRCaUc0NFJWZXBnWEVE?=
 =?utf-8?B?WlZVSS9lbGh1ckUxSDc2T0xqQUNMSVdaeGNuSTRuRnhPT1pKN2pvQ3pFSU45?=
 =?utf-8?B?N3hyQTJWN1ZYT0J4WWNraGVqRWRlNTUra3JxS1JNYXpYeVdJcU00US83ZFEx?=
 =?utf-8?B?UEZKa3RmL1RuMnR0Z3dCTXpaWksrdTFnaFo1K1ZTMVBSNEx6Yjc5NjN2ekgx?=
 =?utf-8?B?dk5ucWVza3ZCbkg1c0tsQnlPVnl6K01SSy9yVG1LaytOZmJMenJ4NzJDenFE?=
 =?utf-8?B?a2tKVDVKT1BuRG05VFZJRUVKNDJSTXRhQ0grTklDZnQwaGhGRzRVMCtBUDNB?=
 =?utf-8?B?T1dwRjhyNUdySGlQbTJQcGhGbldwNWYyeFBUazVneW1INS95a3FLc0xiSnll?=
 =?utf-8?B?clAzQi91b0c1Y25qNWQ2RklScG9IK1RiNmxrM2lPWTBPbThYcHhOdVhUZzhh?=
 =?utf-8?B?YnlvSXRDUm9WeEJSbS85RXBYYzFJajFvZzFjcmRTR1lCUHQ5K09MTWZFMkhM?=
 =?utf-8?B?bVAzdnNmRlVaTHdLc1MzN1c3VWlCdU5acUdWaVFBOU94ZXNUR3BpRENhTFpU?=
 =?utf-8?B?dWp5WkRDS1lIdnlkL2doQkxGVGFrL1diVVBXaTR4Qm1WWVZOUnpQb2ZZZzlx?=
 =?utf-8?B?RDNLTHgzU3JPNDJpL3NQZHpuVk56QnlpM0tlVU5wTDFsQityOHY2V1hCbzdJ?=
 =?utf-8?B?TmQrRmlpMmRCa0JPYjRFQmhHNkdJdlMxZ3ZZTmZ4VDJWTTdsYXpxa3RCS3A4?=
 =?utf-8?Q?cclad4ZpGvsT5ql7PhcGSAo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f373b919-3937-4efb-b375-08d9bec75a85
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 06:02:47.7506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f78ZiwmY0uyyD3X9JA3/mgae1ck0YoEXDR7z68VHtNUphnYbLZZQE9lDHxcp/s0yJYhfpwXQ4KqvoaCYf4pVRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/8/2021 5:35 PM, Dmitry Osipenko wrote:
> 08.12.2021 08:22, Sameer Pujar пишет:
>>
>> On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
>>> If display is already active, then shared power domain is already
>>> ungated.
>> If display is already active, then shared power domain is already
>> ungated. HDA reset is already applied during this ungate. In other
>> words, HDA would be reset as well when display ungates power-domain.
> Now, if you'll reload the HDA driver module while display is active,
> you'll get a different reset behaviour. HDA hardware will be reset on
> pre-T186, on T186+ it won't be reset.

How the reset behavior is different? At this point when HDA driver is 
loaded the HW is already reset during display ungate. What matters, 
during HDA driver load, is whether the HW is in predictable state or not 
and the answer is yes. So I am not sure what problem you are referring 
to. Question is, if BPMP already ensures this, then why driver needs to 
take care of it.
