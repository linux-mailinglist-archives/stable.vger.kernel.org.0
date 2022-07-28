Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4C9583645
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiG1B3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 21:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiG1B3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 21:29:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE82C130;
        Wed, 27 Jul 2022 18:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658971778; x=1690507778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gfZjXhuL7wy9enNtGpyeN71qPUo5MXMw3mdjlYho4Hs=;
  b=ITBPzNvPi9S1nkn1+9QYSPas+GCLHLSETKmUKgmmgRzaUIwtM0g1jmQt
   PQkqD4KVKW3Bd1EWJIvweQwtshlD3p1h3X0oaKpvluhnHnmJ5hz/hYzY7
   KXagbbcSNijujyVroZiVuQ0vKuKryLOyM3MbqAmci85Na8aKCq7kRKRi9
   /OUdiojjc6w4WGjlSWng2rABgKIgDG/GOPSxsTlsPUMrYmskkQAa8szz1
   sevCuNUuCnSH7T7cfEKQyULUmyDvft4JOOcX8u8KkTbMv5jZ9ghTL8PaC
   o85/x71qYaz7Y1DazLDNeKjxEEhGc00Erm+BJOBQ8GAlpQ7Y8zFRIwZgG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="271430893"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="271430893"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 18:29:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="846479851"
Received: from tantonsx-mobl.amr.corp.intel.com (HELO desk) ([10.209.23.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 18:29:35 -0700
Date:   Wed, 27 Jul 2022 18:29:33 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tony.luck@intel.com,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <20220728012933.qkyfe35awu232vp4@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 06:30:19PM -0700, Pawan Gupta wrote:
> Older CPUs beyond its Servicing period are not listed in the affected
> processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> report "Not affected" in sysfs, which may not be correct.
> 
> Add support for "Unknown" reporting for such CPUs. Mitigation is not
> deployed when the status is "Unknown".
> 
> "CPU is beyond its Servicing period" means these CPUs are beyond their
> Servicing [1] period and have reached End of Servicing Updates (ESU) [2].
> 
>   [1] Servicing: The process of providing functional and security
>   updates to Intel processors or platforms, utilizing the Intel Platform
>   Update (IPU) process or other similar mechanisms.
> 
>   [2] End of Servicing Updates (ESU): ESU is the date at which Intel
>   will no longer provide Servicing, such as through IPU or other similar
>   update processes. ESU dates will typically be aligned to end of
>   quarter.
> 
> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>

Ping! Is there any interest in fixing reporting for older processors?
