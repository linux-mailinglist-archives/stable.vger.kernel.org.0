Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713EE5F6F12
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 22:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiJFU1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 16:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiJFU1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 16:27:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14890BEAC4;
        Thu,  6 Oct 2022 13:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665088026; x=1696624026;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tes0madONZScJefM8sUzOGl1lgaC9WI0wDedhGmunZU=;
  b=fcgI/2O6CVq8TmeiYdipyySAxtBBcrPIwDToi+bQPZMiFhK4aTj/gMXd
   PlGvrAD9YhnvusHb2oRFF32PnmiTRLmzObDnYyPU1h9NLjdIu7lEuyz9r
   3wZheAv4e+idnep/UnG38qdlhl7UJON1mt4mnLwS+/AbMhSvPBGsLeSDe
   MHYxK7PMdWIa4LEwq+WIPZ74g+HW/Oj4AmTW/nylknkzOAXivUnjEfnES
   pWyd4h96KiW9jDcif6Uon5nOIvrxVdbpPQCQTECTeGLTU116tISzbQcqV
   iVgoFjGtNKsUwB0B0ZBUNUtfbnEhy/353dLpdxSdLnQoaPt8AhNc2DHcr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="367688852"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="367688852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 13:27:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="655763947"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="655763947"
Received: from spvenkat-mobl.amr.corp.intel.com (HELO desk) ([10.209.50.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 13:27:05 -0700
Date:   Thu, 6 Oct 2022 13:27:03 -0700
From:   "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Jim Mattson' <jmattson@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@suse.de" <bp@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Message-ID: <20221006202703.efa3ovs4eckevire@desk>
References: <20221005220227.1959-1-surajjs@amazon.com>
 <CALMp9eTy2w_ZbkVSVvTwOW3wYH6vnn5waEWc0BesXL-kYRFy4g@mail.gmail.com>
 <a056259f338e411581b882555ed608cb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a056259f338e411581b882555ed608cb@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 08:25:15AM +0000, David Laight wrote:
>From: Jim Mattson
>> Sent: 05 October 2022 23:29
>>
>> On Wed, Oct 5, 2022 at 3:03 PM Suraj Jitindar Singh <surajjs@amazon.com> wrote:
>> >
>> > tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
>> > ensure a call instruction retires before a following unbalanced RET. Replace
>> > this with a WRMSR serialising instruction which has a lower performance
>> > penalty.
>>
>> The INT3 is only on a speculative path and should not impact performance.
>
>Doesn't that depend on how quickly the cpu can abort the
>decode and execution of the INT3 instruction?
>INT3 is bound to generate a lot of uops and/or be microcoded.
>
>Old cpu couldn't abort fpu instructions.
>IIRC the Intel performance guide even suggested not interleaving
>code and data because the data might get speculatively executed
>and take a long time to abort.
>
>I actually wonder whether 'JMPS .' (eb fe) shouldn't be used
>instead of INT3 (cc) because it is fast to decode and execute.
>But I'm no expect here.

I have been told that INT3 is better in this case because 'JMP .' would
waste CPU resources.
