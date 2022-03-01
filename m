Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D7F4C9238
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiCARzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiCARzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:55:04 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D7832ED0;
        Tue,  1 Mar 2022 09:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646157262; x=1677693262;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=UWQCpVl9cqkY19Vah5HEIK0fbarDiE8S3ggwC/mbwts=;
  b=EgCJoAv1c6HpK/AHFAMleFbGQGHoJJyFkLf0BoqUs9KB1QKpyOugPIvn
   APoZ7l++iXYkx9uEcsyWgR6IHgBCJVISQtmM2NLIe+wrAiwWmKj6mLdIc
   YUa/646y3rJcLd0M2kN+Yey8DqLTUNKhBzN67K8AA58F7wV3slQT3Zxw0
   /oGbVkH2fU0fwuIBkourucz1b796JNQCAkr9+ovCZeQ2FxnSUGxvFT0q+
   BxEiO+s5PeCFzjSupI3Gp5MLq2NjS3TDzisTOmwlqCKrEcDwK8TsWANZC
   sXgQweKXrFsJHoZq4trqC+MBUowo8+klB+jJBKYrHoMG823NnMDkg95Xp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="277865996"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="277865996"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 09:54:21 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="550828073"
Received: from fpadash-mobl.amr.corp.intel.com (HELO [10.251.24.56]) ([10.251.24.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 09:54:20 -0800
Message-ID: <3a083b4d-9645-dec6-8cdc-481429dd0a1f@intel.com>
Date:   Tue, 1 Mar 2022 09:54:14 -0800
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
References: <20220301125836.3430-1-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v5] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <20220301125836.3430-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 04:58, Jarkko Sakkinen wrote:
> @@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	else
>  		page_index = PFN_DOWN(encl->size);
>  
> +	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
> +
>  	ret = sgx_encl_lookup_backing(encl, page_index, &b);
>  	if (ret)
>  		return ret;

What tree is this against?  It looks like it might be on top of
Kristen's overcommit series.

It would be best if you could test this on top of tip/sgx.  Kristen
changed code in this area as well.
