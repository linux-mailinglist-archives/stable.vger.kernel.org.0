Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D684E49AC
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiCVXeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 19:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbiCVXea (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 19:34:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA334D95;
        Tue, 22 Mar 2022 16:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647991980; x=1679527980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XwlEgxZx+biSuXUGcY7iQ2dLxTEwH6VqQm6lQR1IWEM=;
  b=BxdOQ5bUi5RZrD05EdU/xwQjnJhwSkHFo8CZ1v9Y23zc+clMuWFzGw4d
   fjQ8vAjGYNvy/Qk/0SgQypQnf2W3Ms9Nija0kPyYTiBGxiZ6Xzi6DGXnU
   uVlBpeotNJs+HsSrDCUslgqDJt1tyHjLHr5QetHWl+jsevU+4TRjUQB8p
   rfyj70WkIohxwX96zotOSLKSNhOAeHql9s7TteAW9WpW3Krh5yM0PagwA
   4FdhaNaNUFVyRi+tLlk5AXfbavNFUZTUSOt4nmYxMsMQvWywEQKP7blh5
   1UfFQE7t5lduzkpfTYT2Z8RixXW60P0GKrIQgeCM1bIuSWdEESVUf8Cfy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="344411960"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="344411960"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 16:33:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="692749730"
Received: from rtgarci1-mobl2.amr.corp.intel.com (HELO guptapa-desk) ([10.212.228.140])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 16:32:58 -0700
Date:   Tue, 22 Mar 2022 16:32:42 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 0/2] TSX update
Message-ID: <20220322233242.mlslvnucjb5sjyk2@guptapa-desk>
References: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Boris and others,

On Thu, Mar 10, 2022 at 01:59:47PM -0800, Pawan Gupta wrote:
>v2:
>- Added patch to disable TSX development mode (Andrew, Boris)
>- Rebased to v5.17-rc7
>
>v1: https://lore.kernel.org/lkml/5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com/
>
>Hi,
>
>After a recent microcode update some Intel processors will always abort
>Transactional Synchronization Extensions (TSX) transactions [*]. On
>these processors a new CPUID bit,
>CPUID.07H.0H.EDX[11](RTM_ALWAYS_ABORT), will be enumerated to indicate
>that the loaded microcode is forcing Restricted Transactional Memory
>(RTM) abort. If the processor enumerated support for RTM previously, the
>CPUID enumeration bits for TSX (CPUID.RTM and CPUID.HLE) continue to be
>set by default after the microcode update.
>
>First patch in this series clears CPUID.RTM and CPUID.HLE so that
>userspace doesn't enumerate TSX feature.
>
>Microcode also added support to re-enable TSX for development purpose,
>doing so is not recommended for production deployments, because MD_CLEAR
>flows for the mitigation of TSX Asynchronous Abort (TAA) may not be
>effective on these processors when TSX is enabled with updated
>microcode.
>
>Second patch unconditionally disables this TSX development mode, in case
>it was enabled by the software running before kernel boot.
>
>Thanks,
>Pawan
>
>[*] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
>    https://cdrdv2.intel.com/v1/dl/getContent/643557
>
>Pawan Gupta (2):
>  x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
>  x86/tsx: Disable TSX development mode at boot

I am hoping to get some feedback on v2. Are these patches looking okay?

Thanks,
Pawan
