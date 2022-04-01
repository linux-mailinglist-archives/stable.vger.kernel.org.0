Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18284EF91D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 19:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245292AbiDARok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 13:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiDARoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 13:44:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2027740A1F;
        Fri,  1 Apr 2022 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648834970; x=1680370970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l350qzJiVd8sPS5s1ZAsOW21hq4CN6KH7Zi8RQ7ouoo=;
  b=eAmR1AzAgGQ+QfiJhdM9NikuEXxPlVYI9QSE+gazT773uudgw/FLRa2e
   EqjDiVWCzFK41ponAXDUdAxqJ5jkmztXxg+rCnl/o/unqoOwtffOvwc20
   /kXv2CVZCz6JT5I0AvzZv3VNk7SwvGjgfP/66865DKCQ2KmM/RxfXfvZD
   hISCPgVSwIxihU0HqgAu7zMHc/FQL6YIjxMkgRADmAMP9Yjl9LJVWjb2P
   knEkYtGclFn3es7aWXvpgthSVuvcVhloLHGgryUm71c209h4c2LRxoZFP
   WgWrQillp1nd0tMzNGCHPcsQSjMSxNif/okGSwSy1iZLVGSQRob+A4VZG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="285125348"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="285125348"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 10:42:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="567669840"
Received: from dajones-mobl.amr.corp.intel.com (HELO [10.212.134.9]) ([10.212.134.9])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 10:42:48 -0700
Message-ID: <13463eca-03a2-da0d-c274-fb576a8a051f@intel.com>
Date:   Fri, 1 Apr 2022 10:42:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/22 03:47, Ammar Faizi wrote:
> The asm constraint does not reflect that the asm statement can modify
> the value of @loops. But the asm statement in delay_loop() does modify
> the @loops.
> 
> Specifiying the wrong constraint may lead to undefined behavior, it may
> clobber random stuff (e.g. local variable, important temporary value in
> regs, etc.). This is especially dangerous when the compiler decides to
> inline the function and since it doesn't know that the value gets
> modified, it might decide to use it from a register directly without
> reloading it.
> 
> Fix this by changing the constraint from "a" (as an input) to "+a" (as
> an input and output).

Was this found by inspection or was it causing real-world problems?
