Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85CF6C8552
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 19:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCXSrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 14:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCXSrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 14:47:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A82F1;
        Fri, 24 Mar 2023 11:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=8dtrVZxItauX11UB4f80WXUPADDXCAOcUF0i9BW2H9k=; b=qR47UVnFHk2OHyqfEV+Qna+ckx
        jA3BDaASobqqDwuqyNstDsyKTX0e13ny5NGVfC4LFlxqXnS3C3yzyf52GlzF1A/nS0srl31uqmUnc
        x86PGqWttWtZ0CFzoVXT5oc8DzXJBFocXsiPr5wfiaGUXYyzZPfjtLRQOA/GKldsKkN0Tf8mDhDpB
        JwyRS6NVDRh8t9jjE6cjWsd6sgllbORAvRJkI/E5ejLRAMa5jA/ePzyqqMgV9U1w1QS90LmoyGp3q
        qs8pMu2cTd3pP+jiXnDpnIxJIoo57is2icg9rKJnfveuIDs3jhomTJGg9pMUZn8eDyhSDMyOoyz6b
        W2Pz7mGA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pfmRW-005Lhh-0H;
        Fri, 24 Mar 2023 18:47:14 +0000
Date:   Fri, 24 Mar 2023 11:47:14 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ben Hutchings <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <ZB3wMuynKnQ1IFjb@bombadil.infradead.org>
References: <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
 <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
 <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
 <20230323150125.35e5nwtrez46dv4b@ldmartin-desk2.lan>
 <CAB=NE6VtAn8tew723y77KAN_w-UYE+naMaVrKsLjxpJgAkwDXw@mail.gmail.com>
 <20230324060321.c2szz34n6zggvubj@ldmartin-desk2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230324060321.c2szz34n6zggvubj@ldmartin-desk2.lan>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 11:03:21PM -0700, Lucas De Marchi wrote:
> On Thu, Mar 23, 2023 at 08:08:49AM -0700, Luis Chamberlain wrote:
> > On Thu, Mar 23, 2023 at 8:02 AM Lucas De Marchi
> > <lucas.demarchi@intel.com> wrote:
> > > 
> > > On Wed, Mar 22, 2023 at 03:31:59PM -0700, Luis Chamberlain wrote:
> > > >On Sat, Mar 11, 2023 at 10:25:05PM -0800, Lucas De Marchi wrote:
> > > >> On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
> > > >> > On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
> > > >> > > On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
> > > >> > > > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> > > >> > > > > Yes, the -EINVAL error is strange. It is returned also in
> > > >> > > > > kernel/module/main.c on few locations. But neither of them
> > > >> > > > > looks like a good candidate.
> > > >> > > >
> > > >> > > > OK I updated to next-20230119 and I don't see the issue now.
> > > >> > > > Odd. It could have been an issue with next-20221207 which I was
> > > >> > > > on before.
> > > >> > > >
> > > >> > > > I'll run some more test and if nothing fails I'll send the fix
> > > >> > > > to Linux for rc5.
> > > >> > >
> > > >> > > Jeesh it just occured to me the difference, which I'll have to
> > > >> > > test next, for next-20221207 I had enabled module compression
> > > >> > > on kdevops with zstd.
> > > >> > >
> > > >> > > You can see the issues on kdevops git log with that... and I finally
> > > >> > > disabled it and the kmod test issue is gone. So it could be that
> > > >> > > but I just am ending my day so will check tomorrow if that was it.
> > > >> > > But if someone else beats me then great.
> > > >> > >
> > > >> > > With kdevops it should be a matter of just enabling zstd as I
> > > >> > > just bumped support for next-20230119 and that has module decompression
> > > >> > > disabled.
> > > >> >
> > > >> > So indeed, my suspcions were correct. There is one bug with
> > > >> > compression on debian:
> > > >> >
> > > >> > - gzip compressed modules don't end up in the initramfs
> > > >> >
> > > >> > There is a generic upstream kmod bug:
> > > >> >
> > > >> >  - modprobe --show-depends won't grok compressed modules so initramfs
> > > >> >    tools that use this as Debian likely are not getting module dependencies
> > > >> >    installed in their initramfs
> > > >>
> > > >> are you sure you have the relevant compression setting enabled
> > > >> in kmod?
> > > >>
> > > >> $ kmod --version
> > > >> kmod version 30
> > > >> +ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL
> > > >
> > > >Debian has:
> > > >
> > > >kmod version 30
> > > >+ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL
> > > 
> > >            ^ so... mind the minus :). It doesn't support zlib.
> > > 
> > > Change your kernel config to either compress the modules as xz or zstd.
> > 
> > Oh so then we should complain about these things if an initramfs is
> > detected with modules compressed using a compression algorithm which
> > modprobe installed does not support. What tool would do that?
> 
> I guess we could add that in depmod side as a dummy handler for when
> that config is off. Thoughts?

That sounds like a good solution, better than and complain before
allowing someone to boot and *not* be able to.

  Luis
