Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F6F4BC68C
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 08:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbiBSHTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Feb 2022 02:19:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBSHTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Feb 2022 02:19:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22AC5F25B;
        Fri, 18 Feb 2022 23:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284BEB827D4;
        Sat, 19 Feb 2022 07:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CCAC004E1;
        Sat, 19 Feb 2022 07:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645255151;
        bh=5N9q8YGpLg7pzimVDpcpfsBGpCNjJr17vwBuSaeLOzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3JZA0jkkKEqYPSuaw6XQokUqkc1pHcCOFjSe3Kzf8MHcYJHvrHCzic06q6mfeKNR
         lYNN0vIvNCGoRQ8agRIGhqhtIq8cKGpX5vBVKgmd12VTQNL3YuMjIn2byIcjnmIoaX
         vkI2LkzgzqIRBlITVjf5gJrNpIwkHLga5cTH6DnY=
Date:   Sat, 19 Feb 2022 08:19:02 +0100
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
Message-ID: <YhCZ5m+uw/xqS9W2@kroah.com>
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
 <a5ab4496-8190-6221-72c7-d1ff2e6cf1d4@suse.cz>
 <Yg/eG4X7Esa0h1al@kroah.com>
 <c237f6d1-4219-0e6d-6aca-9c29d060bb4f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c237f6d1-4219-0e6d-6aca-9c29d060bb4f@suse.cz>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 07:54:14PM +0100, Vlastimil Babka wrote:
> On 2/18/22 18:57, Greg Kroah-Hartman wrote:
> > On Fri, Feb 18, 2022 at 06:14:55PM +0100, Vlastimil Babka wrote:
> >> On 2/18/22 14:13, Greg Kroah-Hartman wrote:
> >> > Commit c37495d6254c ("slab: add __alloc_size attributes for better
> >> > bounds checking") added __alloc_size attributes to a bunch of kmalloc
> >> > function prototypes.  Unfortunately the change to __kmalloc_track_caller
> >> > seems to cause clang to generate broken code and the first time this is
> >> > called when booting, the box will crash.
> >> > 
> >> > While the compiler problems are being reworked and attempted to be
> >> > solved, let's just drop the attribute to solve the issue now.  Once it
> >> > is resolved it can be added back.
> >> 
> >> Could we instead wrap it in some #ifdef that' only true for clang build?
> >> That would make the workaround more precise and self-documented. Even
> >> better if it can trigger using clang version range and once a fixed
> >> clang version is here, it can be updated to stay true for older clangs.
> > 
> > It's not doing all that much good like this, let's just remove it for
> > now until it does actually provide a benifit and not just crash the box :)
> > 
> > This is only 1 function, that is used in only a very small number of
> > callers.  I do not think it will be missed.
> 
> Fair enough, added to the slab tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=for-5.17/fixup5
> 

Thanks!
