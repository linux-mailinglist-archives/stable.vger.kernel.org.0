Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9DE59605C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiHPQfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiHPQfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:35:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB67539C;
        Tue, 16 Aug 2022 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660667700; x=1692203700;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZJuEH+xeEfgmWxr+pMcSuCS+a2R0PDUM9GKYt/jT5gU=;
  b=ZIvHOo3sSEkKjKCZlNgVYgZe+NBXl0p1QE0d/Tmmkn8evSXQzrsS17rs
   666/hLx64dmSrKxSo/ACc1EEf0s4dz6KfBZ+3uRmmrE5ObV7fJaOcV1B6
   SOu340VvCBkutlpf4/RGUg5DQdnbeDF6YdmsIl+P4cL0UBKuE5fJqpKoV
   GyFHhPGdCffFUcyLBEurYnvMqX39ARBLX3edfcBOrf7qQeQKqkP1C15RQ
   b/89rZm7QOq34nFn6RmV+AVcMnWQ+xXLV6CSlx6ZNS059yUEZfLOAtv6c
   jl5dTKoLLWxtjNjXGXRkDcNDHBnmvnzgq08fHIekm4Kmdxu7/ZgQiCCNa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="292266868"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="292266868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 09:35:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="852711662"
Received: from jzhu1-mobl.ccr.corp.intel.com (HELO [10.254.68.75]) ([10.254.68.75])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 09:34:59 -0700
Message-ID: <53f88d33-417a-001c-0313-a4b7bd6a45a6@linux.intel.com>
Date:   Tue, 16 Aug 2022 09:34:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <YvuOnkhj/Z8naRmN@kroah.com> <YvuPZYhoZLaSRKmr@zn.tnic>
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
In-Reply-To: <YvuPZYhoZLaSRKmr@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/22 05:36, Borislav Petkov wrote:
> On Tue, Aug 16, 2022 at 02:33:34PM +0200, Greg Kroah-Hartman wrote:
>> I need an Intel person
> 
> Daniel?
I'll test this.
> 
>> to test this as I have no idea how to do so as his is an issue in
>> tLinus's tree.
> 
> If this passes - and I have my both fingers crossed - this will be an
> amazing simplification.
> 
> Might wanna take it into stable too, when ready.
> 
> Thx.
> 

