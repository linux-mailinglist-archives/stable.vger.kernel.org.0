Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC8B4B90E1
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 20:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiBPTD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 14:03:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiBPTD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 14:03:58 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86F513CA09;
        Wed, 16 Feb 2022 11:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645038225; x=1676574225;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fain4AjGeF3YbaPcoKuzSdMDXayLVEBSnhuXRjygehY=;
  b=bBpjKT1l+tkJwaId3Qt+s6Tm97dDP0jYOzvPzFKLGxz1fB2FVgKW/OAo
   mKymGrxJ5eFWNaUx1CrvmSEJsaStR8PnJ3blEdW8zPq+TYfpFXvq+Berh
   37Ey15CQuLc5mS1hjXf3eQqqoTd/B4Cx+GJuet1BGYeXfWNuaGBOT4j+w
   kmaKKBHNktJF5s6Gt7ZgpRz1+c3ECfuzrYs7X7UPn40XiPj8L4u45buhU
   OkiywTYPl6w/GYnTN2jNTlrIJ8QLFNTLqRKIqcJF23WREokzBlDe7/ouG
   +FrUX3v5JM5mVCeJDzZSJtdRZXR+tbO6w+vlQ0b/dVJD7gQFzRVlNbCYF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="275283434"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="275283434"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 11:03:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="704432435"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.212.185.96])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 11:03:43 -0800
Date:   Wed, 16 Feb 2022 11:03:42 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
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
Message-ID: <20220216190342.fzbwof5s3x64ln4u@guptapa-mobl1.amr.corp.intel.com>
References: <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
 <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
 <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
 <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
 <20220216060826.dwki2jk6kzft4f7c@guptapa-mobl1.amr.corp.intel.com>
 <YgzSR7AdRRU3hCuB@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YgzSR7AdRRU3hCuB@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.02.2022 11:30, Borislav Petkov wrote:
>On Tue, Feb 15, 2022 at 10:08:26PM -0800, Pawan Gupta wrote:
>> Alternatively, we can reset RTM_ALLOW,
>
>I'd vote for that. Considering how plagued TSX is, I'm sceptical anyone
>would be interested in doing development with it so we can reset it for
>now and allow enabling it later if there's an actual use case for it...

Okay, I will add RTM_ALLOW reset logic in the next revision.

Thanks,
Pawan
