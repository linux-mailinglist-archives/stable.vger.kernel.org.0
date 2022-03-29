Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C194EB62F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 00:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiC2WtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 18:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiC2WtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 18:49:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99042E4398;
        Tue, 29 Mar 2022 15:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648594058; x=1680130058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pdOLRumwuZ4w5Szl+WdPHfiHl64YUM0WMm8nYgiPR6Q=;
  b=i6rg26QIz8BTlC173RbYKMZwzjT2bINwSeAdK+0YDVJwupxbYoTO3TU8
   z7JM7e2ZKvEgnpPJuZBYJYmYU60Qubp9nDNeI3ezbWAR8+YVN0o++PRSz
   0JB6Ys+zxf7sxc4VcpOPGkrnsCJ1DDcgBXSh5KrLcvNOSMsO2RAgHTFBl
   COo0o9UHrthem2v+4nvp1kCBiMQpVN4t9gf6KsJNeMy7+t14vR/3habbS
   emp83D57xzTKu1UeYEN12Fiq3pCw9fosGWEW9st1SyXF7WBPqQz+91nQp
   1Vodyy16Xp2k3XQ9+xIu2fspA757KgPDESoc0VJeaX2Ae4ogMrWSqnP40
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="246888616"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="246888616"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 15:47:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="719732935"
Received: from jahay1-mobl1.amr.corp.intel.com (HELO guptapa-desk) ([10.209.124.134])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 15:47:37 -0700
Date:   Tue, 29 Mar 2022 15:47:35 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/2] x86/tsx: Disable TSX development mode at boot
Message-ID: <20220329224735.4pyst64r4dsfz2ea@guptapa-desk>
References: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
 <347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com>
 <YkMyo2Jw8iYx9wAU@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YkMyo2Jw8iYx9wAU@zn.tnic>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 06:24:03PM +0200, Borislav Petkov wrote:
>On Thu, Mar 10, 2022 at 02:02:09PM -0800, Pawan Gupta wrote:
>> A microcode update on some Intel processors causes all TSX transactions
>> to always abort by default [*]. Microcode also added functionality to
>> re-enable TSX for development purpose. With this microcode loaded, if
>> tsx=on was passed on the cmdline, and TSX development mode was already
>> enabled before the kernel boot, it may make the system vulnerable to TSX
>> Asynchronous Abort (TAA).
>>
>> To be on safer side, unconditionally disable TSX development mode at
>> boot. If needed, a user can enable it using msr-tools.
>>
>> [*] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
>>     https://cdrdv2.intel.com/v1/dl/getContent/643557
>>
>> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
>> Suggested-by: Borislav Petkov <bp@alien8.de>
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  arch/x86/include/asm/msr-index.h       |  4 +--
>>  arch/x86/kernel/cpu/cpu.h              |  1 +
>>  arch/x86/kernel/cpu/intel.c            |  4 +++
>>  arch/x86/kernel/cpu/tsx.c              | 34 ++++++++++++++++++++++++++
>>  tools/arch/x86/include/asm/msr-index.h |  4 +--
>>  5 files changed, 43 insertions(+), 4 deletions(-)
>
>Does this a lot more encapsulated version work too?

It look good to me.

Thanks,
Pawan
