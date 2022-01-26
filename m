Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8A949CAE0
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiAZNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiAZNcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:32:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AD9C061747;
        Wed, 26 Jan 2022 05:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48BADCE1BBD;
        Wed, 26 Jan 2022 13:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B8C340E3;
        Wed, 26 Jan 2022 13:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643203940;
        bh=YMtDtX9/VJvj3G4cAPl7V1NbZUcQIKinYDUPxL8qhjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EepSUECiaPziM4IaRkBsHKXQ/DMwfHWyrD3dGkznRH4Qf/5rxlXkKI9xhpqJfDdSr
         3tWinwnzRD9mdpjj6F5PPn/eZSw6Fa3jHwvScPnz7/9bSdf67FLKwe8huxL8ZyHGQ7
         UKze5yhTuhB6QDBXBEy1wbelTrUTqpelzb75HNxuC5O+csX3GdQAlha88R/zayHX4C
         Lti+7XyHBhS/XS06wWrZanB/v52Xv0yxp+DwmRcgS9xf2Af7C4I0iztzO+BhLpapCN
         XNrAYdpwvD1LB/IRS5QrXOVbTaSg8TQnLfhJbZmFP32/2ynejaVXfbg14Qu/2zij5c
         R+3cUJ7tlQnJg==
Date:   Wed, 26 Jan 2022 15:31:59 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YfFNT4P27vdxNo7G@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
 <b01342c0-97c8-a29e-d172-d53d051b683c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b01342c0-97c8-a29e-d172-d53d051b683c@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 09:17:32AM -0800, Dave Hansen wrote:
> On 1/12/22 22:08, Reinette Chatre wrote:
> > ------------[ cut here ]------------
> > ELDU returned 9 (0x9)
> > WARNING: CPU: 6 PID: 2470 at arch/x86/kernel/cpu/sgx/encl.c:77 sgx_encl_eldu+0x37c/0x3f0
> 
> Could we flesh out that error message, please?
> 
> That "return" is a code from "Information and Error Codes" in the SGX SDM
> chapter.  It's also spelled out in 'enum sgx_return_code'.  So, at least,
> this should probably say:
> 
> 	ELDU sgx_return_code: 9 (0x9)
> 
> *That* is at least greppable.

Yes, I'm all for adding sgx_ prefix to everything but should it rather
be "sgx: ELDU ..." like most of everything else?

/Jarkko
