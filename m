Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B92A54E2D7
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiFPOC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiFPOC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:02:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE11D167C7;
        Thu, 16 Jun 2022 07:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655388176; x=1686924176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZslKAPTAUMP7uTqggxrE4svWSBJSaZawMtN5DxXgDVw=;
  b=fFV9kmDfAeYWBvXdxNDugtUOvubMnSgKHwdff6PvA1HZwOpxECyoQa8O
   9bhpLuWGNKiSKuOLwTwrbXUEw957GBe8X+98U1paF7BZqkCTV+phhtePk
   CN16pEc0GJ8FY6138+2z6QFYb3ua00WRjyA3Vr8DRN0gC06RrtoLLewm8
   k2I5WJWvsjHtz63vgB/8yhZvfogmQ630M05W64huM9j4vLsgYDr1I190D
   q1ZfcP2QDMjvBGI5BtEeieONeeTKVQPf5g2NBndbLJUAdjk5abBpIdERp
   iR87z990/OrO0OS/H+2ThdrC0lz8ZURDG2HOEsvRNua4gOtuox9Ycygaz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259107875"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="259107875"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 07:02:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="713368441"
Received: from rrmiller-mobl.amr.corp.intel.com (HELO [10.212.205.54]) ([10.212.205.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 07:02:55 -0700
Message-ID: <3e754cf7-35f8-0163-a24a-063fa3d96718@intel.com>
Date:   Thu, 16 Jun 2022 07:02:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] x86/mm: Fix possible index overflow when creating page
 table mapping
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220616135510.1784995-1-ytcoode@gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220616135510.1784995-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/22 06:55, Yuntao Wang wrote:
> There are two issues in phys_p4d_init():
> 
> - The __kernel_physical_mapping_init() does not do boundary-checking for
>   paddr_end and passes it directly to phys_p4d_init(), phys_p4d_init() does
>   not do bounds checking either, so if the physical memory to be mapped is
>   large enough, 'p4d_page + p4d_index(vaddr)' will wrap around to the
>   beginning entry of the P4D table and its data will be overwritten.
> 
> - The for loop body will be executed only when 'vaddr < vaddr_end'
>   evaluates to true, but if that condition is true, 'paddr >= paddr_end'
>   will evaluate to false, thus the 'if (paddr >= paddr_end) {}' block will
>   never be executed and become dead code.

Could you explain a bit how you found this?  Was this encountered in
practice and debugged or was it found by inspection?
