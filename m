Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4D26B6379
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 07:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjCLGZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 01:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLGZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 01:25:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503E95C135;
        Sat, 11 Mar 2023 22:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678602321; x=1710138321;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VWMzIApxpQG7L0/y7Q/dzUr/hxOQUuNKYSyppwI2xAY=;
  b=kwR0L8i0j7eHwd31ity+QYgD0Kxmzfy0reqnMcv8sC9Awbt5UPpgFVaq
   uNNGsR/OEv2ui1oFWcFpNLN6TVrqxaxDsybW5J4vnQ99yT7ZWd88DNLdb
   2bXOE6oatMGuziimBJEicl3J+6z5W7z8L0z/en+xnSpm0/l+LBTSxlnzp
   luMmuWfRO10KZaQVKOSg+qlVOgm/xjR41nYWVJDEl+kL6EddUKLwcLU/q
   uwA3w2dbCLtGzJ45z9+6s0dWX9FXsTGp4VRaNE3FwsgfkBcLncSa7Rtfp
   XbySrHwDqef2zNHApYOn/jxuDHy46fSqo6UrWGIVVL6yzmbdgtQQi6niO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="399560491"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="399560491"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2023 22:25:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="628267925"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628267925"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 11 Mar 2023 22:25:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 11 Mar 2023 22:25:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 11 Mar 2023 22:25:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 11 Mar 2023 22:25:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 11 Mar 2023 22:25:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClYh3mpSBstu4CWvM8lLElUrQJRRMyz4g6iLYyD/DweNXGiUT5u65BBlNMcNFvkrwUdLuDMVxwD9CerOhoYVNFtGWVnFkVqb1G7y8jS1S3RLs63xU8IktRxQz0PGO+pfnNBK/f/j1EXBbX7hZdsmdiPq6k3T64vWgwpg/0Ia0ygh1g8X7SHWBfbOY2Shjn5qmXBsku64Ofz1kIWZlF/wrANE/Z2Q4Fjcox7rgDvxArINUX0KKay8eeOebJj2hWiGcnwLaMvvB4XNPeKeZes3PzPViN/MAT0aF8E3Hilw6F+qEa3caGVKWwMpmWmswhA7+i3+FsRWnP2H+f2p2wbesg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdHrJqTevLKDXI5S+992BO+H0zCxTd11KPGIzddJ+Xs=;
 b=Y3uycHxRk8DRqCwye/eUz186hp6mBS+O/g0V9JpnDofvjQESV8/TRDSHUyUwElXlNNaN6NgHY5RGku4rQ51Al6ANGR/GsotksCR1MyDGoUCXpp4om/4ugyVPkRnhMRqjBUpFZFxV3xu5E6k2igng8qNQg03HutyuxMFL6EUMf+GXIHvdqC4HZ9GnYvfiPzBPckuLghGpMuvbQtPAGN3Bn81slp0qkyLsfKmtvj7qjCzpBWNsS44Kxrfo/fisykhe/iGl1vm8Szpnt3Oj3DxWeB/4YbqLrP43cZhmE9GaeOYPDj+4zJhkU8SToCXZxR5MiLrcRk3TquPJuz0tVa6hsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by DS7PR11MB7860.namprd11.prod.outlook.com (2603:10b6:8:da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sun, 12 Mar
 2023 06:25:08 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745%4]) with mapi id 15.20.6178.017; Sun, 12 Mar 2023
 06:25:08 +0000
Date:   Sat, 11 Mar 2023 22:25:05 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Petr Mladek <pmladek@suse.com>, Petr Pavlu <petr.pavlu@suse.com>,
        "Prarit Bhargava" <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, <david@redhat.com>,
        <mwilck@suse.com>, <linux-modules@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        "Ben Hutchings" <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|DS7PR11MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9ab6c5-3d5e-4043-f0e8-08db22c2868e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gRaswfHknctbAwyJGTn3i/nNKyk6/IQvOqLYqBKTvfXb/ERyo1Dy1XqjcPevuA4q7GfzDvcJeUJQgGgoLi9EY/l5bvlCf36wXOSXkHP1UkrPk70G0iLf91bnP2iC+JIjOfw/ZvWoyxtYci2F+CM1aFaogqnTMESgNZ0qIyehgOHtp4uFhYDG04e0m0TotS2xWnLhnabQFO6hZ9Wp1Ah5V8vm1Gb2ZykRuv0bZmdbZpps81BOcPp1B0HAoeitTsjxvjArw37lDpg2T1xaIqEQeOKig/IyfkurzNmEgq07jmDu8UogFGLVAwjX0dJFQyXDLT95T7d4CRVZjthk98ePBDgp+wjCPse6fJtuLGCxeRwuR72/0vHrmM3uJyoQXW0ssvnfT1c9eRfbvhIWeDtxRAJ4LpXqq+8V+HLsqxMUX7HFq5EK75vUBY4pbZEXDdnT/SjzT/z//GPztkbv8brLKQ1Rz6HDMnhe231MD84z7kNeqMDliIN/gk97QtnAJWlJlVE06Gz5iQ1gBJEcxdRvrpX5Ku1Ub3d79tUxSQd907rQ9kHlpfDUyMOQG3yZDuKGh5Ojpbmyy4UCNsezAh0t+ev7+VLO/OoV+HZZcthuCs/N7IwI3ngC6mmKIa/MQ5i0/LD2B3j+zDG79YAWBXF/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(8676002)(4326008)(6916009)(66476007)(66946007)(66556008)(83380400001)(5660300002)(41300700001)(316002)(54906003)(8936002)(82960400001)(2906002)(36756003)(478600001)(7416002)(38100700002)(6486002)(6666004)(186003)(6506007)(6512007)(86362001)(9686003)(26005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2EeJZOMCWDkQK2MKzVFvGzIUKEqZBrsDrXXF5dLjS4UcQHneUqQ6r8/ZoaR?=
 =?us-ascii?Q?v8XDm80fgWcP/VS5rIXNsWtf+WfMpymIPGfjFYed1FPgPOk3ZXcTKiy3PvMh?=
 =?us-ascii?Q?Cr54nsm7609dbeH6tugiyJbOuVQVz48PqxMhMxpRSsAFOeUSOK5E1Wq8pE3A?=
 =?us-ascii?Q?FfVjM9+W2hBEl0hlYle+po9/zlSYBx3FGLXcKT3Nrf4qKQUm6paF/WXpSfJc?=
 =?us-ascii?Q?L7/2u9z1NNJPO8/5BuIrfcMWm/2whfr0sjFdwUpa77Elk/HOARh8PJyWsh/e?=
 =?us-ascii?Q?H+bvGASvxal2RW+s+gLSE54u9MUOIMTqM62pjgCVo8Kx5R6PpVd5lHe//dfD?=
 =?us-ascii?Q?GNI9acuHbw40NvG+BgQyd7rm7f7Qrflb/GY4wNpj5NeSbI2BGRIiKyfcuqMy?=
 =?us-ascii?Q?cS3PZyZwPblCT0x329fJRLQ8teuMLWAunRULeFDTf1DfzEEFaWM7WTfbXz+Y?=
 =?us-ascii?Q?8Sbn8qM46pbTrULXbR8paSEjy3Aev3skjztqUrozjGJuhlC0mSAxhIGzHc3J?=
 =?us-ascii?Q?dCG+Hgbe8fXebm4sIl2w7I/20f8U/OTXDgfwQwW6KYeyaqDWG9E0LmAHdbP5?=
 =?us-ascii?Q?+xniUj8QBVKviOeJdIFRAykVZ50UmPRFbd44emsWxSOo5zqOlmnn0egRnHW1?=
 =?us-ascii?Q?EAv0HorfYB0HJoXu5Foq/ZPEWdP+nwMDC3DlyvNuzVUxRegfrpJXKA5pGDYU?=
 =?us-ascii?Q?bWlo3ZyboQTQ0tNAUCo4+kj06ZUHVsaWN5poEFZsEKJmLAlL80YqYEc+WY3x?=
 =?us-ascii?Q?JkkxqWL8xGICw7TFCnPL5fUTYPUJBHJxNi4Jj8bXvtJDFm4vLlJLIaljjqQf?=
 =?us-ascii?Q?6Xh0uJOT987ODmdkU3ycJmg7wNNzhB0iJvVnMs66+jT/8FFoO9MJTajcK4V+?=
 =?us-ascii?Q?ZnVXsQ1h1yUQsObKw++gj9PGQMXcMlsJ21RLxshZ02dJLx+ZmD9xsZTbPO17?=
 =?us-ascii?Q?RRhlERHbb7FNUc1El8Gk5MsuN8XKhAsr7pao+BEbqNPb0yghqVVZb3w8JZ2Q?=
 =?us-ascii?Q?OChswC/ktrKgd+aBf1StMs1pTgaycjb9t3Z0unfQ8LvZsqa56shF1xXtDHoc?=
 =?us-ascii?Q?7W9kQM7FUmaBltMBgvyez8spxPMGaSqY6roj8a08KxPm5ZPeitRHKgPbGlBZ?=
 =?us-ascii?Q?fvJcpxE6/CKSnZWO7TXZgEj6jGkuDSbO25Gd3m9ovLSRG+vt3gN/QDW5d4RS?=
 =?us-ascii?Q?E+8hpxqPkrEYgdTfbyews8GLSdUz5AYPTx3ysLD9P6sDnionBObBte89YaCu?=
 =?us-ascii?Q?BSepGsHZ5CmiU2GDy9CPnRwSM2WM/QSR7R/XaULsopE+3M5iXCXuSKGBYkWn?=
 =?us-ascii?Q?IubuiZUa36CIDOtXKAoVM+OHb8cjktGOizGZml8e4yaWc6VL8d58OwX5g0wA?=
 =?us-ascii?Q?24VuU84ezZ9YOloJI6489bL7Hj2B/LcKOPptsLV3XWmIngrnsp/veICUKYQS?=
 =?us-ascii?Q?tedaTv8vCUylwGIHu91sN8P/lafDV4h3nejVLheQLZB1OF5c7ewiyYbefiQM?=
 =?us-ascii?Q?JzRjUVUADpArO2R8YRxxzHDcriEvaqP76Ho0rut6r7A32sdrnDlffOJbfueb?=
 =?us-ascii?Q?rv2+vP7/o5EbZY1/v36wskYvlQrpgQeJafHp5jBEcfyOCuauIo1GPzzIWxiZ?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9ab6c5-3d5e-4043-f0e8-08db22c2868e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 06:25:08.5195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNt68I/Rhz/QY2XtjYgKw3IRYYP15il76JItP+3lS9mrhdEYuRA8JA+tzBRScvGzb9v6A8euqZAH1xyqVnMv4I+WR6j+Kvvu8HRxSf33RNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
>On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
>> On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
>> > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
>> > > Yes, the -EINVAL error is strange. It is returned also in
>> > > kernel/module/main.c on few locations. But neither of them
>> > > looks like a good candidate.
>> >
>> > OK I updated to next-20230119 and I don't see the issue now.
>> > Odd. It could have been an issue with next-20221207 which I was
>> > on before.
>> >
>> > I'll run some more test and if nothing fails I'll send the fix
>> > to Linux for rc5.
>>
>> Jeesh it just occured to me the difference, which I'll have to
>> test next, for next-20221207 I had enabled module compression
>> on kdevops with zstd.
>>
>> You can see the issues on kdevops git log with that... and I finally
>> disabled it and the kmod test issue is gone. So it could be that
>> but I just am ending my day so will check tomorrow if that was it.
>> But if someone else beats me then great.
>>
>> With kdevops it should be a matter of just enabling zstd as I
>> just bumped support for next-20230119 and that has module decompression
>> disabled.
>
>So indeed, my suspcions were correct. There is one bug with
>compression on debian:
>
> - gzip compressed modules don't end up in the initramfs
>
>There is a generic upstream kmod bug:
>
>  - modprobe --show-depends won't grok compressed modules so initramfs
>    tools that use this as Debian likely are not getting module dependencies
>    installed in their initramfs

are you sure you have the relevant compression setting enabled
in kmod?

$ kmod --version
kmod version 30
+ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL
$ modprobe --show-depends ext4
insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/jbd2/jbd2.ko.zst 
insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/mbcache.ko.zst 
insmod /lib/modules/6.1.12-1-MANJARO/kernel/lib/crc16.ko.zst 
insmod /lib/modules/6.1.12-1-MANJARO/kernel/arch/x86/crypto/crc32c-intel.ko.zst 
insmod /lib/modules/6.1.12-1-MANJARO/kernel/crypto/crc32c_generic.ko.zst 
insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/ext4/ext4.ko.zst 

Lucas De Marchi
