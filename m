Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F83691F95
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 14:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjBJNKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 08:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjBJNKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 08:10:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D344A23877
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 05:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676034602; x=1707570602;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f+OvfwKfprcc/acaFkv5Qci5DZw8PJqhwKPv1PQ4ins=;
  b=JSQOURW7kaXqaUa2R1xFfD6AfRGpXfgGdPGuo6xGrs2PPfB9ShKaigOR
   FHTUF3trQG117F3dEk+dnGPTQAqPG+XuAhPk7Cvpcv2Y8+KIlgVj9OCh3
   hOgb9cCmL+h7qlvuq1eU+ykTgEni/a1BHCWSYECXofFNkWfBe6aij+nwS
   4HEMNwLRLxhbNlNlCT+hw4Mx9038WRbfdYNUswIorQQoRkRyNL1r1Ovix
   kQkZzDnpyJdggg2yI4erIeBW8j6zwcj6WCzxdIjj6Q9ooaxUuWZ8MV+UX
   qLgzt36sJ1GfzFmsYJ93rqO06ezV4Nixf0avdNp5QaQc6iY16ww7iMjVK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328104153"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="328104153"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:10:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810816374"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="810816374"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 10 Feb 2023 05:10:01 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 05:10:01 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 05:10:00 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 05:10:00 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 05:10:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCaf5y15rYzqITxeBmkg7zhQ5Eit2MfsKQbKTt9GFW4/g0fl7Zt1Bl6WQe9HXQvZxlSZ1jQZeyTdvb+24LptFByLdsWiVy3dp2gjHOE3T7FYk0vhrAVzeJT+DFm59WxwCgs+ziOaHGcGHU30JAs1bums0tdNnue1DV5hdc83SnSrJCCtwALRo7sUaF65Kg1ARQP11SUaM7SFAe5LK7+pK7C3XXrW2DBuxqJJfVbcaqWqtix1v6zCo+jZRNftWTbE5pHr2uPyzm/Cn6/iPo60acrzkygvPEzN/mJ9jpe47N+Y1vAmICZF2Fy4FYvLI4y791CJZiFQU2mwLdHZihu7MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVVF/v+fxv8N6JjPY6e2TV1JxWMZchURj08xSnHY50g=;
 b=OSSLE1kCt27hQluCubJfNXXOBHp7IFB/imhlfbB8AqIXTbZ1XDs5w09AJ8QkgXz95cJKzoujq+csLdP+BuQgbgmCtECohq73BFo69WlmEdz2w88hOuWAHMv2CYUi62xcDhouM89hxmkp11Meh//p7povg+wuT6wS5VeyZ52rCndq0FyCSFWZ6WqiTUmPg+hGBfRG3fXOk0A1xzFQI4uctRYCkYIa2JNP6KVP4t+3m3ugdLOaOeAlgVA+iVR0G7BS2loSOD4rWE/Jh6ubbzz7EDj0vwGFCmVAY6b4QcgZE4EQv4upbXeEBYhf5/GrpUET1qlXyY0ybS156vFfxuwXPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) by
 PH0PR11MB7544.namprd11.prod.outlook.com (2603:10b6:510:28d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.19; Fri, 10 Feb 2023 13:09:58 +0000
Received: from DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8]) by DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8%9]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 13:09:58 +0000
Message-ID: <478bb609-8615-31b4-e6f3-8eaaf95b84d6@intel.com>
Date:   Fri, 10 Feb 2023 14:09:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Jason Montleon <jmontleo@redhat.com>
CC:     Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <stable@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>,
        =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
 <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
 <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
 <6262bd72-cc2b-9d2a-e8f0-55c2b2bb7861@linux.intel.com>
 <CAJD_bPKxbsDi10FGX2mrMeuxcphDOvO8Q87j+AvnnQpe5cvmSA@mail.gmail.com>
 <CAJD_bP+RUemsss_YiAZ5v08ak8aTzXCB0gk7q623zyF455bh7g@mail.gmail.com>
 <a423c627-d303-3b50-5f11-78c06ed3b985@linux.intel.com>
 <CAJD_bPKO+zCeRojkOr2uY+nXvhsjO3Um86Lh53ZCuCUm3Ci3PA@mail.gmail.com>
 <CAJD_bPJfT5DA8EdN+timzXa3-itnPD5epq552S=NQ6Spr7iTUw@mail.gmail.com>
 <CAJD_bPLHPfLO=192Ohrxvg5OGtAfAgTim0O+fdmxo753VS83iQ@mail.gmail.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <CAJD_bPLHPfLO=192Ohrxvg5OGtAfAgTim0O+fdmxo753VS83iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To DS0PR11MB6375.namprd11.prod.outlook.com
 (2603:10b6:8:c9::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB6375:EE_|PH0PR11MB7544:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b25277-0836-4512-6f1c-08db0b681c38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBTKdUKmkzbfoVPlzRN/dWKSaDDoRWEWZV9bszVOG7WAdnAOp1Xr74XtHAEXJ8zMSo4WVAZPB4g3qKj2lk6e3nFkRIMURCxIwrusTsso9L4IU0/BhI+FC1EG5irOrAF/Ghly0CrKHBe9wL0rPxrsSh9ScsnMUTk+xyHNX5ld3fOF/phleikjeZv9FperPt/JCQojSTtAJDZkrGEO+77JbETbvXVb14hyuRrLB6ikJ6n29RxUqxUe369waM1GRYX8RoHSbSnDeKhTb1UcTBHjnFTrqNhASRcyOwD/VnRteqD8YPXUHupjFOyJIYdnG/1x8LR/fW9Y2Wm1hTkhdTTo8MSgYoOTH23vuZ7dVmC752f+jdkO0Oc+8logVz7pk1k2OifZeDY3MOjsNRmZT5j3L2MXLTIbNXvSjcmsv3H212XWOAk7bvZwgGJfjAVJn7RBzgVfKDR8TPLT6QSsYria50qPtCmJy0iLtPFYGLDlXH0uEcAMjtckK2EpfcdohDQvz+/No44hzp3fRcnuiJMwRZoyRz6HbMf67uILz0WId/sddDVbUxirCJs4RkyxRqlU4GqIE/4Wy2Yh1E/8bDaa26224QyxyIifx3VeeBx6qVIerFdpviK8a8VCwWvC930yTJKTEBS3BCmc9NPDr6tHJXysUiJ32KE/8M+FR0AEQP3iaQLvbNjvtJgeYPKTgcxy1UQEbz/jGfnE6PhMnPHQ/D2wRba2JZSUXdI3CO9k4jptNiL/TCFSVA5CWxYqh0YT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6375.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(5660300002)(8936002)(53546011)(6512007)(26005)(186003)(31696002)(86362001)(82960400001)(36756003)(54906003)(478600001)(6486002)(38100700002)(2616005)(6666004)(41300700001)(44832011)(316002)(6506007)(8676002)(83380400001)(6916009)(2906002)(4326008)(31686004)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZMcXlCc2JWL1hBaXMrRUhaOFcvalF3TFN3ZHdpUVU1R0Rxa3d2ZWdsdkRI?=
 =?utf-8?B?dFFJMnk2elpLc3lUek1PVnBFUlpUbW9pUU9CUHpKVnVsNGNuU2RjY0Zxb0Ri?=
 =?utf-8?B?QWR5UHVKK2JMN01WSHcvSGthQ05kdEtqTHA2M2tzaDdsSXhiTjJIMy9BVXcy?=
 =?utf-8?B?czM4N1FiWW9ER20vbloxT21kbnc0eGdad044ZDhKeGNUZGxEUEt3S09IWmFp?=
 =?utf-8?B?dmNaa1JvK2lVaGJGdUdxd0N3SGZQRTIybnJ5WEtQdnhSUnFNb1ovbkF0YXJ4?=
 =?utf-8?B?TExPV2s0K1piYkplc1FvNDlnRGo5UkUwNnJRdmVFRnJqelhZVFBPMGVSekk0?=
 =?utf-8?B?TkhqRkFtZDZoUkxmNlpXL2NkOWxiODE2dFZROThIWm1NQ21Zc0J3Z28yZTI1?=
 =?utf-8?B?TTlod1ZpTGFRMmlMM3RQMHN4T1hYUGtUVkVlaHpHM3Q1bC8vZUgzaGVwYlF4?=
 =?utf-8?B?dkZ0VXNXa05FNlJvbmgyN3Z2M0dGeU1zSUhXR0g3cUo0SUw4MDN4bFlvVWcr?=
 =?utf-8?B?eGVhUFV4RFVmWDltTFpDeGJwMnRGemVLNjAvT1ZLYXZwUmd0SmYwSmd0YzU2?=
 =?utf-8?B?NjRCQ0lrdHhMVFBGN3RIOGRRcmYvUWJFUlNiZlFXRGxkQzRnZUVtWDVRZFlR?=
 =?utf-8?B?VkU4UkxSUzZrT0V2OXBnRFhxa2poeTN3c1hwUlNZOC8yYzhmY0RLMitCaFB4?=
 =?utf-8?B?QVR1Z2N0ckVpeS9CZGR5NFBIQmxvNEN5SXgvUEF1cFd0dzI5OUFod3dyaWRU?=
 =?utf-8?B?bEMyQlRJaUg2eHV5QWxjOHQ3U296Z0FCRngzSHpWQkNIQk9NWlhRS09RNDBt?=
 =?utf-8?B?VkEwODFMVjlINVVyTTVLM2NMNTJxdjE4eFNFV1lMVmZibWdwSmtDbVkwMlBz?=
 =?utf-8?B?a0paRFRlSmxKLzVGQXRwVHFyV05YZWlDQ0huRk9JaVhwSFAzSUhFTi90SjZl?=
 =?utf-8?B?ZEhYL2l2VUxWOWRPeHFiK3JnbGhxejZucEFYOHRqd04zMG1xRlVVaW8yOGY3?=
 =?utf-8?B?bzdKUkV0OFl3RVh3OGdGbmxZdUl5d2J2UUJ1eUhsam9XV0R6blh3dlZPb3VS?=
 =?utf-8?B?ZFNLbkFSMUR1d3I1b2VCL2ZiMTBWMlZoYjB3NThIaVh5NEk5ZGtUZDBwTHd3?=
 =?utf-8?B?ak40UlE1QWlPa1RxazEycGRjRkx3RUREaHRqclBUWGxFZkZJNlZRZHhUQmpl?=
 =?utf-8?B?Y3pEMFV3WFN0VGQwSDdVYnNmcEhvZDl1VURRZHFPdXByVk9MeS81SnFpRDRl?=
 =?utf-8?B?WlpFQ1doTXNBSnZFbFhodXVmeDc4UmRrWHFBZ3RIOFloYitsNnNVanU0NktB?=
 =?utf-8?B?RERmVXI5SXd3L0s2S2kyd2M3UDFZS1pIMG4vTzdQWHUrQWpKNkx2K3Jpa3hw?=
 =?utf-8?B?MG02bXlZOVJOb1d4Znp5Y0ZmR3ppQXRBS0Yxb1dsMFE3QjBuNXRXVTgvZURv?=
 =?utf-8?B?ZGlyem1USVdiazRWYWJrNTJzMTZlaEJ0eHpHc0VvdDNIZGVGaGVSaElCdFRS?=
 =?utf-8?B?OFE1RHpHMm5KOCtsc0k4RG5zSTIwYTc2ODdxaXdzRkJxZDVHRHpiUnF4OGQ4?=
 =?utf-8?B?OTRlMkdmQ3plak9sZjBxU3A3Q295WVBudlJsdW5EUTVjUXlMVnMzVC9iQnZG?=
 =?utf-8?B?MUFHVEJKR01yMEZvTDBSME05ZUhIRWd5Mks5WGk2bmtnU0dXQ2NSejZ6K1Z4?=
 =?utf-8?B?ZEVxMjVPdDkwNldFS2pMY0tFQThtdGduNlJsM2RFOU1KaWJRWEk5a2JoenNT?=
 =?utf-8?B?bmJKWnNkV09kWnFTQVl2RVd2ZElsdGlBNitiWWpVUUJLWTlnTWtvRDdoSVVE?=
 =?utf-8?B?N3Bkb1h4SXhnQjVpbmp0NnNkN0NNRG1PMncveGl1WlNFWkhCNEhwcVBxdjZ5?=
 =?utf-8?B?ZDBhR0lRVkozVlI0NHlnb2JIUWNJMEI3R2RIckxpV3kya2Q3UFl1eDFiZ2Y3?=
 =?utf-8?B?aUs2MDR2QWxNbThseS9NWTliVUF3c01XeWxUc2Z3TE9LbmswZ25WRGRUR2FI?=
 =?utf-8?B?aTFudGsvWWdlS1J6eHJOQzdyd3dUU1hQZU8xUDFCT09wU3FYSU5kQi9QMUxP?=
 =?utf-8?B?WGpmbmtWbFhyd3dTbXd1V2huaXhmQitucHNMQ1NueTZDa215VzNvT0tPWTdE?=
 =?utf-8?B?TnovYkZFWG9NOURYQ0F2WEd3RHZUcHhVeGhYcWp4VjJSYUI1WVllY29jd25K?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b25277-0836-4512-6f1c-08db0b681c38
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6375.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:09:58.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: doPMAZyzPd9IdFXpIE87WIU1ru2hNXBOzif2XeBAsd1qxB24I4liPbyKeji9DrCRhMtTt5CiIBbyZYVgdsCBKFqvnvItmD9XR3dGzY/s7WI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7544
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-02-09 5:13 PM, Jason Montleon wrote:
> I've done some more digging. The only line that needs to be reverted
> from f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338, moving from
> snd_hda_codec_device_init back to snd_hda_codec_device_new is:
> codec->core.exec_verb = codec_exec_verb;
> (https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/sound/pci/hda/hda_codec.c?h=v6.1.11#n931)
> 
> I added a bunch of debug statements and all the code in
> codec_exec_verb runs at boot with this in snd_hda_codec_device_init,
> whereas it does not when in snd_hda_codec_device_new.
> 
>  From what I can tell we end up in snd_hda_power_up_pm and then get
> hung up at snd_hdac_power_up.
> 
> There are a bunch of pin port messages that show up from
> hdac_hdmi_query_port_connlist when things are working, that never
> appear when broken:
> [   14.618805] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:0
> [   14.619242] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:1
> [   14.619703] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:2
> ...
> 
> I do see hdac_hdmi_runtime_suspend run a moment before things go bad,
> but I have no idea if it is related.
> 
> Without patching anything and CONFIG_PM unset everything works.
> 
> I don't know if that helps anyone see where the problem is. If not
> I'll keep plugging away.
> 
> Incidentally, commit 3fd63658caed9494cca1d4789a66d3d2def2a0ab, pointed
> to by my second bisect, starts making using of skl_codec_device_init
> where I believe snd_hda_codec_device_init is called and starts the
> problem. I believe this is why reverting either of the two works
> around the problem.


This is some exceptional debugging, Jason.

I believe this finding reveals a long standing problem that was covered 
by a very specific codec-fields initialization order:

During initial part of codec-device initialization, VERBs execution 
follows different flow than one happening once the device is fully 
initialized. This comes down to the if-statement preset in 
snd_hdac_exec_verb() and the fact codec_exec_verb() differs from 
snd_hdac_bus_exec_verb() in PM-handling - the latter is devoid of it.

That is until ->exec_verb gets initialized and codec_exec_verb() becomes 
the sole handler of VERB execution process. As PM is not yet configured 
at the time - snd_hda_codec_device_init() happens early, whereas PM 
configuration is done later with snd_hda_set_power_save() during 
skl_hda_audio_probe() in sound/soc/intel/boards/skl_hda_dsp_generic.c - 
it should not be touched yet.

I'm up for reverting this single line to where it was before the 
offending patch. We still want to avoid the page fault the very patch is 
addressing.

Does the proposed change address both problems? i.e. no sound and hang 
during shutdown?


Kind regards,
Czarek
