Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8762A4B7C7F
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 02:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbiBPB2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 20:28:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238335AbiBPB2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 20:28:54 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EC2CD5C6;
        Tue, 15 Feb 2022 17:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644974923; x=1676510923;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3f4y2yguXvUrU7lczgu8gh9tQfZt363S1MBqO0zPhoA=;
  b=I7IRy1s6SkucObgiO4o9dMgmcGx2YFoMCebj9SqXyhAuFo3CLMpDltoj
   B0IKGiXXYiZTWQZkGruATwWEzLtJYcAHme1wIg+oiIroXWk+1bewTaHvz
   f85eP63c2g7Wf7VmRxfQNV1zy7OA7Q6SE5SSkYPxv3cWbQx8RwA3KRywP
   e+R5+xlgPSQpgd6ULiXeugFOOCSQ1nNujeoIPAV74ROW1n7gy5J1+KdPD
   MQBOk8zOV14WHs14/2HTlSsw0iTqcKg1rgJpfkQsVuhRvLqnyMCxSzfK/
   SlWgw2wofKPzLVQjgpYS4L8IdyiGCOQkwgDlFVeINNSwN5OKntGYT6gZp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="311238524"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="311238524"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 17:28:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="529171432"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.209.113.151])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 17:28:42 -0800
Date:   Tue, 15 Feb 2022 17:28:41 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "neelima.krishnan@intel.com" <neelima.krishnan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
References: <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
 <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
 <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.02.2022 00:49, Andrew Cooper wrote:
>On 16/02/2022 00:39, Pawan Gupta wrote:
>> On 15.02.2022 20:33, Borislav Petkov wrote:
>>> On Tue, Feb 15, 2022 at 10:19:31AM -0800, Pawan Gupta wrote:
>>>> I admit it has gotten complicated with so many bits associated with
>>>> TSX.
>>>
>>> Yah, and looka here:
>>>
>>> https://github.com/andyhhp/xen/commit/ad9f7c3b2e0df38ad6d54f4769d4dccf765fbcee
>>>
>>>
>>> It seems it isn't complicated enough. ;-\
>>>
>>> Andy just made me aware of this thing where you guys have added a new
>>> MSR bit:
>>>
>>> MSR_MCU_OPT_CTRL[1] which is called something like
>>> MCU_OPT_CTRL_RTM_ALLOW or so.
>>
>> RTM_ALLOW bit was added to MSR_MCU_OPT_CTRL, but its not set by default,
>> and it is *not* recommended to be used in production deployments [1]:
>>
>>   Although MSR 0x122 (TSX_CTRL) and MSR 0x123 (IA32_MCU_OPT_CTRL) can be
>>   used to reenable Intel TSX for development, doing so is not recommended
>>   for production deployments. In particular, applying MD_CLEAR flows for
>>   mitigation of the Intel TSX Asynchronous Abort (TAA) transient
>> execution
>>   attack may not be effective on these processors when Intel TSX is
>>   enabled with updated microcode. The processors continue to be mitigated
>>   against TAA when Intel TSX is disabled.
>
>The purpose of setting RTM_ALLOW isn't to enable TSX per say.
>
>The purpose is to make MSR_TSX_CTRL.RTM_DISABLE behaves consistently on
>all hardware, which reduces the complexity and invasiveness of dealing
>with this special case, because the TAA workaround will still turn TSX
>off by default.
>
>The configuration you don't want to be running with is RTM_ALLOW &&
>!RTM_DISABLE, because that is "still vulnerable to TSX Async Abort".

I am not sure how a system can end up with RTM_ALLOW && !RTM_DISABLE? I
have no problem taking care of this case, I am just debating why we need
it.

One way to get to this state is BIOS sets RTM_ALLOW (dont know why?) and
linux cmdline has tsx=on.

Thanks,
Pawan
