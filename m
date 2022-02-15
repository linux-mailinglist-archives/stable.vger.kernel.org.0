Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2902A4B76E8
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiBOSTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 13:19:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbiBOSTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 13:19:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EAE119879;
        Tue, 15 Feb 2022 10:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644949174; x=1676485174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P9zFJazI8GsRRCQz2MtpSRqxzmJPpB4uR+2Oqsy/Ww0=;
  b=nHH4v6v/eKSTlmysgItDr1HqfPhRHbxdtXCUAwIjW2pgUmClolBSTuMO
   2lQPYODyDY3bjZAY/OSpDRnD17ZBSzWSHkurB9XSY3sGFDoMe2MGApqKf
   /tuDqUyXpP5krGerZ7ErceZ09n0en/4Okw0AcFvqQKuAVgdcA9TRvtcGq
   GpApUuOeXj6cwUenpBxAXNDN601Ph9J2BIl1mNe18Ctvqt8C6kVwnl88i
   PyCXeE+fBHLcPxEJwktF3sTPoL8gBGDU1X32oBQeXdyPGYaiwKbLF5Tqr
   7rjoAvrtzOwNYZqZ1xhl8/y8wd9TvOp2guV0Kii6PyQnlYr5lVKUDRRN5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="231051929"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="231051929"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 10:19:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="486295210"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.212.198.79])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 10:19:33 -0800
Date:   Tue, 15 Feb 2022 10:19:31 -0800
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
Message-ID: <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YgvVcdpmFCCn20A7@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 17:31, Borislav Petkov wrote:
>On Tue, Feb 15, 2022 at 04:11:03AM -0800, Pawan Gupta wrote:
>> That is exactly what this patch is fixing. Please let me know if you
>> have any questions.
>
>Just one: does the explanation I've written for this mess, sound about
>right?

I admit it has gotten complicated with so many bits associated with TSX.
Your explanation is accurate. I just have a small suggestion below.

>+/*
>+ * Disabling TSX is not a trivial business.
>+ *
>+ * First of all, there's a CPUID bit: X86_FEATURE_RTM_ALWAYS_ABORT
>+ * which says that TSX is practically disabled (all transactions are
>+ * aborted by default). When that bit is set, the kernel unconditionally
>+ * disables TSX.
>+ *
>+ * In order to do that, however, it needs to dance a bit:
>+ *
>+ * 1. The first method to disable it is through MSR_TSX_FORCE_ABORT and
>+ * the MSR is present only when *two* CPUID bits are set:

s/MSR/MSR bit MSR_TFA_TSX_CPUID_CLEAR/

Thanks,
Pawan
