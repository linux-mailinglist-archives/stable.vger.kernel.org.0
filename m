Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48124C3354
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiBXRPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiBXRPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:15:07 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E6E29EB94;
        Thu, 24 Feb 2022 09:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645722877; x=1677258877;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=BmfD8NEvTaMkyVp8i1s9El4tLSdJA8+UBXOTKmrm3QI=;
  b=AzWf098aT//uHgdtBBSZY7kAseWscbBTHu5jZBwOIG74oyNHOXyzfg8f
   KnQMsOa3Sz/b+93cMV+tvZJVUrfGQPfrtaRprYbgeM0Y4NdUEyTmjPWE0
   4hWTw0IlJ8pG+4dXEE6IISctZHSuZMgvOQKPZTx6BhxdUJZDcDwnM46PF
   Dtz7HDGD/NBGUliz2fcsklRF0g5uZxqnBZ3Yk7t6V7xXEfG6tvFB+8oYO
   ltJe+4tc/Y77MPhiJEAW/pZVtPLd1nIZtN+t74JEg9IdxAjC1J+wmSkMf
   gPOc9g6S+CgkcKoyYG0xGkwDMMyLWoIlSgt3IdoeeJ+MrDYgQEgh/ON97
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="313008314"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="313008314"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 09:14:09 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="548841064"
Received: from vpirogov-mobl.amr.corp.intel.com (HELO [10.252.137.68]) ([10.252.137.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 09:14:09 -0800
Message-ID: <33646f1e-da44-503a-c454-02658d512926@intel.com>
Date:   Thu, 24 Feb 2022 09:14:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220222120342.5277-1-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <20220222120342.5277-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/22 04:03, Jarkko Sakkinen wrote:
> +	if (pcmd_page_empty) {
> +		pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ +
> +				   page_index * sizeof(struct sgx_pcmd);
> +
> +		sgx_encl_truncate_backing_page(encl, PFN_DOWN(pcmd_off));
> +	}
> +
>  	return ret;
>  }
>  
> @@ -583,7 +613,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>  static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  				struct sgx_backing *backing)
>  {
> -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ + page_index * sizeof(struct sgx_pcmd);

Jarkko, I really don't like how this looks.  The '/* SECS */' thing is
pretty ugly and the comment in the middle of an arithmetic operation is
just really hard to read.

Then, there's the fact that this gem is copied-and-pasted.  Oh, and it
looks a wee bit over 80 columns.

I went to the trouble of writing a nice, fully-fleshed-out helper
function for this with a comment included:

> https://lore.kernel.org/all/8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com/

Was there a problem using that?  The change from the last version is:

* Sanitized the offset calculations.

Given that there have been multiple different calculations over the four
versions so far, which version was right?  v3 or v4?
