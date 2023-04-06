Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F036D96D9
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 14:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbjDFMNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 08:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbjDFMNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 08:13:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB571FCC;
        Thu,  6 Apr 2023 05:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680783185; x=1712319185;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6phrrFj6gvfwPEazvYRcrVUbpdVeZ3I1d0Qp0kiyn+c=;
  b=MK43r5Xmnd4oKYGspqQDbeJL+I1gqv5DXDuz2D1ctaKptsZkpPArZdKz
   zTuD4QU8xQEgM7hHf2RL8czxP+cLeHA6eBwnLpYBKl5Ky1C0BNieG5hT9
   yOx0sCQ4g3OVwc+2bRCvKptmhuQhuhnNngV7zf9sukDbnZcnQOQf0UAk6
   MD0e+L+nOI8DJ4/Y/goJ0+ZznraeRLuxHGlPJQYLT0p6kyzeH3Q0yT0Pn
   5QTASHD5ugvLSFxlilNquJPow/W2J1xOZcHaTXGOxgQfrENQoNKmKKGrx
   HGGOBdasAypzDeR5QWanVMqVU8DBwbxwlZWpeyddc1ADcHy+4WfvovaXS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="429003665"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="429003665"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 05:13:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="776465508"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="776465508"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Apr 2023 05:13:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 05:13:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 05:13:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 05:13:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 05:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JS2Hb/gRXS90lIj80TSv4c7nJ/Fk+NMzP7f57Ju5s5XuSUW240lBgOz6BsW5iegdEZ377Jy0IHQuHuKztcaUYFa8HLBcEv2trudiWgTMuLy436LeuPMYKBpNy88X2pYgibm09iqhhsA2g0cOm1fHnJb6E0ZYOlR7FsafTFPs8EovRcHdJ9uXBnZRvrexT0dks6ZYLZn7N9V98hsCj4LgDSUpLDSVHaiN1GHXlpd09ild/FbTaZCpV779faABTnPzGsloyDp/EwMUnok/BRrNYWeGpH1H0Z+3kbvxEp4yMEu2gXloOKPab1RdYEbWnmxy5/NPl46CqEAHS3CgolfhdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sE+Be6mBxirkp1/d7AR+LoZd7DDFRHR1q3Qo4rpwWvw=;
 b=oIk8RQLZFGO4VPEPNBgUfI/RcaARk4hyUWARCvTy99SUrAMjw+92LvQ0D+kt3VOJg6mOjTWXpoboT2ul/MDxA+Og6HwsuZJHrfEDXM/y6Bto5Nbo44js8syRCCkAzW/657KSdXW8PLH+TvPGMQWP+Dt+R6YsV8Ez1Qv71KPUeiqHI/yTQhxQGQEjADiLhk+gEz/S2upyqueef5IoIVCGhQ8/rO8LtmwhOTDXFvZE7wV/JCyNHYrkRzESJ3q6EhuBPZqSt49jDnhaoyWL2gW3wEbjvHFiy+fNzpm0aCigmQrQlgbwLKDHwcW8dRdJnR6q+Uj9AFdH/war+IFe9IRNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB3060.namprd11.prod.outlook.com (2603:10b6:208:72::24)
 by SN7PR11MB6601.namprd11.prod.outlook.com (2603:10b6:806:273::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 12:13:02 +0000
Received: from BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3]) by BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3%6]) with mapi id 15.20.6254.026; Thu, 6 Apr 2023
 12:13:02 +0000
Date:   Thu, 6 Apr 2023 20:12:45 +0800
From:   Aaron Lu <aaron.lu@intel.com>
To:     Rongwei Wang <rongwei.wang@linux.alibaba.com>
CC:     <akpm@linux-foundation.org>, <bagasdotme@gmail.com>,
        <willy@infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff
 and get_swap_pages()
Message-ID: <20230406121245.GA376058@ziqianlu-desk2>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <6dad8c2f-b896-3cc0-26c1-37f5fff406bd@linux.alibaba.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dad8c2f-b896-3cc0-26c1-37f5fff406bd@linux.alibaba.com>
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To BL0PR11MB3060.namprd11.prod.outlook.com
 (2603:10b6:208:72::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3060:EE_|SN7PR11MB6601:EE_
X-MS-Office365-Filtering-Correlation-Id: 25fd19c0-2104-47cd-0c96-08db3698449b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /AgmABMrnqT6cLWLTW3R/C2KNmhqSQeCJdmbrfYW29vsVpvd5n9+nKMoef1pMqJQTWiqUOqJy+hqGiZqIJNpDIFILSKTXHbyWkBX7vz6UYhn6gHl2mP5M+FKR9uLNZvF20h1Kcil6KxKypFGgoS8+0Zc07d9JY1GqQbvOa4rWzYJ0srcREzFZe6yCn/kEtvKrhgwpQ6wQ4JbOpnFfBBGaZ4w5x5Ulj07dLvaTQwsW1apb0YvQzs0MpEu8U045yViFbgiIscvJhpoNRRogdP4Iu0R3zILno69w69jUHLcrgsLkLjkGzpZG5X03MerZU8WQ8F50gUc5SRfkWACuauk4OvxIDMb9gRMLreGohBXWWq2clQzFl2XqoHwS9tiK127jUWljCKo02tVigO1bUxRMrfIy2UXIQO7wp48nqmYXJFyMWEKFjtWRKyySUZJvBjvfHtijxevckMIVHA5RigsE0PPfWOmaeTJMkjsQ+/IaNvNeAgkcauxbt4MBT1K9Sugk4OmVMslJSbSMgcQ6LXNDZj9YF6iMY1YJ/FV0MDRkqsoLoVEmdGssxnhkqegj16Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3060.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199021)(66574015)(83380400001)(478600001)(6486002)(6666004)(186003)(316002)(26005)(9686003)(6512007)(6506007)(1076003)(33716001)(5660300002)(2906002)(44832011)(33656002)(38100700002)(66946007)(66556008)(66476007)(6916009)(82960400001)(4326008)(41300700001)(8676002)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?9UsR1PkNV9q/pg5aEQIj+Ux+PiUwS4APKpBGAddbfAL3CdK/pjePoHZIbQ?=
 =?iso-8859-1?Q?e/IWwPCzD8bXZxE1GSSuB6KXk/dvE30IlwpNlLeshKNQh13QXXKdJvMIQK?=
 =?iso-8859-1?Q?/HGH5tHgqfip1Pxy2Nan7bX6m01XThAtsyFeRHOEJyNCSrBcyUiCzKmYyD?=
 =?iso-8859-1?Q?/O+72R2WARFOCa3WMsda+cdhTLcmkyIBTGlT22h4jTmTG4aR+8mfKE87+y?=
 =?iso-8859-1?Q?7CNo2GoZjZaIZukT1LNf6fYqdz0uMzzaH8D56uvDNpHPTPYH+6Ub5DTFS2?=
 =?iso-8859-1?Q?tBeSjZxl3ocKmSgDgnVMkhvss41RzSKh0f0f4AKzXxZWoH2OdT2+h3qOOJ?=
 =?iso-8859-1?Q?P9nKkRg4PtpRt9GmuK6pJE5flNnv1z9L97PuYc7UcS033Ni+JQj+UQ05LR?=
 =?iso-8859-1?Q?oQWUs5yt1JqmErF49YrBcjg1KVcF3OIPVoKeNmuUy0jQiQsMKYhk8yjnsA?=
 =?iso-8859-1?Q?N65s5zCTsEUlWMvD0O8U7do382VMvMl5rN6iobgEQTRUlvqormIkA7olhw?=
 =?iso-8859-1?Q?5aqwZkJQjYYXEFXClAbXvECV7WWmh4ZX13FSQSDSluvD3rbASLVpVDnBDX?=
 =?iso-8859-1?Q?M4vUT2YYQT1cLh+KO0UGNO/O9YJxVPoTQxnEW/9Q12boPFizTHnjsoBIGj?=
 =?iso-8859-1?Q?faDDiD25AaAqhKcUwtFCR9SAVNAnfVrJvK/h32X0ikpEWx3Wi/eUX+84Lf?=
 =?iso-8859-1?Q?GzcDAeJ2bMNlCly91e5jswTedIRkHAqOsUP/SH/X/XYBYQPy2VHaLIMh1Y?=
 =?iso-8859-1?Q?OCdgG2uZ/Y4lU2Un2WSb79mNkMaV9UZK7AMRwuDr0ZiAxXEqOeM4mrFslI?=
 =?iso-8859-1?Q?nlwWJyc9tsuBraEBlG196V31cJhYvliJjWaIpBYp5UMDV2D9sFp4Nv36kB?=
 =?iso-8859-1?Q?TMyCAk+BgnvtaxXOLap5bX3NxlLPfsncUjnXB3U3IU5qYk6tnS80YLfeNU?=
 =?iso-8859-1?Q?vRQQxuR0/1UO8XTgzmAB2lv+fjC5g9ZONFIMUfrnhbidnjO7AsR/DP36xC?=
 =?iso-8859-1?Q?6yLyy8kXS8qA+KXhINnoUupl/VIxFHx2tzFKsJngP7XTO4m1ppuwPd3H3S?=
 =?iso-8859-1?Q?D7WpamrlfUrHLd1IXEO2mHzhueTLKi6HrbhoBqF4qz+B1tAT0W+acKZa+f?=
 =?iso-8859-1?Q?zUj5DLIsCLfr4xtmdPbPYUevP9o2lceNWLNPm+XT3SQVUuFJyDK/+0ieU+?=
 =?iso-8859-1?Q?V/NnFg4az4BY/kjqkLyEe7YRodkJ0o2hIvRTRzadBA9AO8jLo3Opx/AeSa?=
 =?iso-8859-1?Q?lEbQ9Ezc0n9Ic2jyhFkxtfnhnIVhDmJR8dAbBSp22ZxjXu4WasyTS+oYMn?=
 =?iso-8859-1?Q?ivyFLIYRvKkJYPqYVnJ0DQEvhnh7HyJW+fXdtPw/TuvIX78MnNABe0+YAf?=
 =?iso-8859-1?Q?VbaVTVoko2lEwzMyNwntXlnRZCoCWyonG5Nev1f6aP+CcO4SufDXNKXIFN?=
 =?iso-8859-1?Q?NM5K+ABjoz0Dk6dxI0NSyRiSn9IMNXQM0D5V5BPMcktsD6YptIPiGKut8t?=
 =?iso-8859-1?Q?WsBptLjx29644TLco4yFNjRh1bbqrQS9OWYoKqQxz9y7ee6Gy8TIomqsZ/?=
 =?iso-8859-1?Q?gTg++ePw8Dn8/VxyrdOAP4aM0XL3es3DusvoxAOnPt8QkwxC4eXxly2v/r?=
 =?iso-8859-1?Q?uxlMjRm5TPA+ld61CTvCwjsCoAIPGrpGRJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25fd19c0-2104-47cd-0c96-08db3698449b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3060.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 12:13:01.9661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1+JkgsptAPebiF4g0VxV72wznndXbSVhos5m9QCFKGaQ5t/S4BTGliR2ob8ptctahCP7XEIytaRrVQNGpVNuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:08:47AM +0800, Rongwei Wang wrote:
> Hello
> 
> I have fix up some stuff base on Patch v1. And in order to help all readers
> and reviewers to
> 
> reproduce this bug, share a reproducer here:

I reproduced this problem under a VM this way:

$ sudo ./stress-ng --swap 1
// on another terminal
$ for i in `seq 8`; do ./swap & done
Looks simpler than yours :-)
(Didn't realize you have posted your reproducer here since I'm not CCed
and just found it after invented mine)
Then the warning message normally appear within a few seconds.

Here is the code for the above swap prog:

#include <stdio.h>
#include <stddef.h>
#include <sys/mman.h>

#define SIZE 0x100000

int main(void)
{
        int i, ret;
        void *p;

        p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
        if (p == MAP_FAILED) {
                perror("mmap");
                return -1;
        }

        ret = 0;
        while (1) {
                for (i = 0; i < SIZE; i += 0x1000)
                        ((char *)p)[i] = 1;
                ret = madvise(p, SIZE, MADV_PAGEOUT);
                if (ret != 0) {
                        perror("madvise");
                        break;
                }
        }

        return ret;
}

Unfortunately, this test prog did not work on kernels before v5.4 because
MADV_PAGEOUT is introduced in v5.4. I tested on v5.4 and the problem is
also there.

Haven't found a way to trigger swap with swap device come and go on
kernels before v5.4; tried putting the test prog in a memcg with memory
limit but then the prog is easily killed due to nowhere to swap out.

> 
> swap_bomb.sh
> 
> #!/usr/bin/env bash
> 
> stress-ng -a 1 --class vm -t 12h --metrics --times -x bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap
> --verify -v &
> stress-ng -a 1 --class vm -t 12h --metrics --times -x bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap
> --verify -v &
> stress-ng -a 1 --class vm -t 12h --metrics --times -x bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap
> --verify -v &
> stress-ng -a 1 --class vm -t 12h --metrics --times -x bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap
> --verify -v
> 
> 
> madvise_shared.c
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <unistd.h>
> 
> #define MSIZE (1024 * 1024 * 2)
> 
> int main()
> {
>         char *shm_addr;
>         unsigned long i;
> 
>         while (1) {
>                 // Map shared memory segment
>                 shm_addr =
>                     mmap(NULL, MSIZE, PROT_READ | PROT_WRITE,
>                          MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>                 if (shm_addr == MAP_FAILED) {
>                         perror("Failed to map shared memory segment");
>                         exit(EXIT_FAILURE);
>                 }
> 
>                 for (i = 0; i < MSIZE; i++) {
>                         shm_addr[i] = 1;
>                 }
> 
>                 // Advise kernel on usage pattern of shared memory
>                 if (madvise(shm_addr, MSIZE, MADV_PAGEOUT) == -1) {
>                         perror
>                             ("Failed to advise kernel on shared memory
> usage");
>                         exit(EXIT_FAILURE);
>                 }
> 
>                 for (i = 0; i < MSIZE; i++) {
>                         shm_addr[i] = 1;
>                 }
> 
>                 // Advise kernel on usage pattern of shared memory
>                 if (madvise(shm_addr, MSIZE, MADV_PAGEOUT) == -1) {
>                         perror
>                             ("Failed to advise kernel on shared memory
> usage");
>                         exit(EXIT_FAILURE);
>                 }
>                 // Use shared memory
>                 printf("Hello, shared memory: 0x%lx\n", shm_addr);
> 
>                 // Unmap shared memory segment
>                 if (munmap(shm_addr, MSIZE) == -1) {
>                         perror("Failed to unmap shared memory segment");
>                         exit(EXIT_FAILURE);
>                 }
>         }
> 
>         return 0;
> }
> 
> The bug will reproduce more quickly (about 2~5 minutes) if concurrent more
> swap_bomb.sh and madvise_shared.
> 
> Thanks.
