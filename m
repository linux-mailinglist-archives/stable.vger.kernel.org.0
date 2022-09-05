Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05145ACF21
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 11:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbiIEJpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 05:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbiIEJpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 05:45:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E77419297;
        Mon,  5 Sep 2022 02:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DEE6B80EFB;
        Mon,  5 Sep 2022 09:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1625FC433D6;
        Mon,  5 Sep 2022 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662371101;
        bh=i0rFTdHCToZvGYvSAvRY0uVoU8v7DoO7QCR8Y+ziI90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pek7dDXWeAkuLnPA2QCRlP2DC42aw4s+H532CCOVp1NejSGoExuP/j/0gcBNEmBLY
         FUuTt01lpnKa+R+E1GZ9NbCaOwlWZMbW6wrCvw4qldwFzGoP6YQpMXpVd9PiuL7Pcc
         ZH6RQ8moZbGq5BN0QxUP8qbzJNxHUb9E+fMEyGEyJaLlCropRAn3ap9PNJgLn3HZgp
         d4LEk2AklZfUZ15KIJdNwwVZxoAfbGQ0lQErgY9jtJPkRfsJjOTSD3A28luH55+cms
         9Ag7+V9VcF9CaNcLtstZnJ0celZyCAdBiuIy7wqZD6MsWwmJ4UAZpgQv2YoSmlH43g
         oDkjdwMLzehlw==
Date:   Mon, 5 Sep 2022 12:44:56 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Message-ID: <YxXFGLSmRri2T1yb@kernel.org>
References: <20220903060108.1709739-1-jarkko@kernel.org>
 <20220903060108.1709739-2-jarkko@kernel.org>
 <YxMr7hIXsNcWAiN5@kernel.org>
 <a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 05, 2022 at 07:50:33AM +0000, Huang, Kai wrote:
> On Sat, 2022-09-03 at 13:26 +0300, Jarkko Sakkinen wrote:
> > >   static int ksgxd(void *p)
> > >   {
> > > +	unsigned long left_dirty;
> > > +
> > >   	set_freezable();
> > >   
> > >   	/*
> > >   	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> > >   	 * required for SECS pages, whose child pages blocked EREMOVE.
> > >   	 */
> > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	pr_debug("%ld unsanitized pages\n", left_dirty);
> >                   %lu
> > 
> 
> I assume the intention is to print out the unsanitized SECS pages, but what is
> the value of printing it? To me it doesn't provide any useful information, even
> for debug.

How do you measure "useful"?

If for some reason there were unsanitized pages, I would at least
want to know where it ended on the first value.

Plus it does zero harm unless you explicitly turn it on.

> Besides, the first call of __sgx_sanitize_pages() can return 0, due to either
> kthread_should_stop() being true, or all EPC pages are EREMOVED successfully. 
> So in this case kernel will print out "0 unsanitized pages\n", which doesn't
> make a lot sense?
> 
> > >   
> > > -	/* sanity check: */
> > > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > > +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	/*
> > > +	 * Never expected to happen in a working driver. If it happens the
> > > bug
> > > +	 * is expected to be in the sanitization process, but successfully
> > > +	 * sanitized pages are still valid and driver can be used and most
> > > +	 * importantly debugged without issues. To put short, the global
> > > state
> > > +	 * of kernel is not corrupted so no reason to do any more
> > > complicated
> > > +	 * rollback.
> > > +	 */
> > > +	if (left_dirty)
> > > +		pr_err("%ld unsanitized pages\n", left_dirty);
> >                         %lu
> 
> No strong opinion, but IMHO we can still just WARN() when it is driver bug:
> 
> 1) There's no guarantee the driver can continue to work if it has bug;
> 
> 2) WARN() can panic() the kernel if /proc/sys/kernel/panic_on_warn is set is
> fine.  It's expected behaviour.  If I understand correctly, there are many
> places in the kernel that uses WARN() to catch bugs.
> 
> In fact, we can even view WARN() as an advantage. For instance, if we only print
> out "xx unsanitized pages" in the existing code, people may even wouldn't have
> noticed this bug.
> 
> From this perspective, if you want to print out, I think you may want to make
> the message more visible, that people can know it's driver bug.  Perhaps
> something like "The driver has bug, please report to kernel community..", etc.
> 
> 3) Changing WARN() to pr_err() conceptually isn't mandatory to fix this
> particular bug.  So, it's kinda mixing things together.
> 
> But again, no strong opinion here.
> 
> -- 
> Thanks,
> -Kai
> 
> 

BR, Jarkko
