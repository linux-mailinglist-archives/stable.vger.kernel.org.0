Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8807958AECA
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbiHERYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 13:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiHERYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 13:24:04 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F99765E;
        Fri,  5 Aug 2022 10:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659720244; x=1691256244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gA+aK7p4JPfKPh6XWb3jT6QvhY4lfvwF9wFUlII7414=;
  b=nOcAuOkAYDCvmQnpGI1mxztF3vXmNp0Fbw1Mlg26xkAslMlQpw8EbgER
   0A2zRTO3DfFA6ptozJdIVLY1xOe/SFbACxjpT2/DtVObrKLAKZRwSYVVn
   X58eHO/SGQU2PRcFmu1K41J6eXoyBS+4uJBKbffnRWBsPiEJgxxueK0bM
   56sBUsujAQfxqPvjUOvQJQRWRpxWwaP7DJi8G/4LqQSDN8b2/1hAbGSAl
   9QIm4SlT6LdK6Q1EEa7FmJ3EBcaW0Ir9adj0ZblE+FpaMOsRZZe0wiM+b
   cKohLG43uq+LmbYi6REGrb21TaUc6oitPOgPwWYZCU8Blz3lva3BSzsxY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="351969430"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="351969430"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 10:24:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="579571659"
Received: from rderber-mobl1.amr.corp.intel.com (HELO [10.212.217.71]) ([10.212.217.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 10:24:03 -0700
Message-ID: <b3464e21-95e8-a80e-bf98-3c90c06afb91@intel.com>
Date:   Fri, 5 Aug 2022 10:24:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] x86/fpu: Allow PKRU to be (once again) written by
 ptrace.
Content-Language: en-US
To:     Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20220804031632.52921-1-khuey@kylehuey.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220804031632.52921-1-khuey@kylehuey.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/22 20:16, Kyle Huey wrote:
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> for APIs that write XSTATE. This can be seen by running gdb and executing
> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> write to the PKRU register (which gdb performs through ptrace) is ignored.

Do you happen to have a reproducer for this sitting around?  I'd love to
get an addition to the pkeys selftest/ in place to make sure we don't
break this again.  PKRU is a very special snowflake.
