Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1982B57595C
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiGOCAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241169AbiGOCAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:00:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2BA6EEAA;
        Thu, 14 Jul 2022 19:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657850410; x=1689386410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aEE4/Euh2qHrAILYfvyldQi2IAPiIrDYYbfnuSlUsBw=;
  b=jTrtCK61HWmXWGb9TqBc+TVnaKT7g8riDFL9STem6KULywif1xpcybJO
   oTwjdM5l2QW3pJEOkZVWxfz4D0tkWMYQqZ1y3i5/E/GWiX/FjWehbwsO5
   DCD/BvSwEMSfV/ixqO7aNDWbl9w82zRhY8HXYn4PUS/Bxh+JlJV+ER8Yt
   qyQwUH5z8Wcjxn2OK3d2EV5t1q14pS/8tsAFNPxeLCaSgHtPQ/4PwPahf
   D1zk+N4Mk+m6jW1wOAQ3zvnvFqu2Aim3YQTzXQRnn85f5N3pr2dm6mDl0
   yCoYpqSgkQOh6A6BXUiC7wRxs0+v8+PZJNcz+Olc7Uq2IRNIFsvM/vzUZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283237144"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283237144"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 19:00:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="738490446"
Received: from pravinpa-mobl.amr.corp.intel.com (HELO desk) ([10.212.243.89])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 19:00:09 -0700
Date:   Thu, 14 Jul 2022 19:00:05 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [PATCH v2] x86/bugs: Warn when "ibrs" mitigation is selected on
 Enhanced IBRS parts
Message-ID: <20220715020005.dixdi3qpb23iz6up@desk>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com>
 <YtCwpjeRVu4LVOyF@quatroqueijos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YtCwpjeRVu4LVOyF@quatroqueijos>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 09:11:18PM -0300, Thadeu Lima de Souza Cascardo wrote:
>On Thu, Jul 14, 2022 at 04:15:35PM -0700, Pawan Gupta wrote:
>> IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
>> every kernel entry/exit. On Enhanced IBRS parts setting
>> MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
>> every kernel entry/exit incur unnecessary performance loss.
>>
>> When Enhanced IBRS feature is present, print a warning about this
>> unnecessary performance loss.
>>
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>
>Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Thanks for the review.

Pawan
