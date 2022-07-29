Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931095854DF
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 20:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiG2SCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 14:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238452AbiG2SCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 14:02:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D7087C20;
        Fri, 29 Jul 2022 11:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659117752; x=1690653752;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y0+P/vHWqaRgVIxlZZfHJ7Fd2MGWeehyke55xUiYtkk=;
  b=g1PMCXTHGQsqulMzRFcaEjcHlrqECD0YqkVB5ouyhCqdfz8yLSE87EoV
   sLcSEUoy4vsWoAWdWZjGDXMcfxUHPIUL3hLqg0RsHrJy22kHt5xm4s7a6
   rMZlvt0eOOl+lNhFfRAOfINluqOW8aM08MtxFejgk9RLj170rsBg6vpj1
   TeUPl5RBMDUi/JJaZTltRiLd5xyU+XroIImcO8hJkv2hpNuB2uNJy/ieA
   bUfk2shhaRGcf8+36QQrHP6qyiVNecsFEEm+WJlH1jLpqpQMq4u/kce5X
   WeSXdxHZThOjN0WaRoN5aiWGPRILWeQTIYMe2Ga/O0tNJGMfUK8G9gZWp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="314624637"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="314624637"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 11:02:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="669348643"
Received: from svdas-mobl.amr.corp.intel.com (HELO [10.209.20.175]) ([10.209.20.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 11:02:30 -0700
Message-ID: <d71dc25e-ef26-b6c3-6c8e-fc5727b76a23@intel.com>
Date:   Fri, 29 Jul 2022 11:02:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <f173a7c0-b4f8-17f3-a65d-e581fed32368@intel.com>
 <20220729175959.w7gd5z7dsbxrnydn@desk>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220729175959.w7gd5z7dsbxrnydn@desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/22 10:59, Pawan Gupta wrote:
>> +       if (!boot_cpu_unknown_bug(bug))
>> +               return sprintf(buf, "Unknown\n");
>>
>> Thoughts?
> Sounds good. Similar to this Borislav suggested to add
> X86_BUG_MMIO_UNKNOWN. I will see if I can combine both approaches.

I'd say Borislav's is better if there is going to be a small number of
"unknown" things in total.  Mine might be better if we expect a *bunch*
of them.

In other words, I'm rooting for Borislav's.
