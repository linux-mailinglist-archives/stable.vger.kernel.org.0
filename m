Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398B4682CA9
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 13:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjAaMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 07:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAaMhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 07:37:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F10298F9
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 04:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675168619; x=1706704619;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MIlIYF4L3kSSp4C5S50O+0BGzPwWUwf4kqz1IL6Z+94=;
  b=cfrpMM/Oa2e0mjS+Ert/xW5fNY41S5wmBz+xxrkMmt9sy/fLxDe3axcl
   TpVogXDxSgOWil7/+hBfkRio11Yg5AYULKeA0UFB3D1D4bRcVFty85EIK
   vg3VzYLSjDx+eDF5qtO5E+PaszsU35ilxqzcdbdBu4Ksb4roOwy5KMnKJ
   JT5t1HhQ0lzHoXDcXdiXhvdBiZl9p5guddOUlyBg5IHXmBDsnf80k39pn
   prMtVEo6u66twdEqoFs9cKTdoOVnazO7AOxcuBQlxv2JPJbnONJOL6kxG
   UUn5vmUZglmV/DXPIfdWV2Y+VGViu54R6/K+JA5k+ZiBqupIWnDP7OS7W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392376962"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="392376962"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 04:36:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="772959185"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="772959185"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jan 2023 04:36:56 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 04:36:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 04:36:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 04:36:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 04:36:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ8KXbp/H6FSYqcUiXw16jecfqOBM0w6g8XEMYhYmPLoW/KxGS4VKSnXEFAUqSoidfzRbfQpf5VWyW3Z+3h5pKAXDt5MnOt8eI2HSRJ7Rbel2mKhOf6V56dx2mLy83+h/mhWoEeRi3k+4HxENxSuEyhrSxh7ZnQDVMlS3eh6k/uVj1NEAcSC5gB/2AydlYqLHyrxUTIElyMOAp6sJKGtH7mC3jAQXcKVmLxl63yiHvgZAQoOKZSTvp2mUKLVIL8xnC/Om4x3NYH0OLNlKze4MPU2IbUtS89HBITe6Ej5HBqsopLFJFm3MDe+cZQf9aM3LvRw+2OLHQYShMa/R/67KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82twPZij5IXhh0d6IFJnraraiwxw6tIWMbheyBzBkBg=;
 b=e3VIIxrmw/SV4D5vqYst5fnrHVzd9lSwRUwgdjS8DKl+yGOWXFs/pKshQVVCZVcBVCtjiQvR3CWgA/7xn7FpsYEjyuImEcx+V75FimlXLrXgEbtBeguF0jgBANDKnWrczt0neBFKkocbwuYEs2eVYVf3DyqezMCI5TInY8AuQ9s+4K7F0A/X7DfIIefcI0jL+FwMkKZfhNuKwQ3jMFRUwV9uCt3Ql1tX+pAmKWoEvjFqA9HGq8OdkZfdyEyP4/EuZaZwDu597MT5VTJmujUrju0579Zy8K1GKvL5oJlYEppkugXa8XtIJoE0PO5hNEqz7kclETj2fiYeSh3dW+fkgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) by
 PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 12:36:45 +0000
Received: from DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8]) by DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:36:45 +0000
Message-ID: <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
Date:   Tue, 31 Jan 2023 13:36:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Sasa Ostrouska <casaxa@gmail.com>
CC:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "Jason Montleon" <jmontleo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <stable@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>,
        =?UTF-8?Q?amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
 <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::20) To DS0PR11MB6375.namprd11.prod.outlook.com
 (2603:10b6:8:c9::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB6375:EE_|PH7PR11MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f5d2de-92a4-463e-89f5-08db0387d063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGPY9FEbJAP/kLEwL5OXYTYo8l5+mAo2D4idqNd7WNUK2N0XwNg6qJU8pKDa/9uJr0Oq2MrxK00GVnPxU1LL6p0Ut009e9MLlOH0BcX81+LyILBAUe6CEOeNhFxRao8HqRvKUB/8v8/xqyFmEtFuravxR3tHCUk9aFu28VCeS4OICHuofU3p41I1eBXUNlIXvwfs51f4DendKqOibLfeYa/bqpifX8kH+fgKenKgcKxkFuo3VHNbVbNRo8Yw9dvFG79gPXw2xQvoY/OIwisAOHJvHmN1KouvbcQ8G5NVuLu8TaR2D0pvdtn0PK+15aD8p/jmtSp6Ds0Uc6wlpxeiVYu1gYp0CQ7mh2xAFsvGsnDqIiA98eZMIoSrLcivQALR2P8S0GyasYggOiP684UArPekg95uy7YM9Ghpe+vFZIENO5XTZw2I4xCw8Mmw0wzA5+yI23IlrPFJx0VD2gDjCE5OKKx1E8jgzKqnYiIK7/dnz4FH3FCSEHopmZD8dE4tcAC5Q8rBaP0uzod99WFmBSD8YKBxl29kdwu9ypwCK7WdZGy79mlSzS40YA19koHB7fTbIVtIb5TnZFa6L6oJgSbY1RyvAEwROFIifMYKH74OQG3lSvj1JJQ8ggbrSp1Lb6J9WNQpp23EPHT4aQBW422JJxFiy9q+2GYM9cr4lRTU+wCa5D94mka/Su5+ziNbC2PZASEDNazzl2GMS6Amzfx2aE40Q4qfNOjUjXGgiid5XjB/F8pslpH86SiIKmmIECXI+ycMNYKFIFOS0zR++w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6375.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(31696002)(38100700002)(83380400001)(2616005)(86362001)(82960400001)(2906002)(478600001)(6486002)(966005)(66556008)(8676002)(66476007)(6916009)(66946007)(316002)(54906003)(5660300002)(44832011)(41300700001)(8936002)(6666004)(4326008)(186003)(53546011)(6506007)(36756003)(26005)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGxMSFNhY3JhSzBKakx6Z1U0aEhaY1JDaVl6SWVENG9GYnhNb1lwRVNsSG9k?=
 =?utf-8?B?TC96bStnUUxocmRqRUp2UVZKVExlbVVPamNOYjM5REViOWNPNHJCZEllSkly?=
 =?utf-8?B?RGMxUE5oUllROENxMk5LYmE5cHE1bWcvV2hkMU9YV21GT2krNStKclV5cXZ2?=
 =?utf-8?B?ZnEwQW9hMHVDZE5qY1hyYVlKM3NXeTMzTm1KdFBuK1lpNGY4dTRPRXlCUWtt?=
 =?utf-8?B?eUMzenRsWjAvSEVRV1BMTkNZRW1YRTB0S1UycjRnT01SNTF5SGFBYVc4enlG?=
 =?utf-8?B?bWlpZ0tTK2h1QXR0aWlET2lYUSt3Y1dWVEtseGhydjg3Y1MvK2pUM2doOEU3?=
 =?utf-8?B?N2xFeERrbTZXUERDbE10S3lDTS9nS2FtQk9oUFN0cUhVL2Z2Q29PUkxkTUMr?=
 =?utf-8?B?cFJxT0tWNVNET3k2RFA5bktSOTg1RGdBR2RrdEhTMW5FaXBjYW9ESFpLQi93?=
 =?utf-8?B?VmJmWVo3S1NkSWZMSGVpMjcwa3dKQVdxYW1aeHNQOG0zS21MakJFbEw2RGwv?=
 =?utf-8?B?YVo2cCtrT056WU03Mm5ZNDArSWk4cU1OMXM0MGErMTJ4ZXdVVDJoS2dqSDNE?=
 =?utf-8?B?S2JJZ2dnVVoxeG0xUTVoMHhRN3YrMkZnbnpXNk9VYWVqdVFGSVlaU1FDRUgw?=
 =?utf-8?B?aEREOUUycnF2SlYrczArUGJ1aVdFL1lvazZEM003enliQUdNcjczZEtGcm1z?=
 =?utf-8?B?WEU4N2hJU09KR0Fzd01IV3A2YTNjWGRIb3ZCOXlUZnI2OVNRMk5DaFczd2J4?=
 =?utf-8?B?ZEVHNUQ4clZGZ2V2K3lKeXpTYzNPUjljYlhmTS9tTjMxc094QmVCK3VhcU1u?=
 =?utf-8?B?RWpsNlladUVsRlVSVFY3OXFwZHg4K1R0K0ZyS2ZQK3lTSTZnTXhUTjZFZDFk?=
 =?utf-8?B?WFNIYWVHQkNtczIrTzdEQWdjRmJEendjQnJlYitLYUxnZDc5RU9iQXlDamVm?=
 =?utf-8?B?cmU2blN2SmlQWWZpRU96dlJEV1A2b1RONzRPdTRDWnFNUTM3QXA1OVNVNkRj?=
 =?utf-8?B?aHhobXFDUnVNbkhCTUFSRGZLaDVWbWRTcThubE02TmMwQU1paWpyRjJMYno5?=
 =?utf-8?B?Y0pvWHpCdWY4QitFcXdLeWVRZmFJVFBWVjNQemxZMzlMWFJNaTBxdnJNQUg0?=
 =?utf-8?B?dmp2cjJKTXMzd25EWlpyL2Q3aXpyaFdvR1NvUEZaS0FaVWUzdWlRY2VLcTcy?=
 =?utf-8?B?MkJObCtySy9KUnZHUVdoUXAzN2RsdjVIN1Q3RG5oNi9WbGhzUlBsc0hQdldJ?=
 =?utf-8?B?TmhIWTRsRHRuaEtQd2s1OXc4SE5iZldFVnhGNVQrdHBkQmVIKzVmMHlUMXhW?=
 =?utf-8?B?dmJ2eGFWckpwR0FZZkNPekYreTA2K1JOVmZXQjZBeENzdk9qbjRpeWZRRDNq?=
 =?utf-8?B?aTVPcXZCMU5kOU9JaGgzQ1BvK2lPcktpamptbmVZYmN1ZDFvVjBlVTg5THhL?=
 =?utf-8?B?bitKOFFYS05JMkRkb0J4OWVWOGlXVFVEOUxUZCtoRHNKcTRrNDRTaFI2bzRY?=
 =?utf-8?B?MU44OTZGVk0zZDRIRkQ0RHNPNDUwVWdxYWx3SGZsdTJWNEtvTmxOUzJYVzBh?=
 =?utf-8?B?OXZSRW42NDFlaHlNdUkwRzhoVTJRTXhZOXhvZjVySlpTVEZYUE5Td01GZ0gx?=
 =?utf-8?B?VDZ2M205L3dvQ1B6VkZybUtZUVVmTHl1N3RUNER2aDFmNUh4a0Y3U1ZWcnNm?=
 =?utf-8?B?S3Zmb0x1bHEwT21kcVBGMW5XaVJzRkFSTHdhQ085Q09NR0ZWek9PNG56WCtT?=
 =?utf-8?B?NkQ5ajM3MmhaVXRuL0ZEMzJUcDVGWTZYMW1tNGdoa2h5aFR4MFJxMkhWQkFh?=
 =?utf-8?B?Nks0bnk1N0J3Q01kUlMrc3ptKytuZjNjSWsrNEtCaW0zUGIzcWNTVlNnTzlF?=
 =?utf-8?B?eUppcThYMUV2OTlDZUZocGJ6VTVoc3F2dVlCSVg2NXpoQmdPbHVrd3ZXZFJF?=
 =?utf-8?B?UjU4YUlROWZ4Lzd5ZnloYkovMjVxNCtJWjF4Tm55eDdhKzAxNjROTVRPdmdJ?=
 =?utf-8?B?ZzVtMU1UVE9OaUd1eWtlQzZjNEc0WGJnaEsweFpWN0JoK0RuYWE3NlNwaHdV?=
 =?utf-8?B?cDB3SzBOVCtqMnl6Wlppclh4bWR6RllRbDZzWVNTZTNiWVprazBobVFkNEpN?=
 =?utf-8?B?K1Q1ajgzRm9UbmtkbndZbnBPTVN1Y1ROVjduU0Z2Q0xvY0FzSFltRG5ldTB4?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f5d2de-92a4-463e-89f5-08db0387d063
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6375.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:36:45.6271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5aS5QNKGr/3gPuNFgaqOS3OVsB/9hU+aoFHxEhStQ8nlR+O1iZxyCyTbxtXx8BeuLvyt2g6IcpW9IWc08TSkkMrhl6XwbFOKLL/aOSyEMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
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

On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:

> Dear Czarek, many thanks for the answer and taking care of it. If
> needed something from my side please jest let me know
> and I will try to do it.


Hello Sasa,

Could you provide us with the topology and firmware binary present on 
your machine?

Audio topology is located at /lib/firmware and named:

9d71-GOOGLE-EVEMAX-0-tplg.bin
-or-
dfw_sst.bin

Firmware on the other hand is found in /lib/firmware/intel/. 
'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an 
actual AudioDSP firmware binary.

The reasoning for these asks is fact that problem stopped reproducing on 
our end once we started playing with kernel versions (moved away from 
status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP. 
However, we might be using newer configuration files when compared to 
equivalent of yours.

Recent v6.2-rc5 broonie/sound/for-next - no repro
Our internal tree based on Mark's for-next - no repro
6.1.7 stable [1] - no repro

Of course we will continue with our attempts. Will notify about the 
progress.


[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.1.7&id=21e996306a6afaae88295858de0ffb8955173a15


Kind regards,
Czarek
