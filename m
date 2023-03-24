Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2246B6C7790
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 07:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCXGDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 02:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCXGDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 02:03:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7638661AD;
        Thu, 23 Mar 2023 23:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679637808; x=1711173808;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sMrx3FJgz5UGOVKfHWgQBRwfCEQnyEK8QVd1vDXwUq8=;
  b=L+3lPbgprdLOmHjBp5pmqvLTNahjXFlcQbLT/W4PGkpgfoSQxNw1u+vK
   NkNT/RP7pikQ7xdfWB1jGnUE7SQB4FR2mOjKPrQvWLxxEyqA3n7uC1kUV
   WKVB/eL0Oe3/Usi09Kyyd6JguJc/nV2/mcq1wFDmsv3dNjO4LABHArkls
   MOl6ccH+Vr+yqDOOd6FacB6jp9cF8a+FCPfBZXSbwfnsyn7RY68TxJlzj
   BnE/FmBB/h/ZmgvkUEKU8zR1yY5OtIXg6w3LMBuAQy1z0aAsAHKyOth8R
   8H53euZMe7X6VoDDiVLPvy9DAcDBwhyC55lFHLJ1eftA04Uw5BVHkmIM1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="338428159"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="338428159"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 23:03:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682560653"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="682560653"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 23 Mar 2023 23:03:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 23:03:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 23:03:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 23:03:27 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 23:03:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+5YN4FnrNG+8Ra9agQNAq7TYGWSxxQUKp/ZiiKzmO5Vg0U+TF8Z8HLvS310jroxtaw8bASxuzVIEXyvcKyt4Jjp/xvGBTSUAAHLh3G8Lo+IHqXZtTN7tEeBnQwuMRkN/YPVAAIMF9P8Y+MqJijyy+EmfkILSorvRmqVh4VGmB9xK222fFhQoljZ033uFtydwBJLicnRHS1rNis54PvHfQ9aUQy/qhjibWMRbuWaBcH1/wiATjjrvm4obmbg0++t6jnTZWBEHDvSNiRO7yk+kaS/PTeaB/kHCfzGR2sraqSi0eSM80yL/YyEBSFfbRIFeUbxwuyFMna8nL63CQbq4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSbl8fqGmib22ECEtZmweHUNic8Brb8eeMnTUioxf48=;
 b=k2rV2b5JDRj+XykwpJm+1JWRfons84B0wjS7ryzkBycEdmCLgwl9hVD8Rs7bxNk+2oBVbF8hFpT8HrcVMrzi//k4hnBvG0XDzfwySmHhnRXFEqvmcT1782Wvd47wCULlN1XmGPdt9dw30H8TC6Imh+5wH94vhHLJIezyyHq1jKczwT4hexGuEkTChAILfCX18gRavKjWCsOYeesvlGzDcuhhcY67WUDkWd24nuT53Gl6W7Ck9DMbBvhYQAs6gL4zIkJ8P1x508z5IlW2mNxJY+6qYBic61ADq/08WOVN3WAX9yJaoG4riQnrnVhsbALluw+rDTeqwOIKqitdvKFRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 06:03:24 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745%5]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 06:03:24 +0000
Date:   Thu, 23 Mar 2023 23:03:21 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Borislav Petkov" <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, <david@redhat.com>,
        <mwilck@suse.com>, <linux-modules@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        "Ben Hutchings" <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <20230324060321.c2szz34n6zggvubj@ldmartin-desk2.lan>
References: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
 <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
 <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
 <20230323150125.35e5nwtrez46dv4b@ldmartin-desk2.lan>
 <CAB=NE6VtAn8tew723y77KAN_w-UYE+naMaVrKsLjxpJgAkwDXw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=NE6VtAn8tew723y77KAN_w-UYE+naMaVrKsLjxpJgAkwDXw@mail.gmail.com>
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|IA1PR11MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: d272b034-945c-4918-cc70-08db2c2d7a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RW5KjAhsQ/IF7eR5KSMuis27lxO4rPskQv9aUd6f5Je27XmeMeYbgcuj7goZW7+7+wT6ZYqdYr+4LIhbKAuBTAG6wBBTpefoRI0oZusNni9jJno9BpwSpLQPqq6AKK2jRe9NeUE+nF0G5ByDPd73Fk1gRvKShM/7C9G+4aj3nIgf2+MZjniQet4wyTVmXI9Bmr7q3X39jaPGzrPtQuL0YzHIxuiFspzHpI+zXsweiCVRTFlSVgODOk7r9Q+TnrghbbALgchzGM5SsEyCbCcWwAbYA/SNkzgFbitY+em3Gixw2Owv5AYRiO6DHlmlVOF9TwXbHaRzVMJ3O1CuzC0oMY3PypgERnUiHg6xlCkUEEokLRdT/ivZSWzSWXAvzl4Df8uUU4SVz175Fq+1UxIv9Qghw5Sg6RgEkqeJqbmRNabXicP8yWkpTjwmwySfB28RUQBgw/WqlVG/C3/jJuWt3cjKGz7iLbjXZhZyvAd3c+I+78ZIOuDogGHRBSu1k+P1ybJtUDBJPlgT7EKopPFlbelvYCzB+kqShQa4QDnNfdvSJ/3d2zwMX2poigvt+Jfc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(316002)(54906003)(478600001)(6916009)(66946007)(41300700001)(8936002)(2906002)(5660300002)(36756003)(7416002)(186003)(4326008)(8676002)(66476007)(38100700002)(66556008)(6506007)(6512007)(6666004)(1076003)(26005)(6486002)(86362001)(9686003)(82960400001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHJsekVNTGhGNTRxcUlKYkk2YUJMVW9NNGlYQ3cvUzVlZ0NQUGdjUklKRU5I?=
 =?utf-8?B?RHA1ZFlMOFBJRkRBRVFtblpPQmJkY1gwUTdiWm5Ib1VsbThLQlpoNjFteXVv?=
 =?utf-8?B?K1lSdDN3U3paZTk0bHJzSldHK3A4OUdqV1k3VlhzMTV0QnFTQzRCaHdnTEpy?=
 =?utf-8?B?SGR3RDBTYjRsSGoxOUhrckRkQ09uYkFGa1RWUkoydlBEVkJiWWgrZE13UEUr?=
 =?utf-8?B?M0RWZWhkWnQ5YzdHTlpLSWhyVnZybjlkYkR5TTVHR0JTOCtkZWxrejJaZjZt?=
 =?utf-8?B?RlZIRmt4VDg5WjJoL0tHaGx0RmtaTzBGUHdYazQ0U2NGSmF4bjdlMkhaQXQr?=
 =?utf-8?B?R0c2MS9GYXJOcHhCNjM1WUlWd3BoN0k3ZkRiVWdlVFpnNWU2bTJGWGpvMmdN?=
 =?utf-8?B?NVBVelVkaW9aMzJqNGZWVXVYLzh4enQ0VWxXckF2VEMvUEFLL0IzZVVQYjQ3?=
 =?utf-8?B?S0g2RGlmSi9qQXN1M0p5ZTloZGNraG8xL1JzZW9XSG55R1MvM3YydDk3RWJ0?=
 =?utf-8?B?S2g5TjVqY1dYUExvRWs1NkRXcE1YRVJ3enZxS3R3YW1Hb01xV2NVb2pCQkxH?=
 =?utf-8?B?V0l6ZTd2d1JHV0dBNjdXQ3plVVdaVEx1dDBacVQwVHgrYUI0M09RYjlPaVhx?=
 =?utf-8?B?QXhxeER2VFgzcGFVYkNDcndUN3N3VkJVd0c5T0p3OVpZRkorazh6YmNvaWFP?=
 =?utf-8?B?aEo1c080R2VZcjlLckllWDNtNDQrS2xwQjVuWWUvSnhOaDRidlNHNThvT09j?=
 =?utf-8?B?UkhWSXBUTWIrb3R0YVBxdTY4R1hVMmVsTjArVkRLSXd1cFZ3RmJsdTFwMFll?=
 =?utf-8?B?QlNSSTBqNTlweDhlcmRtVEh6NGRSY0RlR1ZkYnRpcFJQaU5JL0d2enNVWjJ6?=
 =?utf-8?B?eDVaRVRwb0Q0WlZqYmJjdXM5S25Kckg0T0xQL2lwVC96V3ExYWg3MjA5dFFi?=
 =?utf-8?B?NnYyay92akhnRVFIQ0FBbmIwYTBJaDF4bzIzRXV4SldSVXdGOGE2bnpWZk14?=
 =?utf-8?B?SG5qcHRRQkZ6K0xEYUkrQ3ZzV1ZFR2V3NmpMbjhXNEYyZFdKaUllVmVUekdr?=
 =?utf-8?B?cWduTkxFMlU0MlRhK0V6NkJ5Q0pnd3ZOT2hQakZSSFVlWkxhbGdYV0lmNkUz?=
 =?utf-8?B?dFF4U1YzV1o5MXgxbEF0RG9oZDdqbXRNQnhtMmc1UmdkL1pIeVhNWnIzdDdW?=
 =?utf-8?B?MjlRWkNIWUMxZEZlb1FFUUU1OE82RkJPVmtobHFSd1BpcEZrTnJ6V3ljRTVB?=
 =?utf-8?B?OTVkK2VNQzFqSnNlWEZEeGM2NlRDbUFrdDIxSDJyc2c4RHhodGFiNlBValVs?=
 =?utf-8?B?R3d3UzFmYnRYdDU4WDFuSDgxc3NZWm5SQm05ckh1Q0djeXNMVFlkWngzWnNK?=
 =?utf-8?B?MUZqWWU1Z2NkZnhmcnZaRy9CRnpndlhDdWovVTVnM2NVejZUQXdjdloxUzdt?=
 =?utf-8?B?NGZPOCthRExyYytCVi94VzB6eUlrZVA1WGV0R1YzK2dJckxRT2lVaGJndDVP?=
 =?utf-8?B?VkVFS1FwdmNONGJtVVQzbDFwWlpZeHRCTGVVZ1ZwVkJndTl4T1FsUXAwemg4?=
 =?utf-8?B?clA1WTlydTR5WGtXenR3ZVFQRzhSZy8vV3lJdU05NTVBWUN2UHBYR0pBQjAx?=
 =?utf-8?B?bEo3VjQ0UndnMm1YcDE3M1AzemdYN3ZmQ2hETjNjWksvR0h5ODZBbTNXeVE4?=
 =?utf-8?B?Z3pyMjFlb0tPaWNYb0lDUTc3TDhFMnVic05UM3hVeEp3U0gvZFBnMXNObmFx?=
 =?utf-8?B?M0VGSTR2VVJ2dE1VSGdoblRZMDdYOENReWRsV2l6bUExcHdBR1EwZE9laDRR?=
 =?utf-8?B?U3ZHZzZEOUlEbi83QnV5R29QMFZENEdMMS9vdFREYloxcDhWMTJhNStCYW0v?=
 =?utf-8?B?VEY5d2ZWcGdEWGdvSHFzTHB5SmMydmlkbG01MmVRbDlTOFQrckh2d21hbE45?=
 =?utf-8?B?N3hPWUVMRUFWckpkNVpjZ0pHUW1RemVnSGRqL3loSFpHRkM3WDl5SC9YT00w?=
 =?utf-8?B?YkZOaCtKY1BIeHpXejN0TzQ0WjZEOEZIQ2NmTmtEdzNTZWtvcE9oUVhJOThs?=
 =?utf-8?B?NGNlMmtTQWFjQ3VqZ3ZhZ3MxV1diVkplZGpRMFpFRFJYYlArQ1BVc2lSWXhH?=
 =?utf-8?B?ekFtamlDYjB6M1p3RlFPanczRGUzL3ZlZE1ENVlESWpoQk9sU1NxemIwUlBv?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d272b034-945c-4918-cc70-08db2c2d7a81
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 06:03:24.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxdZKPOcFf++1rfIdLry7a8oexxuJM5eB5WTQNaKG0slUvB2m+4TXJzsmBlyziJcCxhFro5nsYefLp0SPOGhLfWDDymFlTgKUVzM3ZS6jRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 08:08:49AM -0700, Luis Chamberlain wrote:
>On Thu, Mar 23, 2023 at 8:02 AM Lucas De Marchi
><lucas.demarchi@intel.com> wrote:
>>
>> On Wed, Mar 22, 2023 at 03:31:59PM -0700, Luis Chamberlain wrote:
>> >On Sat, Mar 11, 2023 at 10:25:05PM -0800, Lucas De Marchi wrote:
>> >> On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
>> >> > On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
>> >> > > On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
>> >> > > > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
>> >> > > > > Yes, the -EINVAL error is strange. It is returned also in
>> >> > > > > kernel/module/main.c on few locations. But neither of them
>> >> > > > > looks like a good candidate.
>> >> > > >
>> >> > > > OK I updated to next-20230119 and I don't see the issue now.
>> >> > > > Odd. It could have been an issue with next-20221207 which I was
>> >> > > > on before.
>> >> > > >
>> >> > > > I'll run some more test and if nothing fails I'll send the fix
>> >> > > > to Linux for rc5.
>> >> > >
>> >> > > Jeesh it just occured to me the difference, which I'll have to
>> >> > > test next, for next-20221207 I had enabled module compression
>> >> > > on kdevops with zstd.
>> >> > >
>> >> > > You can see the issues on kdevops git log with that... and I finally
>> >> > > disabled it and the kmod test issue is gone. So it could be that
>> >> > > but I just am ending my day so will check tomorrow if that was it.
>> >> > > But if someone else beats me then great.
>> >> > >
>> >> > > With kdevops it should be a matter of just enabling zstd as I
>> >> > > just bumped support for next-20230119 and that has module decompression
>> >> > > disabled.
>> >> >
>> >> > So indeed, my suspcions were correct. There is one bug with
>> >> > compression on debian:
>> >> >
>> >> > - gzip compressed modules don't end up in the initramfs
>> >> >
>> >> > There is a generic upstream kmod bug:
>> >> >
>> >> >  - modprobe --show-depends won't grok compressed modules so initramfs
>> >> >    tools that use this as Debian likely are not getting module dependencies
>> >> >    installed in their initramfs
>> >>
>> >> are you sure you have the relevant compression setting enabled
>> >> in kmod?
>> >>
>> >> $ kmod --version
>> >> kmod version 30
>> >> +ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL
>> >
>> >Debian has:
>> >
>> >kmod version 30
>> >+ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL
>>
>>            ^ so... mind the minus :). It doesn't support zlib.
>>
>> Change your kernel config to either compress the modules as xz or zstd.
>
>Oh so then we should complain about these things if an initramfs is
>detected with modules compressed using a compression algorithm which
>modprobe installed does not support. What tool would do that?

I guess we could add that in depmod side as a dummy handler for when
that config is off. Thoughts?

Lucas De Marchi

>
>  Luis
