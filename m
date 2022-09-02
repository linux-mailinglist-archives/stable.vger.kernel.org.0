Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D35AB693
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiIBQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbiIBQar (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95681B08;
        Fri,  2 Sep 2022 09:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9CA161FDB;
        Fri,  2 Sep 2022 16:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BEDC433D6;
        Fri,  2 Sep 2022 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662136244;
        bh=vaFIt9s7R9wmoXAB3mjbwHD7d91DB1pCKI+aBwozC/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FIKOurTjPrRbe9uA/FohpSguBK3mHQ/nWZ1Zs9BOU8NVA+KT3uQzMcyMU7b49baa7
         BEz16v1g5ldifxhP1o+Na5AcY+2ymARlX6Gc1lfdZjfEIzsjxfWAiDUg7mlMIyM4rm
         YpVh+Aq1NMnJVgvcpUNaD/CIwCVh+XJ3MaH7ORomtOzwJFAzbl/UoASWAad6R9higc
         9iQQXKxkFLgSkShteTgDrq/ncpOUuj2QqyaaOB2q2oQomrVbYT7N4/d35mzNYmv5Tf
         dEX6VZn5hQGJm2+UuBDHBLnQgm8AYE9ryVvOi2EkPM7l/OfV4/aCqYwovdBB9J2x5T
         qnvr5nxQBN66w==
Date:   Fri, 2 Sep 2022 19:30:39 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxIvr33xgjCbW6qu@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org>
 <YxIEm4uHVvUY/rv6@kernel.org>
 <YxInD1m7rEnQ/yxW@kernel.org>
 <b418161b-2613-4bb9-9269-b4995de65794@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b418161b-2613-4bb9-9269-b4995de65794@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 09:08:23AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 9/2/2022 8:53 AM, Jarkko Sakkinen wrote:
> > On Fri, Sep 02, 2022 at 04:26:51PM +0300, Jarkko Sakkinen wrote:
> >> +	if (ret)
> >> +		pr_err("%ld unsanitized pages\n", left_dirty);
> > 
> > Yeah, I know, should be 'left_dirty'. I just quickly drafted
> > the patch for the email.
> > 
> 
> No problem - you did mention that it was an informal patch.
> 
> (btw ... also watch out for the long local parameter returned
> as an unsigned long and the signed vs unsigned printing
> format string.) I also continue to recommend that you trim

Point taken.

> that backtrace ... this patch is heading to x86 area where
> this is required.

Should I just cut the whole stack trace, and leave the
part before it?

BR, Jarkko
