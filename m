Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE61B56954D
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 00:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiGFW2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 18:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiGFW2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 18:28:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE902B1B5;
        Wed,  6 Jul 2022 15:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657146480; x=1688682480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vleb0k6acAvZjo7qEApfQ8FJmwV6hNoP1hTpCH2VGUk=;
  b=P4tcQC/SuS6YykZByJzTQh9PdHsYugrIYk0xPzs56gdJqYqhNPZHIxXE
   RZoglXc5mwwZqTciTiOs1yFlLfjS2xLbwZ8TxC5lPaqC0qa06iXUq2Nfp
   NJcGxK9WT0eXlrRxJmZOfNK0SB4Aq7WhfRwCwYrM1j4puxa5UWE5hexEp
   d17aXVeJ/Na4SHpKEgiOF97ml2yVVfTl5JMOTPVEhtlWZERVpmLqaebq+
   mNbCe7+PoWHhsIICGX/erIi0ghpam7xkcojee4stK95NUXD8QXTzGj7HM
   +LhWnVOR3+VQKyMstaK0DqsX9LjfDwOrOqmWKTaElL0Z3YDcf45kp/SEe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="347866390"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="347866390"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 15:27:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="696286196"
Received: from ffsotto-mobl.amr.corp.intel.com (HELO [10.209.100.19]) ([10.209.100.19])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 15:27:58 -0700
Message-ID: <842b718f-8207-1565-3373-61098a4c2d33@intel.com>
Date:   Wed, 6 Jul 2022 15:25:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] x86/Kconfig: Fix CONFIG_CC_HAS_SANE_STACKPROTECTOR when
 cross compiling with clang
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kolesa <daniel@octaforge.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        llvm@lists.linux.dev, stable@vger.kernel.org
References: <20220617180845.2788442-1-nathan@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220617180845.2788442-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/17/22 11:08, Nathan Chancellor wrote:
> When clang is invoked without a '--target' flag, code is generated for
> the default target, which is usually the host (it is configurable via
> cmake). As a result, the has-stack-protector scripts will generate code
> for the default target but check for x86 specific segment registers,
> which cannot succeed if the default target is not x86.

I guess the real root cause here is the direct use of '$(CC)' without
any other flags.  Adding '$(CLANG_FLAGS)' seems like a pretty normal
fix, like in scripts/Kconfig.include.

I suspect there's another one of these here:

	arch/x86/um/vdso/Makefile:      cmd_vdso = $(CC) -nostdlib -o $@

but I wouldn't be surprised if UML doesn't work with clang in the first
place.
