Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330CB59658B
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiHPWey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 18:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiHPWex (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 18:34:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1CC8B983;
        Tue, 16 Aug 2022 15:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660689293; x=1692225293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6pfW2WXsMRsIUuCNg17XL4F8HxUNrXi8GfvszKCgQcE=;
  b=n05bCByahb2b7aiyRZHfALVoRqwJJHNOjfSmOc5AsrdhMcjB0+AG1Omp
   l2DdfUBxi9G0M2ilYaobiWD1vesSrp/yrhsSQdgRiR9ArWsuK03AUImtq
   hHZj5+hceJtU2/LPuzXsYCJhvyvOy1X4aYvTsis6LM5PnyGmMgEHbFsmp
   E+QfdyXOySwfjgWfhIttBWBpo92ugnDQ0DTRNJT2nfnYRtNg1vmH3o9Gy
   ElO5v1R6ANzj7t8fCdBwd08fMoksyb7MY3DzyOa3Kby3qApaJ9FkA50c0
   GlNTO9dlbXfKQ9D7YBacS5lB6NBruJz7egtrLy2BIQ650yM8OyLc0br1u
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="275398671"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="275398671"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 15:34:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="749480801"
Received: from elgartsx-mobl1.amr.corp.intel.com (HELO desk) ([10.209.109.200])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 15:34:52 -0700
Date:   Tue, 16 Aug 2022 15:34:50 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <20220816223450.f2vpu2yobaao6jhg@desk>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <82d09944-9118-e727-705d-da513eca0bf1@citrix.com>
 <YvuVLUXjCBkLf8sJ@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvuVLUXjCBkLf8sJ@zn.tnic>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 03:01:33PM +0200, Borislav Petkov wrote:
> On Tue, Aug 16, 2022 at 12:52:58PM +0000, Andrew Cooper wrote:
> > One minor point.  Stuff 32 slots.
> > 
> > There are Intel parts out in the world with RSBs larger than 32 entries,
> > and this loop does not fill the entire RSB on those.
> > 
> > This is why the 32-entry stuffing loop is explicitly not supported on
> > eIBRS hardware as a general mechanism.
> 
> I'm guessing there will be an Intel patch forthcoming, making that
> RSB_CLEAR_LOOPS more dynamic, based on the current model.

This is being discussed internally, but likely Enhanced IBRS parts don't
need RSB stuffing (except for the single entry stuffing for mitigating
PBRSB).
