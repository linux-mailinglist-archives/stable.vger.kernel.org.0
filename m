Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237862E17A
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 17:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbiKQQUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 11:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbiKQQUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 11:20:38 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF4B7AF60;
        Thu, 17 Nov 2022 08:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668702017; x=1700238017;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=1HTPJgOKlRoeCd99RLH+Xk2hbCpxZAxygn/axXoOte4=;
  b=iObSVDh5wRABVi6djsRuH1ctcSF3KbTOZ+pFNs1Fe+HSfXBPIbHPxLoc
   g5YEFXrnoyGzSD58WQ0uu7shxOBUE5a9qApwRZT/kT/EzQLvVL6tv/Oua
   c9q+uqJUzg6NIpaA+vdeItpB5ni4VfiBRb2/SMuw+PbJ7R+x41/yRa47a
   4onwN99+UNYQBBXGRrPgmT0ZJnszHLvahXr9DKFIUa0FwxuoSfKaqKolt
   vEftHSclvXZXJEktB5uFY59IcPTiTuvQQzNQSIFipkdAH77KAQVPXh5yV
   9g56BNAwvjMb0QKPayyX0o0f9X6B0x+u9yWnB2YF9zZkS0FF1wNCMKiPZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="311599460"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="311599460"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 08:20:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="708673490"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="708673490"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 17 Nov 2022 08:20:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 08:20:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 08:20:15 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 08:20:15 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 08:20:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpRJz1+D32X+QTZj0IieQJ4f4tDpX/2cJURHLywldTOEJ2JYCxXcUI0LpqMkngU63b7deXb3wcRC9DBpIGKZWOtVg0/OBlThgmhAqqTptCOLeBYtkCVv1OBbnpiqKPPGiQOibJB/lH4eRpbUQlke5vB428mek6pzB2cIg7fY7XUZCedg4pHs2qU5JE/4uoD1Mj42Hda6HvBJXlBp1zWdhKvD3X0ZTPIYL1g1GD3hqqXrv3Yn73OkYfq68hbujLxTsRuo0t40PISNek4L2oSTRyE/6p+niS62pIUgXejhkQ+5h9LawA3TeLmehvUdKaexEydcdRN143pY9PAc7AIb7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM1OjK87xorREqlGh0ySDNlRCL776+q0zXBHSCnoAEE=;
 b=iSkCXxqcxAY1y+DdmmGw11UBhscbcmd510UX5XE1O1OrYa+axVIbMZ8ieC/TDzTI+1GyxDfEnvKM/YeFrrzdQhOHTNc6A5EQ1QxEULQoE5At6fc020R0TuQLR3TVafdvp/n3H8gN//yXAPyQwZhtocuiftOT1TudtugLDkjWVcMxxF2xWQldr+iz1WmcqJaXi9LOrNdQKM+nZxOJziJgzBYXI648hqv/Tpo6khLpWp3qJECZT1RYZ0EbDMRXMcNZN3sELQgbr58QsImwbdckLJ2e6NjHJErrmtoW/KVDW3TmUJYbNtb89KxI9oahyAL0ujUt1aTPiOSWtjiKEJoA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22)
 by BL3PR11MB6435.namprd11.prod.outlook.com (2603:10b6:208:3bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 16:20:08 +0000
Received: from MW5PR11MB5810.namprd11.prod.outlook.com
 ([fe80::d909:216c:b14e:826a]) by MW5PR11MB5810.namprd11.prod.outlook.com
 ([fe80::d909:216c:b14e:826a%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 16:20:07 +0000
Message-ID: <adb5c17b-1596-94e2-400d-b4a1a8155194@intel.com>
Date:   Thu, 17 Nov 2022 17:20:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v2 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Content-Language: en-US
To:     Vishal Verma <vishal.l.verma@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Chris Piper <chris.d.piper@intel.com>,
        <nvdimm@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Liu Shixin <liushixin2@huawei.com>, <stable@vger.kernel.org>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
 <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
In-Reply-To: <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::14) To MW5PR11MB5810.namprd11.prod.outlook.com
 (2603:10b6:303:192::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5810:EE_|BL3PR11MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e22079-a780-4a18-7bdd-08dac8b797a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymXwq4uzmXLnQnSC8ecpTM8Z7YOeMUPHvL+uHZQw9pU6vHBSaN/k3KbryVHHrzve9I/elcdTmJV9641ayg/w7Q6rDGrfcG6ANRXEozITLAO+/WwkrSnYFbMJytJEolMBqwMBtOi3+nnxTtdWyKCCIYwDoqE/4P/mNua2Xnskj2ObcSOcNVWjRVU6S7YMfdU8Js6w57aRiem8n6uIlpRlCMAopWRqxnpbVh6TI7KlDr7N3T9WEl81NaraAoMhtArjQqpZldRZodIKzl6csRgQIG8L82/1RTd04xP5BJc1CTlxhw7Xp7M7XfPvV9wvdZJ4qmC0JAiNPVL3ypeoj8R7Xdkb7eb2JAVzE6/qb5ixqNA72+wVkiOZGiEBma1Xw1JsyD3x8fmXzxAnyMMG5E5g4AqUF+RcCnvZtkHIE1GxaS0+2RnwoBcWuoyjCAyyTuVHr1425L/8EQrF9aw/iYsZW7yYIO6zIfpE0XUssJ1RHH3i+qOJkZbVdwH+5zsfnwImYbdjUYfPS5XGx153ryEDodeS66TmSceNQsMvXg/f3OIqhqyHBeD9TeCbbFNSA0c4TAt2+atEIQ3981gK0Ov0AXuOG7eqNpwrKTVHxsarkEA/3Io5ZxAfzeCCm1vAEt9oG/I6iWdIhFimq7QDnrhaTVgi7+K3ojCANPsO2R9IMah7QgBGY9sZbZd9blBCbM+ckJGt61dWIE0YsraURbFkGGJpbvt+a6yso0gJ+aw2ALGbMXQDiWYG4newjIxzLDek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5810.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(36916002)(82960400001)(66476007)(316002)(38100700002)(31696002)(921005)(110136005)(86362001)(478600001)(6486002)(66946007)(5660300002)(2906002)(41300700001)(8676002)(8936002)(66556008)(53546011)(26005)(83380400001)(36756003)(6512007)(6666004)(186003)(2616005)(6506007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFUvVnBzSTJqVUZWSHR5WVZsaVhXL2NLVmF3TzI3aEVDTnZpTGxmS0ZYRFVz?=
 =?utf-8?B?SVcwYjBsVXRXc3RHRFUwSzY0QTlvRUt2SlZCdjIzbFBxWUtMT25OM09tenUz?=
 =?utf-8?B?ZVFxbUJGaHZFazc0TUhRaC84T290TGVoKytpaTRITklmUVUxM2pBRkxac0E1?=
 =?utf-8?B?TklCb21nVnEybzRIVVRIQkx5TUdKdVAxeGhENDRuTERsRDI2cTcwaTdia2Zn?=
 =?utf-8?B?Q3RuZXd0azdnUm1iU0l1SlpzQ3JiQkpqc2RPZUxNVUFFVlpsTnovNStvL21l?=
 =?utf-8?B?dmR3YzZKOGlhemRJZWt6a0wwQlNJTEJaNU9QT2pmSGhUUXZua1NBU3dHWlla?=
 =?utf-8?B?Nmp5NU1pSS9sMW1Vd29hTVgyQko3WElVMEQrSEpHWHJva1g2TFVNd281dm81?=
 =?utf-8?B?ZXZQK1Jub0lja1JWd2tjVGwzbjVhcHR4NVBWTkNKY2d3VzI5UzhiaGFBQmtk?=
 =?utf-8?B?T2Z5M0ZjcGw0RWpxZWVGZ25weE4yNXAvZTgrVkJnbHYzUkRGS1V4clpjNjRw?=
 =?utf-8?B?VThtVXd3aE5TNEtBVzZEektYSjdXVFpDTTZVSjFoZk1ZUjJsQ0ZCZ1ZrWFVl?=
 =?utf-8?B?ckF3MWdlaGoyb3ZQUlVHVXJ1Z1dlWFFobFR1ZVlBN09YT1FrRUhyWXBqbWh6?=
 =?utf-8?B?MGZBb3djQ01ETmtUSEk5MStzTmFNM1RvbGg0bDR4eTAwNWowQmp1MG5jSE0r?=
 =?utf-8?B?YkJ4a3VUa3hhZERoTUp4QjhNR0NrVXFaY2VFaDB0Z2ZpK0VLZ2RVNXMvRksw?=
 =?utf-8?B?Tml2VVorNHlvcVBncW8wcnIzdHI2bEIzR0k4Q2RCUy94YjV2N2padTVraE1p?=
 =?utf-8?B?KzFlblorbkhPYnBaUzVXMU9pMUtZSGNnd0FmL0QzVm9ldW43NWVSM1Y3S3dG?=
 =?utf-8?B?dlRvY3ZYMmZBbE9uZ3UyRGhnQWtpZkhFSlJGaU1KeFlkSCtTTFZDcnZ0Wmw4?=
 =?utf-8?B?elVud01keGUrM1hZSzBEOTVnOWJSS1l3OXhmRCs1NFNhbUNBRDZwWC9JSkxr?=
 =?utf-8?B?VGRJU240S1hJNWtJMzVpTzZZRzhuZUVYc2puMzJoQ3J1UEFyeFVrd0dHbFYy?=
 =?utf-8?B?aGJxdVpDTUk3ZFdRdnVuUWVlWTMyVmJ6dFlySnE0bW9sRzVLdHJJREU1Wm5h?=
 =?utf-8?B?NktEejk2aEZnczFWQXNkYTlJMG4vZkdLR0dvMS9DRG1DTXZrV0RFVU8rT3BT?=
 =?utf-8?B?d1hkUndHeXVEa1ZRbTQvMUxVSC9BUVJmczUrZjU0WWpQRFhHMC9BRGVQM0RM?=
 =?utf-8?B?VjhqRzExR0NHTXJyQ0FhRDNjMWxOTkNjZk00czJESTdnZDlrUjdHMGozNFd4?=
 =?utf-8?B?ci8yY1Zyd0NxMG1hWXMzUkZzbCtGcFBwZWFydHRUSmhONUpNSU5GZnNVeUJt?=
 =?utf-8?B?SGVsRVFMeklZeGVTUlNjUktKMjFoK0FMZkR5L1BVNGEyaWpzdWZXd1RNU25W?=
 =?utf-8?B?dndsenErOTNxOTNIRDZCMmtKS2Q4SHNXamtaaWNuWGludzFLbFFZRHRXejNU?=
 =?utf-8?B?R3hJSExuYklBVHhYaWxtNGplYWRrZFZsMnFZdk9Na0oxRmtYQW8vUHlzTXNt?=
 =?utf-8?B?VTRvRFM1TklLMVU4ME0ydU1KeWIzR3JLS2diZlhNUTNtb0ExWUVYUWVwZXds?=
 =?utf-8?B?ZjZCZnR6MWVEM0MwQlFSRHJIUDhHbzBrSG1ER1haeEdXeWF5RFFvVHNlRmxi?=
 =?utf-8?B?MEI2UzQ2RmpkYzVGeVZOK1A0RkhaY1hFaUM1ZHQrM3F4QmtScHU5MEtrN0VJ?=
 =?utf-8?B?RXBvYkdCTFhjVjZoVDMxbkxSTWZ2UmNtbW9WVndZUWZGSGNxL1ZuS25yMmd4?=
 =?utf-8?B?WTJjSy9zZmpOZU5KQktFaURFdGF0YmxhYlFtV1Bva1B4ZUxEcm12eWpGNU9Z?=
 =?utf-8?B?d3I4TW5EUjRodGt6elJ2bEhkNnFHcFNkT1hqcmE2VCs1QUtXV3RFZzVNSzZj?=
 =?utf-8?B?a1Z1dVBjWVhGWGlNd0ZjMG1UZktUaWttSnNLOWJiY2luK2YwZnJCZGdKR2dv?=
 =?utf-8?B?UW8xMDZtNFQ4a0Y2N1k0V1hkc29vQ1d6TWZuSXBlS3p0ZkRzOFk1RU1nTThV?=
 =?utf-8?B?YW51dGliS2NISU93VmV0TWV5Rk9EY1k3OEZuVE50c1BlbEJwY3U0elhJZUxn?=
 =?utf-8?B?TGhXS0swY0RhUGlvSXVONi9rTHJhUG4yYXRTU0c1MCtmL3Qwb0FEL1FkRk5s?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e22079-a780-4a18-7bdd-08dac8b797a8
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5810.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 16:20:07.7817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyEEvpdz7UhUQKrcLMzqeDLltObLwauC6/Dwug3AB4ZNjciBEyKSgbVKJJJmnBl92adF+LqcrchHrpJpYrIqeMZXlnf/b0LdKeamEtrjdi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6435
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/2022 12:37 AM, Vishal Verma wrote:
> In a system with a single initiator node, and one or more memory-only
> 'target' nodes, the memory-only node(s) would fail to register their
> initiator node correctly. i.e. in sysfs:
>
>    # ls /sys/devices/system/node/node0/access0/targets/
>    node0
>
> Where as the correct behavior should be:
>
>    # ls /sys/devices/system/node/node0/access0/targets/
>    node0 node1
>
> This happened because hmat_register_target_initiators() uses list_sort()
> to sort the initiator list, but the sort comparision function
> (initiator_cmp()) is overloaded to also set the node mask's bits.
>
> In a system with a single initiator, the list is singular, and list_sort
> elides the comparision helper call. Thus the node mask never gets set,
> and the subsequent search for the best initiator comes up empty.
>
> Add a new helper to consume the sorted initiator list, and generate the
> nodemask, decoupling it from the overloaded initiator_cmp() comparision
> callback. This prevents the singular list corner case naturally, and
> makes the code easier to follow as well.
>
> Cc: <stable@vger.kernel.org>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Chris Piper <chris.d.piper@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


> ---
>   drivers/acpi/numa/hmat.c | 26 ++++++++++++++++++++------
>   1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 144a84f429ed..6cceca64a6bc 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -562,17 +562,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
>   {
>   	struct memory_initiator *ia;
>   	struct memory_initiator *ib;
> -	unsigned long *p_nodes = priv;
>   
>   	ia = list_entry(a, struct memory_initiator, node);
>   	ib = list_entry(b, struct memory_initiator, node);
>   
> -	set_bit(ia->processor_pxm, p_nodes);
> -	set_bit(ib->processor_pxm, p_nodes);
> -
>   	return ia->processor_pxm - ib->processor_pxm;
>   }
>   
> +static int initiators_to_nodemask(unsigned long *p_nodes)
> +{
> +	struct memory_initiator *initiator;
> +
> +	if (list_empty(&initiators))
> +		return -ENXIO;
> +
> +	list_for_each_entry(initiator, &initiators, node)
> +		set_bit(initiator->processor_pxm, p_nodes);
> +
> +	return 0;
> +}
> +
>   static void hmat_register_target_initiators(struct memory_target *target)
>   {
>   	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
> @@ -609,7 +618,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
>   	 * initiators.
>   	 */
>   	bitmap_zero(p_nodes, MAX_NUMNODES);
> -	list_sort(p_nodes, &initiators, initiator_cmp);
> +	list_sort(NULL, &initiators, initiator_cmp);
> +	if (initiators_to_nodemask(p_nodes) < 0)
> +		return;
> +
>   	if (!access0done) {
>   		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
>   			loc = localities_types[i];
> @@ -643,7 +655,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
>   
>   	/* Access 1 ignores Generic Initiators */
>   	bitmap_zero(p_nodes, MAX_NUMNODES);
> -	list_sort(p_nodes, &initiators, initiator_cmp);
> +	if (initiators_to_nodemask(p_nodes) < 0)
> +		return;
> +
>   	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
>   		loc = localities_types[i];
>   		if (!loc)
>

