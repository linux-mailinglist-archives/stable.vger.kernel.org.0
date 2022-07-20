Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4189257B7FE
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 15:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiGTN56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 09:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGTN5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 09:57:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CC02E6AE;
        Wed, 20 Jul 2022 06:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/V/i02J0VSRwEin3lvenpGuASuy6JoHCfCbef3bNo8k=; b=AJbBnkbb3Kn1TkfXCR8F78pR67
        dCBZGTOXmz1AK+Qv7hPVwD2CwqZlMbLWf1oNXN0QJYk2Kgztj5R9yWrnRMVK1DZxFMIOfuQb8z9CZ
        nx+Sf9zSC/W6vpjR99ssCoPnJNmjSA87DIfBPGvNDdtPNV89hGB+YYbcVB8Ul8eZr3PM2VVRTCpyH
        R2e+bixWFQJsN+9k2nP5n0aHLtngYIHvbFsBWeKdcxwdBQEiTX72kKq0szg+6OeXFvaJKklo1DWfW
        8q0evvqxehyTCnafLMCvG2FWzjrqFvKxUm9x0UCInyef7HIFVnswl8K2kbwr03kZGUbRG8Wqn6xYS
        /NtRKm/w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEACp-00EVuU-Ql; Wed, 20 Jul 2022 13:57:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6DC13980BBE; Wed, 20 Jul 2022 15:57:37 +0200 (CEST)
Date:   Wed, 20 Jul 2022 15:57:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, acme@kernel.org, vincent.weaver@maine.edu,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, pawan.kumar.gupta@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel/lbr: Fix unchecked MSR access error on HSW
Message-ID: <YtgJ0SObKBvRozBi@worktop.programming.kicks-ass.net>
References: <20220714182630.342107-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714182630.342107-1-kan.liang@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 11:26:30AM -0700, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The fuzzer triggers the below trace.
> 
> [ 7763.384369] unchecked MSR access error: WRMSR to 0x689
> (tried to write 0x1fffffff8101349e) at rIP: 0xffffffff810704a4
> (native_write_msr+0x4/0x20)
> [ 7763.397420] Call Trace:
> [ 7763.399881]  <TASK>
> [ 7763.401994]  intel_pmu_lbr_restore+0x9a/0x1f0
> [ 7763.406363]  intel_pmu_lbr_sched_task+0x91/0x1c0
> [ 7763.410992]  __perf_event_task_sched_in+0x1cd/0x240
> 
> On a machine with the LBR format LBR_FORMAT_EIP_FLAGS2, when the TSX is
> disabled, a TSX quirk is required to access LBR from registers.
> The lbr_from_signext_quirk_needed() is introduced to determine whether
> the TSX quirk should be applied. However, the
> lbr_from_signext_quirk_needed() is invoked before the
> intel_pmu_lbr_init(), which parses the LBR format information. Without
> the correct LBR format information, the TSX quirk never be applied.
> 
> Move the lbr_from_signext_quirk_needed() into the intel_pmu_lbr_init().
> Checking x86_pmu.lbr_has_tsx in the lbr_from_signext_quirk_needed() is
> not required anymore.
> 
> Both LBR_FORMAT_EIP_FLAGS2 and LBR_FORMAT_INFO have LBR_TSX flag, but
> only the LBR_FORMAT_EIP_FLAGS2 requirs the quirk. Update the comments
> accordingly.
> 
> Fixes: 1ac7fd8159a8 ("perf/x86/intel/lbr: Support LBR format V7")
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>

Thanks!
