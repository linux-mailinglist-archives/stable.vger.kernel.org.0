Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75898653D77
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 10:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiLVJ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 04:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVJ3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 04:29:36 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F4F5AB
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 01:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671701375; x=1703237375;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K52wCIFypG7fsVB7RC6oOMHo4HKN3z7+DDwVJ0pCNbw=;
  b=N8uUFxqoZPImPV09yczGN9YXfsFca2CA94pwBta5r0WE+Sgb0U6w1Tc6
   RzAnWnPHsSQlIlxNQLJnJnmD1XozkAOct2QEdHgsK5k8zaZl7NaIQ+6Xo
   gveGSdmjEVbr34M+H7kHFH5+RRVLsDJef0zvceFqfwMhOTR8HEgRqfz22
   /8yjs+qiVSdrd0/Fx4NCOaDSuE6AXQvYnVfB+AwbKdX+37Thq7VWpqicf
   BdCtEmUx0KcE4xVxQT3wwCiGEh9m0/9hBmus2LfqtUXOthqj3s5nQQIRC
   gKG7EQ3dSDnyysXpPP1RV+QNiNdtQpNE7d1Sy+noB+UEjT4nP0sieCjHk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="406324167"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="406324167"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 01:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="651723457"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="651723457"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 22 Dec 2022 01:29:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 01:29:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 01:29:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 01:29:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 01:29:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTiInEHHG6BiT4tJx6OFe+DCclz3138yj178fRzTn88yyw0MNaVdcW6x+tT/Iye+TjcjNk3OWY4DbM5GTIpUbZGtRB2BDdMsOOvYpfqLPYhvufmJabig4icJH97ppM1oCusV3sAOuQSxkDrapjekLZms5kH3kt+4bmN4wvGNwCt4OIul3M19KmyazBat/5KG8/VKGtiK7XakhyxX+mTJbXlH6CUg2lVbVM4OjNnELejnEEhjHXawjwpXqQD4isI3dcwXiHcrFW7Du5SZ4dU5/u26UZ+eaCd1758WCz+o+PgVrjjk6pNSZBEverBixaTndwmAGybNYx0+nhLdPoJvCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAvxlExje3+i47Hrn5VaOyDJ195+z+FYZSWbTH2vWb8=;
 b=EHFqUHMyxrx1gcmyEKm9j3ynPBtiZzsjF1u4fbZfZ0ZCy61/82aeZGmPXIJPjnLquyLaZOl+gwlZEbpENy6vBxJ5XOBJn6AG/nmhSx1a8EdVZVO8SzIPUeiAp8eRVB85Gp55GTmwXi5Hw24jgtRyrgEELOBQf+7eAsZX2g4j7VGUG79gdWcH/5N39JWxp8d4LENf9dmLew58IJVMr1qmA0Vr5w94g3zCK2s3o/1tJ09qrNpfURcv9HgN/RVt5IU8u0gw+oIZOVPtldfjqqBAR9pRQhPaqAjwTQIPD9x6Z5MODV4pofNnuqZJC7iebP1kJibCagfGhURcwf3Y5nldIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5409.namprd11.prod.outlook.com (2603:10b6:610:d0::7)
 by PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 09:29:31 +0000
Received: from CH0PR11MB5409.namprd11.prod.outlook.com
 ([fe80::2f13:f639:2761:bb6c]) by CH0PR11MB5409.namprd11.prod.outlook.com
 ([fe80::2f13:f639:2761:bb6c%3]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 09:29:31 +0000
Message-ID: <4a3f841d-e0ab-dfd9-a6c0-08e2e04c7b6f@intel.com>
Date:   Thu, 22 Dec 2022 11:28:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Reset twice
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
 <Y5dc7vhfh6yixFRo@intel.com> <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
 <51402d0d8cfdc319d0786ec03c5ada4d82757cf0.camel@intel.com>
 <Y5pQH+KGujkSJTvT@ashyti-mobl2.lan> <Y5t+gEMl/XFpAh4N@intel.com>
From:   Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
In-Reply-To: <Y5t+gEMl/XFpAh4N@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0242.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::16) To CH0PR11MB5409.namprd11.prod.outlook.com
 (2603:10b6:610:d0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5409:EE_|PH8PR11MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8d2f48-a9a6-4e1a-ea1f-08dae3ff077f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vn4YOjbSLIz96k2NSe7+wX7oYJEAbOJIxTOb7bkMML9sCzDii/7KDpllGPQyPUnfPaew7i5OozHw5DJKL/cdL/BD9jJbe9EM80LusximAYe+AwfEc04TcafrVU6zGwk5897sz21D1xW3RSBckOb3ysEsKT6V6i24oPxJKTVIVh0PjA6/8hB7d+P+ZrhoaNwPCyD2kui3MQ1laBvoFz8q4+KiMDkvU6knZlYc0NV5I0mHmTZGikOpk4Ef5ngcA4ocWnr6gQXFuJ3PkjmqJdp7OOY9I1DOwijp0nCHrhoQFD1WJKH5+o2QlsxMHxT77bf0ZgKWU/yN+aJG/AnDxLxwqJozeNnLozH2Iiz09xbtEA3D5oe/Q8Qv7aNavQrcI/+LXBZ7viiExcqSOvRWy5t6JZAxbikrK6VnhPvTjPC5g3ujFftl2JmQauZnjc9sPfZ4pNI9HzxfY8plRHY24YGMYGWkIwWCP7vw+8ACNQ8CDXf7Zp57qDgJUijdylLMuT6kukAmNjGr4OM0T+SRdZlHfY/ttl51gagAmNr5EkntIDk3Ld89a19LPRNBjkcuV0UuwM2gUf0TifBuqFc7/ZTH2dO2/Ty1hdynhFVJLg62ECcQcYelMZUOe3ePbH1i3l4SmyfAXWrT1XYFR8AoyHCMPzQSSjcjCgLXX7z4P7osaRX1xk03GBKdSE+fBzLMLSqU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5409.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(31686004)(66476007)(36756003)(26005)(4326008)(110136005)(478600001)(186003)(41300700001)(2616005)(8676002)(2906002)(31696002)(86362001)(66946007)(6512007)(66556008)(5660300002)(38100700002)(6486002)(4001150100001)(6506007)(316002)(53546011)(83380400001)(966005)(54906003)(8936002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk9HNENvYzB0VGpCVUlEZ1FmajVVT2VYUWFLNE5QRmJULzRhaWxrZ3JKeU9Y?=
 =?utf-8?B?RFQ0NGVqSVlZQWVOdGN5VkQwRnVyTXdPTklFdkhjd2REMzkzdXZra01DN2pa?=
 =?utf-8?B?ckFTS0dNTTNYZUxXRWJCLyt2SzFUMFFZZUVqbGhySTAxcG5kZDRZUHozRVpN?=
 =?utf-8?B?U0xvREhpUkNqeUxXUUIzUDB3eW05WmQyb1N2SmZTbi9udnBncXViUWUzb3dV?=
 =?utf-8?B?YU1CZ2tIbHlESEFlM2VRVEJ0Tm5kMk1iSE8vQ2JacXRlcG5uNHdzNmVmanpj?=
 =?utf-8?B?cjBadjVYNytzd3lLRjVHNlliOHZENGN0ZWRiR0NMMDBrcVN6eUlXdVd5aGQz?=
 =?utf-8?B?dnYvUUdPZkVXQmJEVUdwaWtpK3FKQUovUWtwNk5rdGJ4ZmxzdTZoM2lBL0o5?=
 =?utf-8?B?U0tPYldwUlhPSExJanJJTG1kTXM4YVU1UUF2R1lwdlcvNlN1WWVGNkFkUTJ6?=
 =?utf-8?B?THM3ZENWQmRmcDI2NzNPMjFWVjErOUsyQjBmZWxOclJBUDhUYS9pQjZpamhD?=
 =?utf-8?B?ZWJNOXZPeXY5R0U3V3MyV0wzSmhYZUlsTFVVNm14VDNEbkloenEvS2RrcmNs?=
 =?utf-8?B?Y0ZFaUZEWXVPRnVhQkNNWnJsZjd0M1VkWXE5SVV6UWJOUHI4eFJYTmJzSjYw?=
 =?utf-8?B?K0duUFU4dkw3MkF6T0pCOUMyNnBheHZGcWdsd2lpR2YvZDAxa1VNTDhQYmQ0?=
 =?utf-8?B?TDRpb0FKYm5EMXB2OGpQMVVrZC9kck9laVBlQUxnMHZCMVR3STBXUU1SVWoz?=
 =?utf-8?B?ekdacWcwSVc2SW1wT2xMMjEvOHdkN3cybnlOeVl2aXNKemY4RjNIYURrMmRX?=
 =?utf-8?B?REFDUzZoNGVQRkpDM2p6TjdEdmVGMEE4bHM0c20rWFlZU1FFSGNkT0NURnhE?=
 =?utf-8?B?elA0WXVpbTF6QXRKRjcydytIVnMydlVCYVQ1d2xxYjZMaXhJbXMyQVpPMkdH?=
 =?utf-8?B?dlVIRFpyYzhyTUZjUlhvbEZBSzVSUU96MnpwV01RQ2RzSE42ckFUU0M5YVdv?=
 =?utf-8?B?eUpVVExjeU9xZllLUUU1Znk3VUU1djhlRGY0UUZLZGI3WDBkbzZLa1ZmVXBq?=
 =?utf-8?B?bnliM1pyZ1BPTkxCUU82cjhaaU55TmV1QVEydWE4NStmdXF4eFpoS1pHcUNt?=
 =?utf-8?B?SDlMZW1QTmtYZDhESEVGRVhVbk5ScWt2UmJZMVBOZnQxc2tXb0tLdXIvVUc3?=
 =?utf-8?B?cklFY1dyVzg2Q2xVc1lKSU5Lb3d2OHZaYzZHanVwTzRrOFBjclpGdGltd2J3?=
 =?utf-8?B?WXdwODVEMWlZaExDc1Y0RGs3REUvWmpzSVBNYUxiTklVSnhpL1pGOGlvallO?=
 =?utf-8?B?QVExZHNDZGNyRUtjMHJMNVZnRlVpb01aTUQ2cjdaOFY2dnJwbDBWUFUycU9N?=
 =?utf-8?B?aUN6OThWNVpCdnFlVkNlSEQ1V3paK1laWXlDSVZXRFVnSTU1UEl5ejBOSXlw?=
 =?utf-8?B?SE56ZlBXSXBUWmc3M0szNEFMK29CdDh6THBhejR1ZVk0b1dxSkZja09QeGN2?=
 =?utf-8?B?R3FKYi9oRDM1UzZ2b2NZL2VadEhYY2gwMC9MUHZIU3hGM2ZYMkR6VGk1OUx0?=
 =?utf-8?B?WUZCRTB6bUtNWGNPMFhqYkM5cklDS2lLRksyQWg3YzRweUk2MVFhU055amlB?=
 =?utf-8?B?SlpPU1dnV05nRk1kb2pqZ2N0dFMwdXhsZjExM0Q0MlRmRTBBUTFyc3pKNFdp?=
 =?utf-8?B?WG9pZlp5TGY2cVMxQmc3MWFWcWRnSGFvT0V5VkltQXdvcEFXQ0hNSExJT0Nk?=
 =?utf-8?B?ak9xNVFza1pzbGxTQUdWN1FxSnEvS3REZ253TXFWS0NRTGovclcvWTBYTlJD?=
 =?utf-8?B?WTczaDJaaDh5TnBKaTBTZjljQXoyZWtyNzhFNUZieUxmVFNSSy9LWDJrQmdG?=
 =?utf-8?B?WFZSWE9zTXJta1JXNjVacEtmSkQ0L29ONkw3VmVFK2ZhQUhkMjB0MzNpNHFI?=
 =?utf-8?B?RXloYUpaakNOY0UvZjMvUXFNVTE1Ym5qSTZEbTJrR2VLbUYxKzRmUExVYnZI?=
 =?utf-8?B?bkJ1cUxoZFdOdmxrUEUzSkZ6UE9rSFoyWnlHWXkyaFdyTUkvQnRCUE5JbEN2?=
 =?utf-8?B?MUtYWDZhOUxqYko1QW5taG9iME13R3VlY0VGYWpJWFVsNFpRNkdGbmxlWEhy?=
 =?utf-8?B?bWR4WDF4WUxLdkVnSGZYNkRNNkRjNHJlNXB2ZmFjSjZQcXRsK1UybFpCcnpw?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8d2f48-a9a6-4e1a-ea1f-08dae3ff077f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5409.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 09:29:31.3021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoXQjGvI+V/8MeDRyOoh0ESs4nrVgcCxeDwWm7sA5lYXPuBGpAZXion5c/xaO6DJIL0VwYChWKexhk135FiqZfG1MMK88TZfZMQBWkAP768=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
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



On 12/15/22 10:07 PM, Rodrigo Vivi wrote:
> On Wed, Dec 14, 2022 at 11:37:19PM +0100, Andi Shyti wrote:
>> Hi Rodrigo,
>>
>> On Tue, Dec 13, 2022 at 01:18:48PM +0000, Vivi, Rodrigo wrote:
>>> On Tue, 2022-12-13 at 00:08 +0100, Andi Shyti wrote:
>>>> Hi Rodrigo,
>>>>
>>>> On Mon, Dec 12, 2022 at 11:55:10AM -0500, Rodrigo Vivi wrote:
>>>>> On Mon, Dec 12, 2022 at 05:13:38PM +0100, Andi Shyti wrote:
>>>>>> From: Chris Wilson <chris@chris-wilson.co.uk>
>>>>>>
>>>>>> After applying an engine reset, on some platforms like
>>>>>> Jasperlake, we
>>>>>> occasionally detect that the engine state is not cleared until
>>>>>> shortly
>>>>>> after the resume. As we try to resume the engine with volatile
>>>>>> internal
>>>>>> state, the first request fails with a spurious CS event (it looks
>>>>>> like
>>>>>> it reports a lite-restore to the hung context, instead of the
>>>>>> expected
>>>>>> idle->active context switch).
>>>>>>
>>>>>> Signed-off-by: Chris Wilson <hris@chris-wilson.co.uk>
>>>>>
>>>>> There's a typo in the signature email I'm afraid...
>>>>
>>>> oh yes, I forgot the 'C' :)
>>>
>>> you forgot?
>>> who signed it off?
>>
>> Chris, but as I was copy/pasting SoB's I might have
>> unintentionally removed the 'c'.
>>
>>>>> Other than that, have we checked the possibility of using the
>>>>> driver-initiated-flr bit
>>>>> instead of this second loop? That should be the right way to
>>>>> guarantee everything is
>>>>> cleared on gen11+...
>>>>
>>>> maybe I am misinterpreting it, but is FLR the same as resetting
>>>> hardware domains individually?
>>>
>>> No, it is bigger than that... almost the PCI FLR with some exceptions:
>>>
>>> https://lists.freedesktop.org/archives/intel-gfx/2022-December/313956.html
>>
>> yes, exactly... I would use FLR feedback if I was performing an
>> FLR reset. But here I'm not doing that, here I'm simply gating
>> off some power domains. It happens that those power domains turn
>> on and off engines making them reset.
> 
> is this issue only seeing when this reset is called from the
> sanitize functions at probe and resumes?
> Or from any kind of gt reset?
> 
> I don't remember seeing any reference link to the bug in the patch,
> hence I'm assuming this is happening in any kind of gt reset that
> ends up in this function.
> 
>>
>> FLR doesn't have anything to do here, also because if you want to
>> reset a single engine you go through this function, instead of
>> resetting the whole GPU with whatever is annexed.
> 
> yeap. That might be to extreme depending on the case. But all that
> I asked was if we were considering this option since this is the
> recommended way of reseting our engines nowadays.
> 
>>
>> This patch is not fixing the "reset" concept of i915, but it's
>> fixing a missing feedback that happens in one single platform
>> when trying to gate on/off a domain.
> 
> But it is changing the reset concept and timeouts for all the reset
> cases in all the platforms.
> 
>>
>> Maybe I am completely off track, but I don't see connection with
>> FLR here.
> 
> The point is that if a reset is needed, for any reason,
> the recommended way for Jasperlake, and any other newer platforms,
> is to use the FLR rather than the engine reset. But we are using
> the engine reset, and now twice, rather then attempt the recommended
> way.
> 
>>
>> (besides FLR might not be present in all the platforms)
> 
> This issue is also not present in all the platforms and you are still
> increasing the loops and delay for all the platforms.
> 
>>
>> Thanks a lot for your inputs,
> 
> have we looked to the Jasperlake workarounds to see if we are missing
> anything there that could help us in this case instead of this extreme
> approach of randomly increasing timeouts and attempts for all the
> platforms?
> 
Hi, Rodrigo
JSL_WA (Bspec: 33451) doesn't seem to have a WA similar to this issue. 
(Please correct me if I can't find it.)

>> Andi
>>
>>>> How am I supposed to use driver_initiated_flr() in this context?
>>>
>>> Some drivers are not even using this gt reset anymore and going
>>> directly with the driver-initiated FLR in case that guc reset failed.
>>>
>>> I believe we can still keep the gt reset in our case as we currently
>>> have, but instead of keep retrying it until it succeeds we probably
>>> should go to the next level and do the driver initiated FLR when the GT
>>> reset failed.
>>>
>>>>
>>>> Thanks,
>>>> Andi
>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>>>>>> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
>>>>>> ---
>>>>>>   drivers/gpu/drm/i915/gt/intel_reset.c | 34
>>>>>> ++++++++++++++++++++++-----
>>>>>>   1 file changed, 28 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>> b/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>> index ffde89c5835a4..88dfc0c5316ff 100644
>>>>>> --- a/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>> @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt,
>>>>>> intel_engine_mask_t engine_mask,
>>>>>>   static int gen6_hw_domain_reset(struct intel_gt *gt, u32
>>>>>> hw_domain_mask)
>>>>>>   {
>>>>>>          struct intel_uncore *uncore = gt->uncore;
>>>>>> +       int loops = 2;
>>>>>>          int err;
>>>>>>   
>>>>>>          /*
>>>>>> @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct
>>>>>> intel_gt *gt, u32 hw_domain_mask)
>>>>>>           * for fifo space for the write or forcewake the chip for
>>>>>>           * the read
>>>>>>           */
>>>>>> -       intel_uncore_write_fw(uncore, GEN6_GDRST,
>>>>>> hw_domain_mask);
>>>>>> +       do {
>>>>>> +               intel_uncore_write_fw(uncore, GEN6_GDRST,
>>>>>> hw_domain_mask);
>>>>>>   
>>>>>> -       /* Wait for the device to ack the reset requests */
>>>>>> -       err = __intel_wait_for_register_fw(uncore,
>>>>>> -                                          GEN6_GDRST,
>>>>>> hw_domain_mask, 0,
>>>>>> -                                          500, 0,
>>>>>> -                                          NULL);
>>>>>> +               /*
>>>>>> +                * Wait for the device to ack the reset requests.
>>>>>> +                *
>>>>>> +                * On some platforms, e.g. Jasperlake, we see see
>>>>>> that the
>>>>>> +                * engine register state is not cleared until
>>>>>> shortly after
>>>>>> +                * GDRST reports completion, causing a failure as
>>>>>> we try
>>>>>> +                * to immediately resume while the internal state
>>>>>> is still
>>>>>> +                * in flux. If we immediately repeat the reset,
>>>>>> the second
>>>>>> +                * reset appears to serialise with the first, and
>>>>>> since
>>>>>> +                * it is a no-op, the registers should retain
>>>>>> their reset
>>>>>> +                * value. However, there is still a concern that
>>>>>> upon
>>>>>> +                * leaving the second reset, the internal engine
>>>>>> state
>>>>>> +                * is still in flux and not ready for resuming.
>>>>>> +                */
>>>>>> +               err = __intel_wait_for_register_fw(uncore,
>>>>>> GEN6_GDRST,
>>>>>> +
>>>>>> hw_domain_mask, 0,
>>>>>> +                                                  2000, 0,
>>>>>> +                                                  NULL);
Andi, fast_timeout_us is increased from 500 to 2000, and if it fails, it 
tries to reset it once more. How was this value of 2000 calculated?
>>>>>> +       } while (err == 0 && --loops);
>>>>>>          if (err)
>>>>>>                  GT_TRACE(gt,
>>>>>>                           "Wait for 0x%08x engines reset
>>>>>> failed\n",
>>>>>>                           hw_domain_mask);
Did GT_TRACE report an error in a situation where the problem was reported?
>>>>>>   
>>>>>> +       /*
>>>>>> +        * As we have observed that the engine state is still
>>>>>> volatile
>>>>>> +        * after GDRST is acked, impose a small delay to let
>>>>>> everything settle.
>>>>>> +        */
>>>>>> +       udelay(50);
udelay(50) affects all platforms that can call gen6_hw_domain_reset(), 
is that intended?

Br,

G.G.
>>>>>> +
>>>>>>          return err;
>>>>>>   }
>>>>>>   
>>>>>> -- 
>>>>>> 2.38.1
>>>>>>
>>>
