Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A8D69F023
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 09:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjBVIZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 03:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjBVIZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 03:25:57 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C844C34F65;
        Wed, 22 Feb 2023 00:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677054355; x=1708590355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=DRwoo1lNoGt487S0GcnC+Sdud16AUBOCSqLzv6WHOqY=;
  b=kSRwSh0RrSI7DnnSwJVa/BgR28bcNzqW1C/9tJpsvTTzCIMTYyhK/73F
   PWj8aBT1cswjs+K2v4XkZ6uuxnHC8POMWjz4YVDGrixxDCUaQsGIjmk+P
   KPX+kZsddnzjYTpHSSi3Z9LXv2mVSK5xs88B6tfYZvRqqsS4lzf+mQEq7
   OiDBLVjwM6VFi9T+vovwEfoQUe8zPipj+dA79E3lWoegfZ1tc8dgLA2Ue
   nKAl/sFI2pXQqSM9szD5cDDpjgt/T+qZ//hUmNYe/enINFGaZSBafWCxK
   xd1sVMxIDRdzXSLi0WTpQUlJxivDqdie3+0vFlSKHbzv3EMoC1nykEgI/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="312490285"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="312490285"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:25:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="781343745"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="781343745"
Received: from jrust-mobl.amr.corp.intel.com (HELO desk) ([10.251.9.236])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:25:54 -0800
Date:   Wed, 22 Feb 2023 00:25:42 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@alien8.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <20230222082542.bjgwgydfdswkqwre@desk>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <20230222030728.v4ldlndtnx6gqd6x@desk>
 <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 09:49:57PM -0800, KP Singh wrote:
> > > @@ -1193,13 +1209,8 @@ spectre_v2_user_select_mitigation(void)
> > >                       "always-on" : "conditional");
> > >       }
> > >
> > > -     /*
> > > -      * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
> > > -      * STIBP is not required.
> > > -      */
> > > -     if (!boot_cpu_has(X86_FEATURE_STIBP) ||
> > > -         !smt_possible ||
> > > -         spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > > +     if (!boot_cpu_has(X86_FEATURE_STIBP) || !smt_possible ||
> > > +         !spectre_v2_user_needs_stibp(spectre_v2_enabled))
> >
> > As pointed out in other discussions, it will be great if can get rid of
> > eIBRS check, and do what the user asked for; or atleast print a warning
> 
> I think I will keep it as pr_info as, with eIBRS, the user does not
> really need STIBP and the mitigation is still effective.

Thats fair.

> > about not setting STIBP bit explicitly.
> 
> That is a bit more complicated as, for now, the user is not really
> exposed to STIBP explicitly yet.

> I would prefer to do it as a follow up and fix this bug first.

On a second thought, STIBP bit being explicitly set or not shouldn't
matter as long as user is getting the STIBP protection that it asked
for.

A print may just help catch some bugs sooner than later.

> It's a bit gnarly and I think we really need to think about the
> options that are exposed to the user [especially in light of Intel /
> AMD subtelties].

With AMD's AutoIBRS support landing in mainline, and both (AutoIBRS and
eIBRS) sharing the same =eibrs mitigation mode, those subtelties becomes
more important.

Following up on Andrew's comment in the other thread, I hope AutoIBRS
does not require setting STIBP explicitly?:

  /sigh so we're still talking about 3 different things then.

  1) Intel's legacy IBRS
  2) AMD's regular IBRS
  3) AMD's AutoIBRS

  which all have different relevant behaviours for userspace.  Just so
  it's written out coherently in at least one place...
  [...]
  For any AMD configuration setting STIBP, there must be an IBPB after
  having set STIBP.   Setting STIBP alone does not evict previously
  created shared predictions.  This one can go subtly wrong for anyone
  who assumes that Intel STIBP and AMD STIBP have the same behaviour.
