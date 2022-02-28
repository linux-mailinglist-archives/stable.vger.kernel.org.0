Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF234C70A5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 16:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbiB1Pcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 10:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbiB1Pcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 10:32:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8B882D15;
        Mon, 28 Feb 2022 07:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646062328; x=1677598328;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=A3kdMGKBPJg68rq8VDU9FNscngH3Bv2jiEeKZ84eaOw=;
  b=biKhEqbL/4pJO/5Z/e5X+uftMwbynO0DNV0e5RfST5Ug7eMNSItTrvG2
   uUUsxblvF6UytWbQ/wltoVNiP1ib+LBmS8ZGAdOBHBapabnVgg393H1p6
   EeaCQ1ijGYATYDcJJ5RwG07mgB8Qlfbx6xf4PNU4gILnHg6DtN5T0yvXv
   YJvfrnIf0ge6c1JmwUQyUJwfeR0zUTx0fpNO9Teb38VSi0+bmHK3/9gqm
   9hO7L2Wz8HXMilMSKJwxmJM1yxwa1E54+exHGFE1DEtM6pMgjwqdzDzxc
   qeEfL5PpE3eSDs/ZhB+qGGcpp2vmsqcNot2XTF19UIsS7VTmp2hZi6bKt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="236412845"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="236412845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 07:32:08 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550281259"
Received: from eliasbro-mobl.amr.corp.intel.com (HELO [10.212.174.65]) ([10.212.174.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 07:32:07 -0800
Message-ID: <0e06910b-9313-94ae-11e3-10a2b14645f2@intel.com>
Date:   Mon, 28 Feb 2022 07:32:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220222120342.5277-1-jarkko@kernel.org>
 <33646f1e-da44-503a-c454-02658d512926@intel.com> <YhzGS+x0eNoc3gyN@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <YhzGS+x0eNoc3gyN@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/28/22 04:55, Jarkko Sakkinen wrote:
> I thought that the formula is so simple that it does not matter if it is
> just in two sites open coded but I can wrap it too, if required, e.g.
> 
> /* 
>  * Calculate byte offset of a PCMD struct associated to an enclave page.
>  * PCMD's follow right after the EPC data in the backing storage. In
>  * addition to the visible enclave pages, there's one extra page slot
>  * for SECS, before PCMD data.
>  */
> static pgoff_t *sgx_encl_page_index_to_pcmd_offset(struct sgx_encl *encl, unsigned long page_index)
> {
>         return encl->size + PAGE_SIZE + page_index * sizeof(struct sgx_pcmd);
> }

Yes, it's required.  Please wrap it.

There's also nothing wrong with spreading that calculation across
several lines.  It may be arithmetically simple, but it's combining
three or four logical steps.  There's no shame in separating and
commenting some of those separately.
