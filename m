Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2577680D54
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 13:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjA3MPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 07:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbjA3MPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 07:15:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9345BE3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 04:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675080910; x=1706616910;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FaXyf5z4sniY3RerO/JnLAm4Ntc+m6LFznHuD60+4Uk=;
  b=l8b8G62MTbM4AtW0RV20/+ZPUaXx85Kg7ux4TNxnpffTOUU8UDiTzxim
   owDzVeeeGpcXalWRaLI2lSIEcNc9dzvuR2oTJh4bOyWXuKHrehSLW7C1W
   V9sQFdFpqnCmZjxr5AOWX7HO7u0ZtkdmPsYTR+rDxjV3I0CsvVFC4dpwk
   p7VWQJuu45mTh8PBZDXDILV8jF1TXytrj8sjENMEaD0nfgviqhjp2RIoD
   EFAqVijwZQtSVnZ9/zNpTS5JROHZBm7deNvnGVJwjMFrVAma++l3OoXO1
   O3E3Pt1b++WFGSP1AEqDiwRx5QfRcb4j/7GC3HROgqXnCVEcBFK8oQ6As
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="326208451"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="326208451"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:15:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="666053001"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="666053001"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jan 2023 04:15:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:15:09 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:15:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:15:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:15:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfbv0dtLjgt3bTR716nG///Pwzbb8dI9XD30lBQcO5zWdbTDe84dFOGnonwAjQ51tr7mlVS9E7I8fIUCCH+TIjqXRL6r4DENdQ2sGntGdYrLUTr4f46v36d2JTgAupz2rRYS/tgCouR++GPmYY0NwMXdjMu/uuMurDw5m/CCrToJsO2zvJCiYBGzNKY2xJday4TNoxzw0GTmgM6enokMb9OW1GJIQtCXifPqFAO2bbbhNk+5cVSnj/Ha4BP9g1HWtn5SK8ANydDhDzbBRPGU4ZYhQToBLx6p0XHNztzkflZrOmFgA79VLc+WtSvgzi+0dMY9vBVhSahxM3ezFAm1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coYls2/BOeNWm1wikRJfL+Af9ReC2rZ59AXQ+h5+A5k=;
 b=oUhGtF3aO0IKEoTyxsY9V79QPtAL68ImHDNEIxHtPy0qpj4zhRnZpOQIpx0iu3Jtuq6hb+GFYTg3yHD8LBv0bTLXCfwEbD5kmNvd30NyzLb7ccgrBu9fExa6fTrvnoUXSamq1YxFxusCwr/50J3oP4nniLc4JtAHhgNmHjoFYN+47GU9/gs2xl2OUIsnB3BmM0P4xDD580tCEeN15HcLaJIrb7iq/UVlGUYUStC1ZXKwNqkXEC2Wocuk+ORGUNbpIPUkFK8UzcGkNJcHaiDz49pOXLTqVcJZkOvpHGwRaTxeNaIEj38j0sj5v8fqOAeSXxah6SzYi5Me6DQg0kFrzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) by
 SA1PR11MB8255.namprd11.prod.outlook.com (2603:10b6:806:252::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 12:15:07 +0000
Received: from DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8]) by DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8%9]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 12:15:07 +0000
Message-ID: <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
Date:   Mon, 30 Jan 2023 13:15:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "Jason Montleon" <jmontleo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <casaxa@gmail.com>, <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <stable@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>,
        =?UTF-8?Q?amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0196.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::14) To DS0PR11MB6375.namprd11.prod.outlook.com
 (2603:10b6:8:c9::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB6375:EE_|SA1PR11MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a5d3be-f040-453b-a5cb-08db02bba03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /M793K3geMpdlJF9TiJ7M0ylXyon1VakNNYOieDyvXO7L5y5uX0rQNgNCGxWZ2rzhPQoyojyUFG8nr7vBgxWbBg/+ihqlvY6O3bUHOCcPJvJS/LB79regJEyyKfZahg12DVW7ZZDDPxA4lKxT2nWy9ABHT+QHPLdPLAUCAtPUutyNFxXmjroDtPtDk2HToGgfT0e7RYtf7HWoEvF97VQns2xkb3Fh0iRb4uOnP/oR/J4QbQlUrVKahHyZ+pUOXe1pJrKeHgzbpmz+SaTVEVtwYEQ4isqzTwm17nEDSxES9DLGTOxt9Kw09b9kBOeHW0xR6HlJCDEZDjo52+Rd0Fphf36Zl64RRD0k3qL9o0rLBKNR1HHhIDxCzUF+R9fadgNtcbd4SyPoncyfpu5Y4lKgY3/XJ0h+xmGYM78ZQl42zhzE1gvWSukkAgCSH1RiSzuxuFLZguRKYNLBS1M8XLDrX8Ct78tzK8dLlMyqAbwhpQiaQ4k9h3yO8gE7U8MW5ngfIbak5NHjNud7tVzNjBo/F+1l9jokUPmSJyITB2unKE7pfowRwoZ7duKDrViw5SIji8jvg2COLLX8YyazWaig2A1AjYpr/armipgLO+9vVNSflihJzfFuuBxYpNIBl+6sA6rMOK66VhXe/uISeLv0h6ZOzhndu6uLffyyo+tRxVwl0m37cvDnOPsjFSrjEOxNEGjxiPKKb/sbshPjxHfODXFEtMTsQwIzFkHYBdwdxE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6375.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199018)(54906003)(110136005)(44832011)(86362001)(2616005)(31696002)(38100700002)(82960400001)(2906002)(36756003)(186003)(6506007)(53546011)(6512007)(26005)(83380400001)(478600001)(6486002)(6666004)(31686004)(66476007)(66556008)(8676002)(4326008)(41300700001)(66946007)(316002)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnI2Z0dVR2ZyamdlKzJtNExMSXJDK3o0UFV0WjhpOHg1SFJGUlRsYzFrdDdH?=
 =?utf-8?B?ZjF0M3FWdGQxeGtvSU1selgwSWlxZWRPbWpUcGFPZWVxM1hGY1ovRTFJUmpO?=
 =?utf-8?B?MmRqZXUwMjhHaUl5cThlbFhoYk0zWDVLT1lLcVFDRUpSMzlMWDVyS3FObUJV?=
 =?utf-8?B?MnIxYXFxSFVDNFZGVm9hRWh6ZjFuNHNCcUxuSXBFOCtObWl6R2taallYNThq?=
 =?utf-8?B?aFhqTE80b3JzUFRWc3lPcW5xN1VOSmloamtBZFVSbUNheFJhak5nWHRYcnFp?=
 =?utf-8?B?UHpmeEUxWVArUmlMalpPUERhREI2aUk5ZWZES1RwZFVieVFoUGhNZGw0bVdp?=
 =?utf-8?B?VmxYWEhvUXVISk4xb1JLNGFUUTRBSlE3UUxkU0RnRll0YlMyRW5uVzBoZzlB?=
 =?utf-8?B?QmFzS1dKZ01YNkQwZXZQT1Y4MCttczRRZ1dkL0haZGMyaDBZWWdwc1BwaHRQ?=
 =?utf-8?B?MWM2MkozanVnTE45OURsK2lBb0pCU0lvZU9NVjZEWVJBOGtlMG9VWkdxZXpT?=
 =?utf-8?B?MEpkTEVidXVGNVRvSGFtbXFscEgrYVlOWmtVOGhxMG50ekc0bXo4ZWhrVzJh?=
 =?utf-8?B?RFlpaEJxeERKQzVIRGg1OHN4aVFZMTlNNFBuYW9rZjVmNkJBNW9XQTNyQW1J?=
 =?utf-8?B?U25CR3hUbFd1YjA4UUE3OEw0RTM3Ymw2QXdQbWVOQ3FzM1J4SlhtTkM4MEpk?=
 =?utf-8?B?RkhTbGx4S2EvcHArTHIvdjJFQUMxbERVVml1bHNLMW5HMk1MTURwejhJR1RX?=
 =?utf-8?B?Y291Y3JkZE1UNy83OXY5aW80ZWNGSUZmYTI1VXpEU1hwdEI1YXkvUncwSzhP?=
 =?utf-8?B?L0FkTndoak83QzJqVG43T1A5eGtmQUsvZlZYaWtrRjBLaWZJRUpqRVJoTm5s?=
 =?utf-8?B?UjZBSjhiQTVjbTFNbnA0dVB3STc4RHJpb3hsVk9tNXpiRVloK1cyTUUxSnRL?=
 =?utf-8?B?TWNFYVNsVkZPdmdWZ3AwMFdCcXJkVDkwUTNuUnpOVUxJKy9TdkpkbngyaFFG?=
 =?utf-8?B?dWZrUUNITVVqaGNQMDFtV0hRbmQyVkltMzBQRlQvbC84Z0NvOUZLKzZFczRr?=
 =?utf-8?B?NWN4SEtlcGMyaXVscFNkQjVDTExjdkNHcm5xTjdGMDdlWlJSVEhmRGF2a3o2?=
 =?utf-8?B?c3FWZW5lSzBhUWcva29XVityL2x4bXhldVcyVzRmODlvQWlpcUptenRKTXBq?=
 =?utf-8?B?aXpyVkFyZkpQblIrRVFRT0c1SHZYbmc1YjVoeFBPWEIrdFZiQTF6WGYxclNY?=
 =?utf-8?B?Wkp4VnRQREZoUFNFOG9Hb2NSTSt6MDkyR3QzVjh2Q0JFZTd5Y3liTG5GUVJ0?=
 =?utf-8?B?T3RCQjQyVVc3bFF3YmlsTzl5VVJHbzM4MFEzL29VNUJxTm04YjB1NkN0aG9x?=
 =?utf-8?B?WW5CU013Y2E2V1BIWHp1dkxNdnBUUEJ6bUpqU0l6ZXllZGQrL25PcDd6WndY?=
 =?utf-8?B?ZGRpSk4rQ2dJNDFIRHBDTmxCaTIwcEFNb0JXODZOeGxmdnlTcDB2aUNuREJU?=
 =?utf-8?B?VVlqaHdhbGM0QWRPdy9kaC9CeXFhYzl1NDBPckxOcHFHWHNSdTRHdmZEREhW?=
 =?utf-8?B?YXBLWFZwS1BCOUc1SDMxTFRFZ0hXOERyUHVTeE9yMUxtbDNVZlJXSXNLaWhi?=
 =?utf-8?B?ZXpSSVYrbzFDZEF3NVdqZ3Q0Njg3bndzSFg0L0hHbTlFRzQ0ei9QTnNoY0VB?=
 =?utf-8?B?RUI0d0hSYkhiR1JKMXZXWWNNRDFwUjRTT0lmUWttZ0JtVDBwc1FwR29La0I1?=
 =?utf-8?B?cmRHa2NwZTE5UkIweE9LS1lwN0xZN3dHeUlJV09NWG9uY1h4SWUzOVczUTB0?=
 =?utf-8?B?TTltTDl3K1RQeWREdmduSmQ1TVJla21CaDk2WjFsa1pIMXk1TzF1V3VNbkJj?=
 =?utf-8?B?cGxQZ3ZWS3h0TVRBYURVRVdLL0FDOExPSVkyZllaTGhrNjk2MnlhMEFVMEdw?=
 =?utf-8?B?T3I0SFdXMWwzSFExeDJ6c01UZ0trZEhtSDhuM0VGOGY5Q1RRcWZNNGVTeGxy?=
 =?utf-8?B?aHBqeTNsQWlhWXgybGlQM2ZxSG9iS3FPYkMzR3l3dzBQSjJQcm5FTTdtZkVo?=
 =?utf-8?B?YXdFODlzQXBTTXBseWgrT1poZlpQeXBXL2dBSVF5Z3NoZk1nQW1ydDJvQzhM?=
 =?utf-8?B?NUQyYVcxMHdXVFdOQVlVV3ZzNzBTaHZaYmhyYi9iVHhMUmd3M0EzOGFGekZp?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a5d3be-f040-453b-a5cb-08db02bba03a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6375.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:15:07.5894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pf+STDOUHrXwCDI74d3YyhjRv9tLdELx/s0gSot7rsaABMfjU0f38eQNsA440j1IOXHOGfuF5qNvdPCao9M839GG+nKkf4UtU9bxdX9vacQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-30 12:27 PM, Linux kernel regression tracking (Thorsten 
Leemhuis) wrote:
> On 30.01.23 07:33, Jason Montleon wrote:
>> I ran a bisect back further while patching in
>> f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338.
> 
> Cezary Rojewski, you authored this change which appears to cause a
> regression. Do you maybe have an idea what's wrong here?


Hello,

Sitting with Lukasz and debugging this.

Please note that messages seen in the logs:
[    8.538645] snd_soc_skl 0000:00:1f.3: ASoC: no sink widget found for 
AEC Capture
[    8.538654] snd_soc_skl 0000:00:1f.3: ASoC: Failed to add route 
echo_ref_out cpr 7 -> direct -> AEC Capture

and:
[    8.614993] rt5663 i2c-10EC5663:00: sysclk < 384 x fs, disable i2s asrc
[    8.617460] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense: 
disconnect for pin:port 5:0
[    8.617581] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense: 
disconnect for pin:port 6:0
[    8.617712] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense: 
disconnect for pin:port 7:0

seem to be just noise, these are present even in working configuration. 
Looks like topology and AudioDSP firmware loads fine. However, one or 
more of sound cards component is deferred when probing what results in 
no error in the logs but still lack of audio.

We managed to reproduce the problem on Lukasz' Eve machine. If hardware 
cooperates, we should be able to narrow down the problem quickly from 
here. Our suspect - something (a patch or two) is missing in sound/soc 
in Fedora tree. Our CI which also covers upstream skylake-driver with 
HDAudio (e.g.: rt274/rt286/rt298) and I2S (same examples) configurations 
show no signs of regression. Thus, this is probably Chromebook-specific.

My opinion stands at - none of the patches mentioned during the 
discussion is the real problem. All of these were in fact addressing 
real problems with audio stack stability/reloading.

Will reply once more is known.


Kind regards,
Czarek
