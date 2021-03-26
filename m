Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF88E34AABF
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCZPAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 11:00:09 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:31361
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230139AbhCZO7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 10:59:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7KMTsmlzxwqH6PC8X0L8fhqt+He3qgMCLq+gs1fYpTrjQ8q5z/g4N1ubDpiDtRcujjD557mYyaFEX0/tDztsLz9+uBQD6PEWoRIueE9U4XY9qazHG/GpG11JvwYam+iXvlzGY+2VrTxsJb+OxkbszUmhYmkIO4oFsV6C0DgH+vyCLGert7FfviDnLdqaf5RsVr3ICjJ6SFpgdpuZ0mL1uozC00WLSl37XR7TYnU0PWMsxA63vHaLElZtRPI+nUqrVdBGxej9Fhkd5SpVGgwOIHyhPfAnMP1qD+Rack4HmFp42PoP9gSq2ohvyIbCZ8lHKYdu62GGmgU4GdgTG1iyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyIwJSToS4LZw0UjUGwnqVg1Ssud9iX8pobvcSDb3lY=;
 b=SETPnSlGYdQAfIoto4+I9NRctMowRxtjvYreRCPR7acTOmYQMH3zy5VfdOzKLMGu2/fjuZo+aBPeOJOPQ85Zv5IOUxOanUj5GSN/WkJyyqBtikG4RmLb8BrzDhREGDcoSmjtr1WOVI0Reu1X7mJpGzE9gF6XIIqLnzF3Y94xKx0yilOFGJSkGLRSWhzqU1ubR7tsTJ0/Xf5ExAEvC/GlmBvDw1yXzTcfs00K3gJE9WJHrR5vDigww1YfWa0bH4RUC7tJEhljMg7GvPEeLJBUqESld/XOhrqIk3xXy+Hsoxt1f/xSpkh2xoBITiKFk4NVO7KkBa/gyF9k+A2G1MAOSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyIwJSToS4LZw0UjUGwnqVg1Ssud9iX8pobvcSDb3lY=;
 b=s1S21E4gAXmATcnqxKd8kekiek/zHXuLBx2TggT2Y1FaMewTtpEvs8B6rHdFgX+1b7Hqp+T0009Q0CcTnrJVk/9E4ElqLrq2GhU2aBnYTrKSns4AvKg71Mx5lYn/AhgXRFLPhd8qZYG+4dc5M9FScRlcJh2sj9/bJeC4RsHkXw8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 14:59:39 +0000
Received: from MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::4987:8b2f:78ca:deb8]) by MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::4987:8b2f:78ca:deb8%7]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 14:59:39 +0000
Subject: Re: [PATCH] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
To:     Alex Deucher <alexdeucher@gmail.com>,
        Werner Sembach <wse@tuxedocomputers.com>
Cc:     "Leo (Sunpeng) Li" <sunpeng.li@amd.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
References: <20210317151348.11331-1-wse@tuxedocomputers.com>
 <CADnq5_OpJ-2jR4D8xwH93PZKoMWXx8C2yGTkqt7KRrVgph-KvA@mail.gmail.com>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <53b26416-31d0-6efd-04e9-2a9f34e525b7@amd.com>
Date:   Fri, 26 Mar 2021 10:59:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CADnq5_OpJ-2jR4D8xwH93PZKoMWXx8C2yGTkqt7KRrVgph-KvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [198.200.67.155]
X-ClientProxiedBy: YTXPR0101CA0020.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::33) To MW3PR12MB4379.namprd12.prod.outlook.com
 (2603:10b6:303:5e::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.193] (198.200.67.155) by YTXPR0101CA0020.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Fri, 26 Mar 2021 14:59:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9409f0ad-78b2-4781-2143-08d8f067c6fd
X-MS-TrafficTypeDiagnostic: MW3PR12MB4556:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4556DF093F7873D35A13EB4C8C619@MW3PR12MB4556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGG+np51HJBmExqImlmWyqbyximb2smJj753IAtAveCKvYdeMYL8JryZvc0Yt09tqNcdaYF4yNEH11pHjjlNHRkRzhcbiavuK0OdVyw+nLMvrOSz92Tf//p+8zVepEFgNf1X5sEyAJO/ZAGJUrAEUq3Tn+a6Bc0hmGFss4aCTXxmO65iH3Vz+JeWxwLnql3PA1ihAdfE6JZfxeIJJbt04AZKvWakYM0LrBtpOKbB/g4DKHSMjVeK82ogO5/m/+/ommDiAyYnQr8jykZxDNEN6+K1HXghChJ5O51WbtrC9KdTHtuogc1ALH0dtyQTjaUt51fd7fE5799zx7sq6OyHn9tEtbnzmQtW7G5BP94r99c0upiEPH/I4/M4/siAM5iRmB1SlakA1jq7rNleOKkzlGns75+bS8jn3T7KM28RNq5GZagO9qbKD5MNgQ60aI6CHP9gJQzQFwn9O0adYWc2D+apcJWA4KM+eUqcUrbCATgqd2mt8deUr5UkIjDSE81jHN9bFTz8CMxcUif/QcnjLdcl4c9IxDHPt8eyo8rYt7TvJxmu/2HXhz6S+BfCtQ4uc7DkAk7MgnN5e8+0yG7BPl5Bx+Hr/SLXn/nFkg1K3+38dRkUEfjZ35OKFZC0k9/E0kQC24UjGT+4rtScFr5FnifY/iKoXEH6Y/RjSnm42B+ZcKzoz2Oh7hPxqbQPCBtXoO1Bc5GS+ej7B4H2uktcsfCVfmph7GVXMFqUG4CcRDoghM5cqgqbx/E/Jo0Dz5EpiPxXlO2jwRxT+V+7+qnvNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(26005)(186003)(31696002)(6486002)(53546011)(16526019)(83380400001)(38100700001)(66946007)(478600001)(44832011)(16576012)(110136005)(66556008)(4326008)(2906002)(8936002)(5660300002)(66476007)(36756003)(6666004)(316002)(86362001)(956004)(54906003)(8676002)(2616005)(966005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXNqK3JOQlh2SVNLWlBhc3UvM21VcHV2Vnh1RHBnOEwxZHViMFRGbzhUUW1x?=
 =?utf-8?B?alJJU1hpS0xzaCsvMlVFTW1Fa0k0VUp4cEZIblpLQzZwU2RJQWFHV0twVy9Q?=
 =?utf-8?B?dzJHM08xUjJ3UGpneFg3SUJIRVVaU3RRRTk0Ty84NldGcWxjcDE3cXVJTHBm?=
 =?utf-8?B?VjVTVGIxV3pBNWFxRHJueE5xVWViMnhFaXFUdDE3eTJ5dk1yaHdJOXowVEJp?=
 =?utf-8?B?dkJ6eXV1T3VsMW5aVFRmZWQyeGlGQlJrdTJ2R2g3VFhxbllxQ2dLTjBRT3Uz?=
 =?utf-8?B?VFRpK1p2WmpEOGxZZXhyVU9DTEx6cDgrRmdKR2FXYW9zM3g3Uk9TR2padG95?=
 =?utf-8?B?RE96QTBETkhCYUd4TkY3eVNmdDRFZDhJWFJueXQzek5GNzZydm1UMlgrZmF1?=
 =?utf-8?B?eEJYMFk0dGZ4c00xc1ljU3RQVWV2bmRDK2NDM2Rxd25tQVR0R0MxcUoxNXQ1?=
 =?utf-8?B?VmVwT0NxSzROelRyNk9tQ2laZ0tITStPZEtwWUlSYjUzKy9naklXT01Sc1Ni?=
 =?utf-8?B?RlNEUXUwUDNIbVNLdTVGNm91NWF0SlY3SUF3MVJPTXJBSVB4d1NDTzVjYXZP?=
 =?utf-8?B?OEJ6Y0YzMVhqNWJ2NjFmMmFzVGhRVzU5NnFHRWpqMm1NK252ZzZEUGgveWJz?=
 =?utf-8?B?RTUwdVZ0VUxueS9sRFFoditGbThtL0NZdmlTUDZJbGY4ZU9iRnU2cWlqSXZu?=
 =?utf-8?B?anhEVmUxbWlQUnZvVmtVSTQybHdxeUh6NlJXNHc0dFROT3V6dm1UU1UzN2p5?=
 =?utf-8?B?RkJoQXdCREdQUjVJUENmcmt1Tk16dHFXR0FnREJ0dHlIN1hNR1FaaFJjaWhm?=
 =?utf-8?B?Tk1LNzlYc2pwZVlQNVZGY2VoMmd0Q2NsUEhVcThXVCt2cU1PSXVnWnZKRjJL?=
 =?utf-8?B?T3NWNnEyZ0JSTEF4U0hoSjFOZlZnOWE2L1dGRUdBSWtGbW5JeHhaV1VLZXVW?=
 =?utf-8?B?Zi93SDJyQ2dqaFlXSzJYc213UHMzZWNrckl2cmdTbG5HUGlEUmszWlF1UWpI?=
 =?utf-8?B?UGFoc0REV1Vya1M5MmhWYzkwaFNpMFZvRUdnRy9SVGMyZGlsWkM0bmpnQ2Rv?=
 =?utf-8?B?NFJ5bVh1RGpQb1FRN1dFbFVuM0kycFZUa2lldFduVzZMQk5sQjNSTW9oRERQ?=
 =?utf-8?B?NGVicWEyeXhQVkNEUXNSaFFZS2RRMjMzNTl3cjRhZU41WmpCZTV2Zzcxbmo0?=
 =?utf-8?B?djZicmVEeDVtejM3bGhHc1VFUzhsdURFaU56bGx2bG5UTDRtYmJmWnY0UWpX?=
 =?utf-8?B?a202M1MxTTFlY3VQTkZtbUlpdFdGR3o5UWJmNEdZYUNYQ3AzUkpGeit2QTlV?=
 =?utf-8?B?cGtIeWZXSExJRjJxR016YVdTODloN2dUUnFWaUczcnN6UkRFYmhEdSt0anU4?=
 =?utf-8?B?eEllK2lWQUhkN0RFTVBkeHZHMEw4WFBjLzd4dmJCVXFsQW8yaWlUSmJzZ3g5?=
 =?utf-8?B?azlyZFJvVmNycitSOFovei9EMDc3b3E4dTRCR3pjSkp2SDlqTUZIcVZYcWda?=
 =?utf-8?B?OFNQays5UzdjMm5Gc3ZrWGw5cVhELy9MTlRoSk9PTXR2LzZsYkh3dm4xVzBR?=
 =?utf-8?B?TmN2bUFCbVNDdlpoelA3RmxFanU3MnE0L1dDWGUxYW4yVXBUb3BYZVVEVDUw?=
 =?utf-8?B?aTYrS2VtZmtCc2I5NGlqdHZrWGNlT0htR28wVFloclhVYkZFZmppTGtvaVBF?=
 =?utf-8?B?ZG5BTDFoZ2RUc3hIai83cjdnZ0dXMW03a3o5MjVOY3NnT1MwamZDUGRyZ25V?=
 =?utf-8?Q?jE4Ba7HtOPpX9+zDcC6nGwaR7eRb/xLdxSf4Ut/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9409f0ad-78b2-4781-2143-08d8f067c6fd
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 14:59:39.2113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITRe+BKTnoeNsqDnf77S0f9JaLViSuwU2y8YvBJTTD8bjvr/w4wWrMJND8p0MIEJtzJNtjYowF2K9ZIWvDsB5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021-03-24 4:23 p.m., Alex Deucher wrote:
> On Wed, Mar 17, 2021 at 11:25 AM Werner Sembach <wse@tuxedocomputers.com> wrote:
>>
>> When encoder validation of a display mode fails, retry with less bandwidth
>> heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
>> to support 4k60Hz output, which previously failed silently.
>>
>> On some setups, while the monitor and the gpu support display modes with
>> pixel clocks of up to 600MHz, the link encoder might not. This prevents
>> YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
>> possible. However, which color mode is used is decided before the link
>> encoder capabilities are checked. This patch fixes the problem by retrying
>> to find a display mode with YCbCr420 enforced and using it, if it is
>> valid.
>>
>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>> Cc: <stable@vger.kernel.org>
> 
> 
> This seems reasonable to me.  Harry, Leo, Any objections?
> 

Looks good to me.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>

Harry

> Alex
> 
>> ---
>>
>>  From c9398160caf4ff20e63b8ba3a4366d6ef95c4ac3 Mon Sep 17 00:00:00 2001
>> From: Werner Sembach <wse@tuxedocomputers.com>
>> Date: Wed, 17 Mar 2021 12:52:22 +0100
>> Subject: [PATCH] Retry forcing YCbCr420 color on failed encoder validation
>>
>> ---
>>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index 961abf1cf040..2d16389b5f1e 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -5727,6 +5727,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
>>
>>          } while (stream == NULL && requested_bpc >= 6);
>>
>> +       if (dc_result == DC_FAIL_ENC_VALIDATE && !aconnector->force_yuv420_output) {
>> +               DRM_DEBUG_KMS("Retry forcing YCbCr420 encoding\n");
>> +
>> +               aconnector->force_yuv420_output = true;
>> +               stream = create_validate_stream_for_sink(aconnector, drm_mode,
>> +                                               dm_state, old_stream);
>> +               aconnector->force_yuv420_output = false;
>> +       }
>> +
>>          return stream;
>>   }
>>
>> --
>> 2.25.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel>
