Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7749498647
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiAXRRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:17:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:39156 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244293AbiAXRRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 12:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643044656; x=1674580656;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=vkC97LhOiQxk/LR6umBizHxOqQZsMaeH5iCHwQP820E=;
  b=Aq046+FncJRDahSsSH7jqxYhjiNMOEWzrh5t3ZcWHRxzOi2hg8AKFo+n
   3YJYLsWIr7a657G3gfxMp7R9Wgze3alDqU+oH33BVyNMmDwd86PNb3/WO
   yZPVFf5OgfnXLo7IV7zyGpfhWp8FCzpRRiZ+n6xj8DXUWHS8KUvU7aMbd
   b94CwiMf7OB0rsG8iOe/SxXtUMzDfhPFc7xYAeudYFBSbMOhpSgdlSzDQ
   3SfiCMAl+BExWMoFfjiFWht2sKp5U3AH/AuYrby5GGMcIBB0Is4jSg6+G
   EFYlv/xgsiIRA4T8eXtDxURPvMLldRdbKz6gwAzs6OXFgCTpAVYb5OZIM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="245879436"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="245879436"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:17:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="580459453"
Received: from jncomo-mobl.amr.corp.intel.com (HELO [10.251.27.220]) ([10.251.27.220])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:17:35 -0800
Message-ID: <b01342c0-97c8-a29e-d172-d53d051b683c@intel.com>
Date:   Mon, 24 Jan 2022 09:17:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/22 22:08, Reinette Chatre wrote:
> ------------[ cut here ]------------
> ELDU returned 9 (0x9)
> WARNING: CPU: 6 PID: 2470 at arch/x86/kernel/cpu/sgx/encl.c:77 sgx_encl_eldu+0x37c/0x3f0

Could we flesh out that error message, please?

That "return" is a code from "Information and Error Codes" in the SGX 
SDM chapter.  It's also spelled out in 'enum sgx_return_code'.  So, at 
least, this should probably say:

	ELDU sgx_return_code: 9 (0x9)

*That* is at least greppable.
