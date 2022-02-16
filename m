Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3E4B7C02
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 01:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiBPAkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 19:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiBPAkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 19:40:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2053B60D86;
        Tue, 15 Feb 2022 16:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644971998; x=1676507998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cd+0YC9gWXPn8NbISSpcfmmX5qnlmxqRhaAzyaZQsHk=;
  b=L+Nhu0Zf4KhSo06pMy1EB9CB7vLUWuHJUOl29gfwObGjvQT2cfbcW+Am
   +LS8dxvAUFB1/EZXAaCMFPB+3TyL5G2MNubjJbvpUTbtZmfrWJAqPJXRv
   8l0mw0yfABJC/ccWqtgHOTP9Z2d1CYkG1wwidxYRROdo3/ttJbq59MkEm
   4Q4R1qxT46BEiZdskFSMERPX+iDxNErHrb+1emcIIyFwzHG8c4xPv9ec0
   nTSoiOgBqoipGRcrrM+Toz41H3xwJJo9OPIgbuymcI72Lv0RBFn2ON925
   E/hWFnUCIG/USg4rW7NlzBt9eBYFEEVwX6l8OLmF5pQCaJFXTi+3qCZrY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275070166"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="275070166"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 16:39:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="636226996"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.209.113.151])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 16:39:51 -0800
Date:   Tue, 15 Feb 2022 16:39:50 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YgwAHU7gCnik8Kv6@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 20:33, Borislav Petkov wrote:
>On Tue, Feb 15, 2022 at 10:19:31AM -0800, Pawan Gupta wrote:
>> I admit it has gotten complicated with so many bits associated with TSX.
>
>Yah, and looka here:
>
>https://github.com/andyhhp/xen/commit/ad9f7c3b2e0df38ad6d54f4769d4dccf765fbcee
>
>It seems it isn't complicated enough. ;-\
>
>Andy just made me aware of this thing where you guys have added a new
>MSR bit:
>
>MSR_MCU_OPT_CTRL[1] which is called something like
>MCU_OPT_CTRL_RTM_ALLOW or so.

RTM_ALLOW bit was added to MSR_MCU_OPT_CTRL, but its not set by default,
and it is *not* recommended to be used in production deployments [1]:

   Although MSR 0x122 (TSX_CTRL) and MSR 0x123 (IA32_MCU_OPT_CTRL) can be
   used to reenable Intel TSX for development, doing so is not recommended
   for production deployments. In particular, applying MD_CLEAR flows for
   mitigation of the Intel TSX Asynchronous Abort (TAA) transient execution
   attack may not be effective on these processors when Intel TSX is
   enabled with updated microcode. The processors continue to be mitigated
   against TAA when Intel TSX is disabled.

> And lemme quote from that patch:
>
>            /*
>             * Probe for the February 2022 microcode which de-features TSX on
>             * TAA-vulnerable client parts - WHL-R/CFL-R.
>             *
>             * RTM_ALWAYS_ABORT (read above) enumerates the new functionality,
>             * but is read as zero if MCU_OPT_CTRL.RTM_ALLOW has been set
>             * before we run.  Undo this.
>             */

Such development-only bit (SDV_ENABLE_RTM) existed for previous round of
TSX defeature, but we decided not to use it:

   https://lore.kernel.org/lkml/20210611232114.3dmmkpkkcqg5orhw@gupta-dev2.localdomain/

I am not sure why do we need to handle RTM_ALLOW this time? I will
update the patch if you think otherwise.

Thanks,
Pawan

[1] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
     https://cdrdv2.intel.com/v1/dl/getContent/643557


>so MCU_OPT_CTRL.RTM_ALLOW=1 would have
>CPUID.X86_FEATURE_RTM_ALWAYS_ABORT=0, which means, we cannot tie TSX disabling on
>X86_FEATURE_RTM_ALWAYS_ABORT only.
>
>So this would need more work, it seems to me.
>
>Thx.
>
>-- 
>Regards/Gruss,
>    Boris.
>
>https://people.kernel.org/tglx/notes-about-netiquette
