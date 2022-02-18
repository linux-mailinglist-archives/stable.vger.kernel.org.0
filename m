Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789BB4BBED8
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 18:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiBRR6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 12:58:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiBRR6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 12:58:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9931103E;
        Fri, 18 Feb 2022 09:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D6D2B826A7;
        Fri, 18 Feb 2022 17:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75124C340E9;
        Fri, 18 Feb 2022 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645207070;
        bh=dP5b+VA+uAx3bJhnVmVq20KQ+X+9Cy6qAmDwVZSVETA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvDPAbFjC/4BDN5N4QWsBAXqH2By2fN9OfvYaiEa2EMGl4mymWW8xR+qlQyNEIuA8
         TPqKYelwYUzcA6s0HPFMHH/nhichKTgj+hHrBc37kVQaDoNGGuLZTVgIDxzZ9up4Nv
         3l394mt2DHKY8m9e4DnwbzD5MGioZ5eock/RE5GY=
Date:   Fri, 18 Feb 2022 18:57:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] slab: remove __alloc_size attribute from
 __kmalloc_track_caller
Message-ID: <Yg/eG4X7Esa0h1al@kroah.com>
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
 <a5ab4496-8190-6221-72c7-d1ff2e6cf1d4@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5ab4496-8190-6221-72c7-d1ff2e6cf1d4@suse.cz>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 06:14:55PM +0100, Vlastimil Babka wrote:
> On 2/18/22 14:13, Greg Kroah-Hartman wrote:
> > Commit c37495d6254c ("slab: add __alloc_size attributes for better
> > bounds checking") added __alloc_size attributes to a bunch of kmalloc
> > function prototypes.  Unfortunately the change to __kmalloc_track_caller
> > seems to cause clang to generate broken code and the first time this is
> > called when booting, the box will crash.
> > 
> > While the compiler problems are being reworked and attempted to be
> > solved, let's just drop the attribute to solve the issue now.  Once it
> > is resolved it can be added back.
> 
> Could we instead wrap it in some #ifdef that' only true for clang build?
> That would make the workaround more precise and self-documented. Even
> better if it can trigger using clang version range and once a fixed
> clang version is here, it can be updated to stay true for older clangs.

It's not doing all that much good like this, let's just remove it for
now until it does actually provide a benifit and not just crash the box :)

This is only 1 function, that is used in only a very small number of
callers.  I do not think it will be missed.

thanks,

greg k-h
