Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F65575533
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbiGNSmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiGNSmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:42:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AE8599F6;
        Thu, 14 Jul 2022 11:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657824154; x=1689360154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VLaGZ0CFcCMDw4sKrezyshgqgNu52lSz3UC7gONrKKM=;
  b=C1t1w87kosiH+02dpsYA7EXoIhh+dyMdmaohh+fxi9i7vA0UQPR/MXKM
   U+YzajLc0RLDtloH55IgBTBtsdbXoXHaUrFEl05mYJFPxX4yKueFm8XDO
   D7bU6aCGotngx6FH33grnmaUAR0gZaCViRTXri5OzO4UjfvraUBfUfqlj
   7P+XWYI36Rs++EOliz36zag8PV/2AOjkNavpPnkwrYnpNTtaFeczy481U
   lzFZKEmucL8SUCswwwr5ZkSPBYt0svtIoJB/5xeSDfhgQO64o7ac1g9m9
   p45ELtSi4rjxsUhXSmtgc5ceUmoaJRRkNiL+xc4g+i8htIhndhJ19rB9d
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268629871"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="268629871"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:42:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="653996066"
Received: from pravinpa-mobl.amr.corp.intel.com (HELO desk) ([10.212.243.89])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:42:32 -0700
Date:   Thu, 14 Jul 2022 11:42:29 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on
 Enhanced IBRS parts
Message-ID: <20220714184229.lw24xiqzwlcxjnaq@desk>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
 <20220714160106.c6efowo6ptsu72ne@treble>
 <YtBMZMaOnA8g8m0a@worktop.programming.kicks-ass.net>
 <20220714173814.p5kdyimu6ho7zjt5@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220714173814.p5kdyimu6ho7zjt5@treble>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 10:38:14AM -0700, Josh Poimboeuf wrote:
>On Thu, Jul 14, 2022 at 07:03:32PM +0200, Peter Zijlstra wrote:
>> On Thu, Jul 14, 2022 at 09:01:06AM -0700, Josh Poimboeuf wrote:
>>
>> > > Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
>> > > the 'I know better, let me change that for you' mentality.
>> >
>> > eIBRS CPUs don't even have legacy IBRS so I don't see how this is even
>> > possible.
>>
>> You can still WRMSR a lot on them. Might not make sense but it 'works'.
>
>Even in Intel documentation, eIBRS is often referred to as IBRS. It
>wouldn't be surprising for a user to consider spectre_v2=ibrs to mean
>"use eIBRS".
>
>I'm pretty sure there's nobody out there that wants spectre_v2=ibrs to
>mean "make it slower and possibly less secure because it's being used
>contrary to the spec".

Apart from testing, I don't see a reason for a user to deliberately
choose =ibrs on Enhanced IBRS parts. But, I am guessing most users would
just rely on "=auto" mode.

So honoring what the user asked and printing a warning may be fine. And
hope they would see the warning if they unintentionally chose "=ibrs" on
an eIBRS part.

Thanks,
Pawan
