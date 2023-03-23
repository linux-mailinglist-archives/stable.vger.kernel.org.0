Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEF16C6BE5
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 16:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjCWPG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCWPG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 11:06:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210C81D93C;
        Thu, 23 Mar 2023 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679583937; x=1711119937;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NRSv9gOc0x/VgqfLhMHGJjqUnf/j3n0l8K1tj1NvpZg=;
  b=J9j9BvQ3LDKUQZfWmjK4PLBVWPgli6CsvyztUYwdLoxplGn9/YYnVv00
   RkjVdgEVaaVB2MXJbEp3qqqRWhac/Mf4afl1Z8TiyltvfxYZu4EeHKyX5
   9dyj+oLqbwryPFpKgclxg8bRgiyaq/bolXrIHJ5J561DsHMxTg/7PHfDY
   /r4xJPI042/Lj3nmY042aB9nBinrePOiMNb54wHk9MCjIZYGzw7sH/9oG
   EsXJU2Y3NR7de7tXq/tkZ/N6n9uixP1vzRNTVs8rdTC0kt5qGYjHbTvOk
   qRpwXWn304cJN8fIjJ2pDwQPKZcN1AglFbVyNPrltBMnkaZF9lMHWS1Tc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="404415380"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="404415380"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 08:01:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="714847021"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="714847021"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2023 08:01:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 08:01:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 08:01:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 08:01:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 08:01:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLDDkknHwt1xlku9PC4/rOL8Hq5KKtM/Afv0Eh5D11wOMmxV6LlEkX5YlRglarqGRuo/83gHaJeJB1f4En9pFL2VxdxkBFjhOKkn36wWI+nlfNCyrD0AybOwe/d8XLze6BwPKxgGLLdyf2i0vfE8M1lhGgTUA2PmSdoi/GLSizu2ayFn8cYWJI0fGy42pVp9VTuB/q7xtMXWzlflwIoS4X92JF9N7clPPg0NAbD1n5W6mQCpbeaKdH7nIr++wfOHW0AP+ONLfN2wuSbrTNgHr5LCkGw1ZDh6I5810Is+tkZELabfFXZHCRrrXpoCQBLL0AYCpspAB34LY5ImSAfBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7x4/ujsFOMupBxd+h8NE3RBHNfApF/BzeVVztVmvSo=;
 b=NiJPKpvJDh6BI68KkZNEMfKjw7LSozAaKDai951eirrzVuO6gG32h0qOe1/TXeRGCNm1R+6uvvE43Ll4y8p/GJS54dAdfR1O7WWtxp92UUe4NerdAsXPfOVIn+ionpn3sPg6gHxzcHtcdjjKVbnOYuAtiKb0YZafpyC6JQ8iBv4ODXorUzFIGJtIf8U/bfpwdKOws6eMuj5rQJnFVwcDYLN3LYBukRZqcl4/V8QngQrmqJXoR7JYz1FVTJJih3MI03jRn5ucpnStLxyGZKNNftheoEtU7WDTHlVHygk+8f6y2+uZ5aPl3+zm4ezii+iXXMDfCDYjCbCZlDxehGxOnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by SJ0PR11MB5920.namprd11.prod.outlook.com (2603:10b6:a03:42e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 15:01:28 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::2629:fb12:6221:3745%5]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 15:01:28 +0000
Date:   Thu, 23 Mar 2023 08:01:25 -0700
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
Message-ID: <20230323150125.35e5nwtrez46dv4b@ldmartin-desk2.lan>
References: <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
 <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
 <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|SJ0PR11MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: db4dc473-a820-43ff-7538-08db2baf7a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fJ0MWcVtqlE4oY1YxDCxnWPoSFdPgyMZsJFZH+BbRmCMdjRu4HcEimgnkEBf/ErsnXRSXmd1NVAiGi/9ShnafumQt/vcoGd6/TJBDNTzpLZdeHzW0RpwZo83HDz4DbhYJmmUzjznxS+/idtcof9UQckDKaUAfN/w9a/cMv+3XkAWS8t8GpGrLf/9j1GBfJkutTQsjuD8d/wGmeZ3hzV7WjByzaK1L6GPEPfhuuMbxx8+vLpFrsiab7BNIQwARQqPt/0FqD3fzR/iXFGKkP1YECjcED5TuDVxFVVGwLgYrW+9ASGKR0CuP6IjrtigTqQFlC4qA/E5jTLr7ZM/RhO985yqE8euQTkuKyUQ7tpiOcdckpiVkWvN/B3wWp1efWHx4STrHy45irgXR3dGPX3UZYpwlkAeopdiXRuCD7/7k3dZ76xjTbFoFPF6TZXOOE4CQpVjlDeGfNe7LOl5UvQPhZK639TezkrmGTINrABslIqe9NETfHs/wGoOiNmSS9ALvnUFApNw+s3R5REJjwUFRfT/bAkjGhyFJzbgr7Ynn9upXD5lcQcdrTahnO3211hCU+iHxjpimlxMyux96GTLCLjgFDVl9iBxtMxYPH2VPSmX91JRK0BKmqs3dkvXL1zk/XoEiRSdHYN1D/iVGc/Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199018)(83380400001)(2906002)(478600001)(54906003)(6666004)(9686003)(186003)(1076003)(6512007)(316002)(36756003)(6486002)(26005)(6506007)(38100700002)(82960400001)(86362001)(8936002)(66556008)(66476007)(7416002)(66946007)(6916009)(8676002)(4326008)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NdWUKt6aRlgN10KOZx7FenbSx++N0tMOPylTSs+gu1vndxP36unOoXilJ1KP?=
 =?us-ascii?Q?d3zWfLTg7j2SrNP3vFt+JT7+WmLZsxg4Wa+wqVrsCwFLyZhjpZ3D5t7kuc6f?=
 =?us-ascii?Q?yb3Y4ihKkaKT+dV0tPPYRpFI3e6XvqXbNZXLkJBiRmHoZvE2q4ly7Z1LxB/6?=
 =?us-ascii?Q?Vjif0OzZjfDtiC6TBvBDvyeoYj8kyywxxvp/oJp0i/5bIbEDDuiQhpst/i9J?=
 =?us-ascii?Q?l/Y3WNiBS72lVbd7yg9LHK9ldQtXclERHI6E/sjPmMpesJ9UEHliBxzegWNu?=
 =?us-ascii?Q?+dw4JUyCwMVwbHvHQA8B4MFzq+moVH+YXiHfzUEacFt6SYr5rEoVhA+5jCoU?=
 =?us-ascii?Q?2hoUgf6ViO4Ts9nesVqvhbZd84OlA4wLtcVFNY69rNvnneh/iL5u5F0TryhV?=
 =?us-ascii?Q?8SdPCAs2TLL5uSM1KdWgvzm0b1uANAQdeO5cDroCEH8YVO9CrgciLAiLSE8b?=
 =?us-ascii?Q?rG8okp7O+AVFxGA2iL5uD/+udrb3qdc1giDr94ULiKuV/bil+esd6Flrsszz?=
 =?us-ascii?Q?l8RsaYAHxKdC7J19LPFDC2PVvwNu7tUQYO6S34ggOn2vOd5We9SKtfgXs3lV?=
 =?us-ascii?Q?9lw6rDq0bL0eklPwswAhMxYWMS5D5BADLoYOarzoUT/S1+BdHNoaClA1DJvM?=
 =?us-ascii?Q?9pgh9CHwibunmi0bYYCBwxeQwyj+xdZJUGliuE6yaqKScQLJArQYGa0JJWwu?=
 =?us-ascii?Q?vMUR+ZLC12TJ3ojDghyRVAkZDTzrTAvD/1zxlaALrXPvWWB5HDzbKd+Kpmq4?=
 =?us-ascii?Q?71735t07MmUx2ROyNmpabFw24SnAo6kEjQeoKTlRcGiL/UGLIb4Gh2vXZ/MP?=
 =?us-ascii?Q?0DH7zAZNJ5KKqp/i9g5a4snjHiWbrTciJsntWxCyDnN/MDwTmFnuP5Zccbo0?=
 =?us-ascii?Q?Jyr1gNwsDK9NeavczUWPhpEBWpBeZMv7yhV0wFWblTTSKJ2TsGLnbiO/9fPm?=
 =?us-ascii?Q?d6eT7P43t6OOkrHB+naSPqFT2sNvgpGRJRzxUdT01W1zv8CAovcPMt0na7J8?=
 =?us-ascii?Q?u5wnvOZWeT1/Pz41lma1eLXx1u8T6APBt0amO8EaHbeB/MhU5WE2MJ8YGRfX?=
 =?us-ascii?Q?PpZxKpGH7ASq4VNzn4ahRyOamFJ3hqvZ2aPDdRXz1/sG32NgnqjqQbDcrEZ+?=
 =?us-ascii?Q?oink8vLAJIWNiOvj+LVRuJRJME/5/a5ldd31OwG+EYH+obFatFFo8CMkrLDG?=
 =?us-ascii?Q?/q0QLc9RGfmNt1d8pYYZhU1zewbe9qJcuHyl1GhkzaF44wLY2FcRBQoqDcTE?=
 =?us-ascii?Q?vx9T0ZwWfp5Sx4e9oVBaTtcArBQjHiMRqrY5k0/qK3QyhP98kF6FFe60NY/n?=
 =?us-ascii?Q?6ScvnKy37oZrwAY5XVj8+9Apvl8nZUbOqtA7GOlvoAiJUVVNHrav9yY1IgSD?=
 =?us-ascii?Q?5R+LeT//04sKsBV9JzZIHMTR3u5q0mqYmhwfoUxwx+bByt6VwZrSvg/iXHH6?=
 =?us-ascii?Q?ItcGq+zYgTD43VAATaskF+Iqu1cG0lW30VNTF+KEoPZKPJ4kt1vF/uQFLOq1?=
 =?us-ascii?Q?SAzNmtSlTtMLP4shuEC9RtEVm9gVoeaPLoub2F/0Ko2o0cHwgu2k/YTzObg7?=
 =?us-ascii?Q?BIsOKsAbzBIsroqr+ydvH9tKaKsr69YH+eEIv70wNu1IzbOuSh1zzkA7aGGZ?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db4dc473-a820-43ff-7538-08db2baf7a73
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:01:28.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErfPn+wmkVM/fye+14ibWyKn7L2cs7MGG1V6pUWo02zE9ZMr93A/NRgCs2WrFLb0s8vK03+2kjVirL6tmhzpl1ldmXdPgmZfuKLap1aSWgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 03:31:59PM -0700, Luis Chamberlain wrote:
>On Sat, Mar 11, 2023 at 10:25:05PM -0800, Lucas De Marchi wrote:
>> On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
>> > On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
>> > > On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
>> > > > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
>> > > > > Yes, the -EINVAL error is strange. It is returned also in
>> > > > > kernel/module/main.c on few locations. But neither of them
>> > > > > looks like a good candidate.
>> > > >
>> > > > OK I updated to next-20230119 and I don't see the issue now.
>> > > > Odd. It could have been an issue with next-20221207 which I was
>> > > > on before.
>> > > >
>> > > > I'll run some more test and if nothing fails I'll send the fix
>> > > > to Linux for rc5.
>> > >
>> > > Jeesh it just occured to me the difference, which I'll have to
>> > > test next, for next-20221207 I had enabled module compression
>> > > on kdevops with zstd.
>> > >
>> > > You can see the issues on kdevops git log with that... and I finally
>> > > disabled it and the kmod test issue is gone. So it could be that
>> > > but I just am ending my day so will check tomorrow if that was it.
>> > > But if someone else beats me then great.
>> > >
>> > > With kdevops it should be a matter of just enabling zstd as I
>> > > just bumped support for next-20230119 and that has module decompression
>> > > disabled.
>> >
>> > So indeed, my suspcions were correct. There is one bug with
>> > compression on debian:
>> >
>> > - gzip compressed modules don't end up in the initramfs
>> >
>> > There is a generic upstream kmod bug:
>> >
>> >  - modprobe --show-depends won't grok compressed modules so initramfs
>> >    tools that use this as Debian likely are not getting module dependencies
>> >    installed in their initramfs
>>
>> are you sure you have the relevant compression setting enabled
>> in kmod?
>>
>> $ kmod --version
>> kmod version 30
>> +ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL
>
>Debian has:
>
>kmod version 30
>+ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL

	   ^ so... mind the minus :). It doesn't support zlib.

Change your kernel config to either compress the modules as xz or zstd.


Lucas De Marchi

>
>> $ modprobe --show-depends ext4
>> insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/jbd2/jbd2.ko.zst insmod
>> /lib/modules/6.1.12-1-MANJARO/kernel/fs/mbcache.ko.zst insmod
>> /lib/modules/6.1.12-1-MANJARO/kernel/lib/crc16.ko.zst insmod
>> /lib/modules/6.1.12-1-MANJARO/kernel/arch/x86/crypto/crc32c-intel.ko.zst
>> insmod /lib/modules/6.1.12-1-MANJARO/kernel/crypto/crc32c_generic.ko.zst
>> insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/ext4/ext4.ko.zst
>
>Perhaps this was related to the above gzip issue in debian then.
>
>I'm hoping will have a bit more time than me to verify.
>
>  Luis
