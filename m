Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217C24B7667
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiBORMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:12:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiBORMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:12:14 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E06117C84;
        Tue, 15 Feb 2022 09:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644945124; x=1676481124;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d38tl0MQIETFrf/3nyTowNCgvGyOO+aSt3S40hbBUpg=;
  b=etabFyLX9TMnTi7xMxjXMzsFfdAlNiwSX9ZocJ9fn+dLeskoPxlsORIT
   lSEabio3JRWnFFY1yJhOF2obvn4QaggrwJiEumXrRpFIahqsBVHeLM4c9
   zcqdnHkD/z61ujJhC5L+FDLr+ItTfZhTItToNc43mOI9675LAxZOJWfh8
   Um3jVSpRLP4nT3KwAGd60KAKYHKhZlFAkfPlhYdGyVvzjcDTr75/mr5tW
   hEN8DGnt9lezx7onx3Ia1w0PXqUYIjcxe3TmuErU0nLP7Cd9OlGafjmdV
   vg+yQOW/LZ6oJksc137KTIZTXGPTAYUtFjTG15EOwd1tvA0bGJtXpEgld
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="311139123"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="311139123"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:10:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="775934874"
Received: from tngodup-mobl.amr.corp.intel.com (HELO [10.209.32.98]) ([10.209.32.98])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:10:03 -0800
Message-ID: <792d3b0c-0cb8-a407-2618-a53f40e501ca@intel.com>
Date:   Tue, 15 Feb 2022 09:10:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>,
        Guenter Roeck <groeck@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220215153644.3654582-1-bgeffon@google.com>
 <CABXOdTe09SxzEpJE_BJO5=4NTjZt2a6zMviMzDH47X5MZao7WA@mail.gmail.com>
 <CADyq12x0CXu_0Cs4At8GVqxWW6tvDGKzhESQpvL8cztHLnBG2w@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CADyq12x0CXu_0Cs4At8GVqxWW6tvDGKzhESQpvL8cztHLnBG2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/22 08:19, Brian Geffon wrote:
> This only applies before 5.13, so 5.10.y and 5.4.y, the behavior
> decoupled PKRU from xstate in a long series from Thomas Gleixner, but
> the first commit where this would have been fixed in 5.13 would be:
> 
>   commit 954436989cc550dd91aab98363240c9c0a4b7e23
>   Author: Thomas Gleixner <tglx@linutronix.de>
>   Date:   Wed Jun 23 14:02:21 2021 +0200
> 
>     x86/fpu: Remove PKRU handling from switch_fpu_finish()

Could you also describe why the >=5.13 fix for this isn't suitable for
older kernels?
