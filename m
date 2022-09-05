Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2535ACFFC
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiIEKS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiIEKSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E3C543D0;
        Mon,  5 Sep 2022 03:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40836B80F00;
        Mon,  5 Sep 2022 10:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978BAC433C1;
        Mon,  5 Sep 2022 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662373057;
        bh=nK8Zb48Wne5nhL9HOe0FujHipATbPnEIBFN7VAl1t4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kul+PCyi5BHBk8xB+YyaUgvKsGmkmkcgcqgXRMCWc9WzRQTo4yicNcb/pHC8Nw/V0
         vhFYjF8ekxorruzTAL1iEWNXaYIhJwKwdZBMhgqPDl9Z6MBPaggtmBBrx50AyDANuU
         4Lg/zjoRcPcl7GRvUTqYwD9nTvh5ByOhTG4qvC0UGzuQ5jj7RiLRGnQBJT1tt3iVZZ
         GIxfNI45Ps/I4Wy6vQPpxq9UlKd5v2AlgGxHz2ux7U6EAS7KXOBN+N8eaMLehTERCb
         3hnu0G6on3Ckn0WeCIU+rXD6Py2OMpCAmq72qtqp28+tcntvIa3YNNfKdaNjjoPoif
         d7bsV2deUfpcg==
Date:   Mon, 5 Sep 2022 13:17:32 +0300
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
Message-ID: <YxXMvPLfxdv8QlJo@kernel.org>
References: <20220903060108.1709739-1-jarkko@kernel.org>
 <20220903060108.1709739-2-jarkko@kernel.org>
 <YxMr7hIXsNcWAiN5@kernel.org>
 <a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com>
 <YxXFGLSmRri2T1yb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YxXFGLSmRri2T1yb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 05, 2022 at 12:44:56PM +0300, jarkko@kernel.org wrote:
> On Mon, Sep 05, 2022 at 07:50:33AM +0000, Huang, Kai wrote:
> > On Sat, 2022-09-03 at 13:26 +0300, Jarkko Sakkinen wrote:
> > > >   static int ksgxd(void *p)
> > > >   {
> > > > +	unsigned long left_dirty;
> > > > +
> > > >   	set_freezable();
> > > >   
> > > >   	/*
> > > >   	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> > > >   	 * required for SECS pages, whose child pages blocked EREMOVE.
> > > >   	 */
> > > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > +	pr_debug("%ld unsanitized pages\n", left_dirty);
> > >                   %lu
> > > 
> > 
> > I assume the intention is to print out the unsanitized SECS pages, but what is
> > the value of printing it? To me it doesn't provide any useful information, even
> > for debug.
> 
> How do you measure "useful"?
> 
> If for some reason there were unsanitized pages, I would at least
> want to know where it ended on the first value.
> 
> Plus it does zero harm unless you explicitly turn it on.

I would split it though for a separate patch because it does not need
to be part of the stable fix and change it to:

        if (left_dirty)
                pr_debug("%lu unsanitized pages\n", left_dirty);

BR, Jarkko
