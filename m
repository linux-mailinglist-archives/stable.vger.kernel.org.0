Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36B15A0180
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbiHXSnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 14:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiHXSnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 14:43:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0DD7A761;
        Wed, 24 Aug 2022 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661366591; x=1692902591;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6eT7fMb+dHOWan1/ECU9slGyuY/ttLNe4NtX2rjpGl0=;
  b=P0+wXy29db0FReQCPOhxw+WMqLieGJdlSDL7lZE+yLkv2xA8o1NAwYui
   kELcD19gvgXlHOS0lu4V5VV8rGlrAFAPxIqzz/BAE0jHKgDBOtoKuxlbu
   Tlvbj11Ez1dbhwbFmDzCJZJ6OAnwREH+iFBn5B9AvWefgoe5BFnZ19feE
   AIvXfYiFAcpT0wIN8wHcqNStrOIwodR3cPtFb1T7JH43Q6wvzaZe2iArY
   34wkt6Cut5+MnA6hJc0v6/rXqWdIdlGuyDy60oLiehrmORrBkYdSu2qpw
   QuWxiwqSiOv6TiSYqJajRS/yMT2NI1675e08rkOAS+2+1uvVHQqWOZAne
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="274436973"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="274436973"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 11:43:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="938022285"
Received: from skeshri-mobl.ger.corp.intel.com (HELO [10.212.154.182]) ([10.212.154.182])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 11:43:10 -0700
Message-ID: <10bc452f-3564-e41b-836d-e135a8f4260d@intel.com>
Date:   Wed, 24 Aug 2022 11:43:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/sev: Don't use cc_platform_has() for early SEV-SNP
 calls
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Asish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <0c9b9a6c33ff4b8ce17a87a6c09db44d3b52bad3.1661291751.git.thomas.lendacky@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0c9b9a6c33ff4b8ce17a87a6c09db44d3b52bad3.1661291751.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 14:55, Tom Lendacky wrote:
> When running identity mapped and depending on the kernel configuration,
> it is possible that cc_platform_has() can have compiler generated code
> that uses jump tables. This causes a boot failure because the jump table
> uses un-mapped kernel virtual addresses, not identity mapped addresses.
> This has been seen with CONFIG_RETPOLINE=n.

So, we don't have *ANY* control over where the compiler uses jump
tables.  The kernel just happened to add some code that uses them, fell
over, and this adds a hack to get booting again.

Isn't this a bigger problem?
