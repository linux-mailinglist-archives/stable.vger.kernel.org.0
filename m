Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAAB4A533B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 00:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiAaXa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 18:30:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:62437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbiAaXa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 18:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643671856; x=1675207856;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=jxQuuG6kasouG/JKhb5u3sD67QX+ew8C/wyuC7LOFck=;
  b=PGBtYlFx62CtCCNUpAd/CGuPmW5pajZPMo7xqt/CM40qLgXUOIDOxEB0
   wuqexpseYn5md8buxrDIZFo9M42wFn6QQFW5+sPo/pCJK/ZO820wKwPrb
   m2aIkmRyXoA7ciQW1fOeEViootHSBpBx9jNYRimgJEdIRYLuqAtxyx7fv
   ARG/O+ohUUYqCTJ4clBQxFM6wasH+6edBLUQp6kIJe3fpKzqf753H/TLw
   owtBWTzBRCS8gz3Wd8opwfgGPzQ3AJevFRozLEXCAITPyO6Z1R+Fn/CnO
   ZXwl1AWZB2yPSW00IaZTzEqvddmD6GLyHf51IB+2AjDuGxLTe938hIMUx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="246408419"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="246408419"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:30:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="630194184"
Received: from kcoopwoo-mobl1.amr.corp.intel.com (HELO [10.252.132.7]) ([10.252.132.7])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:30:55 -0800
Message-ID: <8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com>
Date:   Mon, 31 Jan 2022 15:30:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <YfJDV63oGmWOmO4F@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <YfJDV63oGmWOmO4F@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/22 23:01, Jarkko Sakkinen wrote:
> On Sat, Jan 08, 2022 at 04:05:10PM +0200, Jarkko Sakkinen wrote:
>> +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
>> +{
>> +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
>> +}
> Found it.
> 
> This should be 
> 
> static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> {
> 	return PFN_DOWN(encl->size) + 1 + (index * PAGE_SIZE) / sizeof(struct sgx_pcmd);
> }

I've looked at this for about 10 minutes and been simultaneously
confused as to whether it is right or wrong.  That makes it
automatically wrong. :)

First, this isn't calculating a "PCMD number".  It's calculating backing
offset.  The "PCMD number" calculation is only a part of it.  I think
that makes the naming rather sloppy.

Second, I think the typing is sloppy.  page_index for example:

> static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>                            struct sgx_epc_page *epc_page,
>                            struct sgx_epc_page *secs_page)
> {
...
>         pgoff_t page_index;

It's storing a page number:

                page_index = PFN_DOWN(encl->size);

not a real offset-into-a-file.  That makes it even more confusing when
'page_index' crosses a function boundary, gets renamed to 'index' and
then its units get confused.

/*
 * Given a page number within an enclave (@epc_page_nr), calculate the
 * offset in bytes into the backing file where that page's PCMD is
 * located.
 */
-static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl
*encl, pgoff_t index)
+static inline pgoff_t sgx_page_nr_to_pcmd_nr(struct sgx_encl *encl,
unsigned long epc_page_nr)
{
	pgoff_t last_epc_offset = PFN_DOWN(encl->size);
	pgoff_t pcmd_offset;

	// The SECS page is stashed in a slot after the
	// last normal EPC page.  Leave space for it:
	last_epc_offset++;

	pcmd_offset = epc_page_nr / sizeof(struct sgx_pcmd);

	return last_epc_offset + pcmd_offset;
}

Looking at that, I still think your *original* version is correct.

Am I just all twisted around from looking at this code too much?  Could
you please take another look and send a new version of the patch?
