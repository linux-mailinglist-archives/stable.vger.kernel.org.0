Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76F3444FBF
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 08:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDHmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 03:42:07 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:30009
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230084AbhKDHmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 03:42:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmfH8uVcTsJvL4r6YtVCS4fBFBiY4mKgSxLd0SQPgYskj+Uj/aXCD/zJ70EgniAcwL8B5DubRTtnFvBFXyjD2wAYIO37T6xQhTMcJxwYGVW4FtCT/7eNMltuZwWkYCZoKMOMu+2+EiPOFH9pVp/KaEaNfAZBAhr5f5YrLjEOz7wJg6wdF1rVzJbQIt5I+mqcKU+cYA96p2pz8b2Deitq7ftaotu7jWC/JgSIwasKnMsHYSd0rLBQsKwL9I24IWC5Icyh0j0L1wRmfEXGFx6tJwXdB9hfj2VpKYWQYPxC9wNxwi6+Y7iGatOI8sraaRVjRyblREvPq5GT8FUijft5mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXgrjDsOdtLNHpCqzHFWBOcI1ZpwsHF/b2zsdcwFs7Q=;
 b=DO9rBHvH8nK2xRyhbYzOOCzVtrue+GgCKKMQ5TN+xiqE2EBT+gWxY3xaGflJykbmDf2bm/Zn5JsYAlKiOCfB4Pj616e4/N80SoRMfNOVmnczQWbwdCSvClXD8q51elKsJcQi7ue7zl65A3YVZgCfkSIdlhzLE/lE79C+khdmrboUran5x1q5X+EVdGpUdgz7c5VnYjMBV1b7IkyFzHBGHqIpuLis/Y402C4d+G5smLYHUMkNSyZndWqW2eIDQ4mRPU1mdxRfZuVErXna6AuFvqPkmu8kYDtbcFD0ILObLiNMQIe79llSikp1jychd+spP15/DuE478euC3FbJPycag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXgrjDsOdtLNHpCqzHFWBOcI1ZpwsHF/b2zsdcwFs7Q=;
 b=qiHpBJQX3Xotx+5siPT8SyVqboq0PLfj90cM32cpg2KAygUs5uFNQzgcwBH7bn6i+XWHTaqR6+6aKcSnSPMjxneapF/DricpwWfyF2QRgMOif/3zgWQGekhCW1kzAWf5DEYLTWK3Clpd8ep7B1jWvwChIgiBxML/eO3YJ76pxZQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW3PR12MB4410.namprd12.prod.outlook.com
 (2603:10b6:303:5b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 07:39:26 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769%5]) with mapi id 15.20.4649.020; Thu, 4 Nov 2021
 07:39:26 +0000
Subject: Re: [Nouveau] [PATCH 5.10 32/77] drm/ttm: fix memleak in
 ttm_transfered_destroy
To:     Karol Herbst <kherbst@redhat.com>, Sven Joachim <svenjoac@gmx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082518.624936309@linuxfoundation.org> <871r3x2f0y.fsf@turtle.gmx.de>
 <CACO55tsq6DOZnyCZrg+N3m_hseJfN_6+YhjDyxVBAGq9PFJmGA@mail.gmail.com>
 <CACO55tsQVcUHNWAkWcbJ8i-S5pgKhrin-Nb3JYswcBPDd3Wj4w@mail.gmail.com>
 <87tugt0xx6.fsf@turtle.gmx.de>
 <CACO55tsNKKTW6X_+Ym0oySX-iNtikyV6rgHGu01Co7_mDWkxhg@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <1a1cc125-9314-f569-a6c4-40fc4509a377@amd.com>
Date:   Thu, 4 Nov 2021 08:39:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CACO55tsNKKTW6X_+Ym0oySX-iNtikyV6rgHGu01Co7_mDWkxhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0701CA0008.eurprd07.prod.outlook.com
 (2603:10a6:200:42::18) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (91.14.161.181) by AM4PR0701CA0008.eurprd07.prod.outlook.com (2603:10a6:200:42::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 07:39:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30d4742-2e25-4d6f-0a3e-08d99f663a1b
X-MS-TrafficTypeDiagnostic: MW3PR12MB4410:
X-Microsoft-Antispam-PRVS: <MW3PR12MB44100427892EE024D68D3ED1838D9@MW3PR12MB4410.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sy77eZIkz8H+KWejPbkAdNRA9R7cQNeF10CPVbjUq9NaYj1XmcbtjiNq9OozPnXJAi94+Qa1u0R8T+DrmAOXRnvNXfQs5U5UJa9Yt8UJlwNvgmkXA/aC0btA70VM6q0irOCPwkZ64c3WrzawD8wYD10Y/3S5TaYq1PNZsw1LEXqqI2pAVuVRkcMFlufzRUcDShf1vHiQIawRWYFFEwnzVwWW9rIqMOAmbJ1Rth7vmUfjE5HrSbY9Mi6djowauVSrh9d94spUiBK/9hJMPD2XgL9miMA6zmQArTkfhR7EaTi9cJFWiF0LcptJ8BtgoVEQJHqcWdU1fG1V7XgGX46E3iI1uZxDJoCEQa14ApKAyPY2ImTbglFJBQYGyxGJDsFIC5yxZ7LgVHuMxCgmFC2TkJThQgWFB574Nk7iq7zEUQmEPeVfPB6vxHdUX2EGmeFxHyzbS9ylrE4wrFewPYW9/yNuuNR/jMX9QSLe2Te0X7Zeq4HNhW/FMBQR0G14/nhN+uXd+aaQ1TmyHe2iEmosK3XJ5+bwkONwr2vXRbA4dOLQdlM52dJKi0gShAkI7Y4ksDywK5v0SgIttv79bY4s4kr0cfjzg5uCh9sJV0FSO/X+AY12Lqr3a4Rvwv5ViZRT5DEJ6nXytZ/uNGQC82LtSBZATwYEFqkKl2r0J3MNAF20BTR+BkZifBuNL/7qCF78lodgiHoXcDM8BaxraKLKc5fSAi18Kla6dSa+DpmlKfhgud1jfP2PGETVGir09aSe1MRYaOlQuMnN2t9VXuaTNoo4f5WvnKAplRewDkZ6HUVedZGiZWWJH+M/fbardhV8crMfPsJfsNjVGbqBOoSrrsnl7DVJLBJlOTfPlrn4oTETxw/bYD2xlThHgI6OHXv2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2906002)(8936002)(66476007)(66556008)(956004)(2616005)(66946007)(8676002)(36756003)(316002)(508600001)(6486002)(31696002)(31686004)(966005)(4326008)(54906003)(6666004)(53546011)(66574015)(38100700002)(110136005)(45080400002)(26005)(186003)(16576012)(86362001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eituUDNtb21Xbk5LbXlUZnVQanVZR25HZmYzTUhqUUtydVBFTlBmMklBRCsz?=
 =?utf-8?B?ZXVGMVlMb1pIaDhrYWtiWXNlcmRFengxeVRrWXlqeWk1OWlHMDBld0lwNmJQ?=
 =?utf-8?B?RkJMa2FNcU8wNDBsNktic0tYaG82eDE1MEpXQlpsN1F5bXR0clQvLzRPSVpQ?=
 =?utf-8?B?b1QvTVh6TUVqeTJhak12eDhUR0crUWc1Y2MweFIvd0NhNXRDOGZQSnlQcUpF?=
 =?utf-8?B?b2Y4Tnp0dlRjUkRoSnNGT0hSNGVEazk0NTV1eGZOaHZHTlhaaWh4dFlEZU43?=
 =?utf-8?B?RzRaamFNZlRIMVlpSExWQWFnY1pGUCtWQ0UyeHpieDhJR2JpeVdNT3Nra2FY?=
 =?utf-8?B?aFVEVjQzd1FOU29rVTRqR1hReGpFdWdrR0cwRk1UdWh4ODNoQ2YrdmF0SzIy?=
 =?utf-8?B?YTh3Slhod2FJZ2N3ZlFXMnRBWThlVFZkcWQzRlRhT2N4SEQ5MGJqekp0WmJI?=
 =?utf-8?B?azhGNmJ0dXdmQVNyc2UzSXpwZjZ4aUV0MERMNW1TNno3TU5pbmhoNFlnTkZo?=
 =?utf-8?B?V0c0OUptNWZ2MDI4RHh3REJVdnk3U0RlMmRsS2hudnhFY2g5TW9CWWMxQ2xX?=
 =?utf-8?B?NENhRzIrK0MyVXdEcEVGYkNJRjh4NENkZG53Y3hTaEZCK1FxNk4wcWhOSHR3?=
 =?utf-8?B?NkZVaVRTRVpneTdqa2dEZ2d1anR0OTJ3UTNRaURIdEEvNW1wNTIvNkdhRVZY?=
 =?utf-8?B?WXJZc0ZyWmxwZkp4cDhkaTlZTFQrc3l1TlAya1YwVG5Sd21JTHNNOXE3UThP?=
 =?utf-8?B?YlIycDM2dkdTNXl3Wm9DWnc2dUpRaTgycWVjSGMwRWhsTFduTSt5TTFEWjBl?=
 =?utf-8?B?VnczdnJDRzZNd1NsVzc4QlpUNEZ4dkFWNTdveXVLVWZYOXN0RVlpcnNDcWVZ?=
 =?utf-8?B?dWlJSVNiZGRybmloZEZ1dEVDcmpXODU3aS9USXdjeFhFb2RBb1RqSWtBd1Vq?=
 =?utf-8?B?cVBmTmZaa2hQbXBWSkE3Y21XZlNJd1Z4Uk1ieWRMTTVqMzBpU2tua0t1MXFX?=
 =?utf-8?B?RllQOE92TkFseTJwWithc1pmRkQ1OUM3SFZ4L0dJMk5HWXNnc0t0bGo1RTRE?=
 =?utf-8?B?VHliSWk3MXJHZmtJY2VxMWVQWCtPd1R0UzFWMVhwdFhuaVlNQysxY2lxemwx?=
 =?utf-8?B?UW5ZUjUvS2pQSE9ueCtRVDNMTXZOdEdUcnExRldmSEpFeDIvV1VpcHNTcDBJ?=
 =?utf-8?B?alMzVWF5V1dnMmk3VkxHbmRNYkMveGJPSElQMEI0ZHNiL3o0ZzVOM09zTlIw?=
 =?utf-8?B?WDlUMkRaK1Y5QWczR1ZTaXM0OFIrT1RTSzc2bDRvUHRPVlQyaGxxWlZHL09T?=
 =?utf-8?B?RjMxTmlXdkNDakNqSkZMdmU1UjhWdEdvaGRPcUVZaExFOXpKbW9acE5wd25K?=
 =?utf-8?B?OEx0VjF6MmdVeVVIcVJwWFlOa0wyd1VmcG9tYXpVSDBjOFZuMVJLN2dCQUVp?=
 =?utf-8?B?Z0svUzdiaGlOV0J2cVZqUGIvdUlzU1JnWWdqUkRhQWZ3K2xjSGpxMEZJTm9E?=
 =?utf-8?B?SllPVlM2UDZUTkt5ZElRMnFvWnM3ZGxjdHo0aWZ5bkdEM0trT0Fta3FpUk5x?=
 =?utf-8?B?ZFlqbUhRejFNdk9LS3Npa3ZTaG9PN1E5VURCMEREeUM4czhKaDhmODNjOFdS?=
 =?utf-8?B?d1lGOVRmTVRvUlFpUGFmWEl1L3dlUVpwMG5iUVRBYy9nS3VlZFNSbWVicG0v?=
 =?utf-8?B?VC9EWHU0RTQxRXF2b29aV0YvRW9UVHdJcDdYTlB6QnZLUW9KQytqMEpRYm1q?=
 =?utf-8?B?cHNJMzdDK1RHamlHa05yS0R3aTFKeC9PeHRRU051bi94czlXL2dHSCtUQ3Rr?=
 =?utf-8?B?REQ2Njc3SkpoN2tBQTZBOER6WGxUaWRwVHB2OHI5eGVXUHprdFErV1ZOOFZO?=
 =?utf-8?B?d3JsOWZodWphYndYTmFFY1k4a3dzeVpVRXlZQ3kvMFh1c0NlY09jUVd3c0FQ?=
 =?utf-8?B?V3ZpVGFLU1puK3VDUXlpVzFDOThodmNtQkZzMXlpdnZhRXBTR1pjd0JFbXVY?=
 =?utf-8?B?bWNYbzZDYjNtZW1xZGg1c2JOemZISFN1akpTK3luZHhMbDNCck4xbHBsOFRF?=
 =?utf-8?B?SVJGN3dvd1JxT1pYSmZCWTNxM011Q3ljaTl3VCtlTE42NUZhZXBMUG5QNXc0?=
 =?utf-8?Q?qcR8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30d4742-2e25-4d6f-0a3e-08d99f663a1b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 07:39:26.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKitFNiyMUiPGTSaPjzgJtSrLZH4HpSmTVv7nteB2Z8HLzbL2UuEzBN7sI3MqVnm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4410
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 03.11.21 um 22:25 schrieb Karol Herbst:
> On Wed, Nov 3, 2021 at 9:47 PM Sven Joachim <svenjoac@gmx.de> wrote:
>> On 2021-11-03 21:32 +0100, Karol Herbst wrote:
>>
>>> On Wed, Nov 3, 2021 at 9:29 PM Karol Herbst <kherbst@redhat.com> wrote:
>>>> On Wed, Nov 3, 2021 at 8:52 PM Sven Joachim <svenjoac@gmx.de> wrote:
>>>>> On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:
>>>>>
>>>>>> From: Christian König <christian.koenig@amd.com>
>>>>>>
>>>>>> commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
>>>>>>
>>>>>> We need to cleanup the fences for ghost objects as well.
>>>>>>
>>>>>> Signed-off-by: Christian König <christian.koenig@amd.com>
>>>>>> Reported-by: Erhard F. <erhard_f@mailbox.org>
>>>>>> Tested-by: Erhard F. <erhard_f@mailbox.org>
>>>>>> Reviewed-by: Huang Rui <ray.huang@amd.com>
>>>>>> Bug: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D214029&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806624439%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=UIo0hw0OHeLlGL%2Bcj%2Fjt%2FgTwniaJoNmhgDHSFvymhCc%3D&amp;reserved=0
>>>>>> Bug: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D214447&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806634433%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=TIAUb6AdYm2Bo0%2BvFZUFPS8yu55orjnfxMLCmUgC%2FDk%3D&amp;reserved=0
>>>>>> CC: <stable@vger.kernel.org>
>>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchwork.freedesktop.org%2Fpatch%2Fmsgid%2F20211020173211.2247-1-christian.koenig%40amd.com&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806634433%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=c9i7AR44MVUyZuXHZkLOCBx2%2BZeetq8alGtbz0Wgqzk%3D&amp;reserved=0
>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> ---
>>>>>>   drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
>>>>>>   1 file changed, 1 insertion(+)
>>>>>>
>>>>>> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
>>>>>> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
>>>>>> @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
>>>>>>        struct ttm_transfer_obj *fbo;
>>>>>>
>>>>>>        fbo = container_of(bo, struct ttm_transfer_obj, base);
>>>>>> +     dma_resv_fini(&fbo->base.base._resv);
>>>>>>        ttm_bo_put(fbo->bo);
>>>>>>        kfree(fbo);
>>>>>>   }
>>>>> Alas, this innocuous looking commit causes one of my systems to lock up
>>>>> as soon as run startx.  This happens with the nouveau driver, two other
>>>>> systems with radeon and intel graphics are not affected.  Also I only
>>>>> noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, and I
>>>>> do not use 5.4 anymore.
>>>>>
>>>>> I am not familiar with nouveau's ttm management and what has changed
>>>>> there between 5.10 and 5.14, but maybe one of their developers can shed
>>>>> a light on this.
>>>>>
>>>>> Cheers,
>>>>>         Sven
>>>>>
>>>> could be related to 265ec0dd1a0d18f4114f62c0d4a794bb4e729bc1
>>> maybe not.. but I did remember there being a few tmm related patches
>>> which only hurt nouveau :/  I guess one could do a git bisect to
>>> figure out what change "fixes" it.
>> Maybe, but since the memory leaks reported by Erhard only started to
>> show up in 5.14 (if I read the bugzilla reports correctly), perhaps the
>> patch should simply be reverted on earlier kernels?
>>
> Yeah, I think this is probably the right approach.

I agree. The problem is this memory leak could potentially happen with 
5.10 as wel, just much much much less likely.

But my guess is that 5.10 is so buggy that when the leak does NOT happen 
we double free and obviously causing a crash.

So for the sake of stability please don't apply this patch to 5.10. I'm 
going to comment on the original bug report as well.

Thanks,
Christian.

>
>>> On which GPU do you see this problem?
>> On an old GeForce 8500 GT, the whole PC is rather ancient.
>>
>> Cheers,
>>         Sven
>>

