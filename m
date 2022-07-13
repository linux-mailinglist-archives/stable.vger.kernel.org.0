Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE239572A29
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 02:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGMACn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 20:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGMACl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 20:02:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D5CC920D;
        Tue, 12 Jul 2022 17:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657670560; x=1689206560;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kdCtzz8hLTDNSKKBbslq6IoltGk6V2ylCavR3y0UtZY=;
  b=ePJStqxRXYF9uhLc0V4ohLhDKxSK7eChZO12hLMTOUrcUTtCjNhb3GRU
   NRtY4K9PGYeaKGvamTkFKN0JfkVH65u/Bk6yacgXlOYiR2Ks0R3Wfkv0G
   l1bhy31B/KbOoqoer3iGPPdkHx1uf7y9qTV16l1WAtxKCWGTe1kK4lq2E
   ExGg1Z80Kekbj7+gFTvBxXT/0XHrc0eeq58cURTv2A/xU1CgdIyduw7Fp
   +D7k9LsDLMK2/SFV4vSkE7I5HJendvKG/qcas2jlMkIDQRX05jo1FPoV2
   LJY5uQYVeLhEUqr1YYy5wXJEgl/TC8SXrJdehBhy4yG4lkT26H92MNlzL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="268107882"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="268107882"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="653125591"
Received: from jcai9-mobl2.ccr.corp.intel.com (HELO [10.255.29.95]) ([10.255.29.95])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:02:37 -0700
Message-ID: <597af953-b09d-f893-cdce-fa5d840e5cfe@linux.intel.com>
Date:   Wed, 13 Jul 2022 08:02:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        iommu@lists.linux.dev, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: avoid invalid memory access via
 node_online(NUMA_NO_NODE)
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220712153836.41599-1-alexandr.lobakin@intel.com>
 <20220712154407.42196-1-alexandr.lobakin@intel.com>
 <CAAH8bW8-JL=q_4c_AKROsjC7KyuRWDMFNKBz=6uT+d1mStTE2A@mail.gmail.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CAAH8bW8-JL=q_4c_AKROsjC7KyuRWDMFNKBz=6uT+d1mStTE2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/7/12 23:54, Yury Norov wrote:
> On Tue, Jul 12, 2022 at 8:45 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
>>
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Date: Tue, 12 Jul 2022 17:38:36 +0200
>>
>>> KASAN reports:
>>>
>>> [ 4.668325][ T0] BUG: KASAN: wild-memory-access in dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
>>> [    4.676149][    T0] Read of size 8 at addr 1fffffff85115558 by task swapper/0/0
>>> [    4.683454][    T0]
>>> [    4.685638][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc3-00004-g0e862838f290 #1
>>> [    4.694331][    T0] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
>>> [    4.703196][    T0] Call Trace:
>>> [    4.706334][    T0]  <TASK>
>>> [ 4.709133][ T0] ? dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
>>>
>>> after converting the type of the first argument (@nr, bit number)
>>> of arch_test_bit() from `long` to `unsigned long`[0].
>>>
>>> Under certain conditions (for example, when ACPI NUMA is disabled
>>> via command line), pxm_to_node() can return %NUMA_NO_NODE (-1).
>>> It is valid 'magic' number of NUMA node, but not valid bit number
>>> to use in bitops.
>>> node_online() eventually descends to test_bit() without checking
>>> for the input, assuming it's on caller side (which might be good
>>> for perf-critical tasks). There, -1 becomes %ULONG_MAX which leads
>>> to an insane array index when calculating bit position in memory.
>>>
>>> For now, add an explicit check for @node being not %NUMA_NO_NODE
>>> before calling test_bit(). The actual logics didn't change here
>>> at all.
>>
>> Bah, forgot to insert the link here. Hope not worth resending ._.
>>
>> [0] https://github.com/norov/linux/commit/0e862838f290147ea9c16db852d8d494b552d38d
> 
> I'll add this link and apply the patch to the bitmap-for-next, after
> some testing.

Thank you!

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

