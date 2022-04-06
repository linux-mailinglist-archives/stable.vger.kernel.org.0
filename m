Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9544F5B86
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiDFJw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbiDFJuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0305348FF39
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 23:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63BA261ADE
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 06:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704AFC385A1;
        Wed,  6 Apr 2022 06:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649226246;
        bh=N5CHtLCuivIMT/hgHQCwGB8rDUTfQhVnmV/rtvcjC3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0ECqfXf81TNj5MwdyJNdndErtohhnSr8hb+IPkxqK7rizbR/3ixJLfZCSEpciMuI
         xLlnTfoDomak3O7C4lwgRBn48Y2t9digammGvIdF8hcig/dQWgrZOkV4yHROg9WmHA
         ogKfUGp0/yQGldqyReY+YyUkXJrI03moDQjwILOk=
Date:   Wed, 6 Apr 2022 08:24:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     jroedel@suse.de, stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: Re: FAILED: patch "[PATCH] x86/sev: Unroll string mmio with" failed
 to apply to 5.16-stable tree
Message-ID: <Yk0yBIMXQ5OCf6M1@kroah.com>
References: <1649058222102139@kroah.com>
 <Ykx8XWViJCKf3nGQ@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ykx8XWViJCKf3nGQ@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 07:29:01PM +0200, Borislav Petkov wrote:
> On Mon, Apr 04, 2022 at 09:43:42AM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.16-stable tree.
> 
> Really?
> 
> $ git checkout -b 5.16.y stable/linux-5.16.y
> Updating files: 100% (19623/19623), done.
> branch '5.16.y' set up to track 'stable/linux-5.16.y'.
> $ git cherry-pick 4009a4ac82dd95b8cd2b62bd30019476983f0aff
> [5.16.y 045eac1dbd58] x86/sev: Unroll string mmio with CC_ATTR_GUEST_UNROLL_STRING_IO
>  Author: Joerg Roedel <jroedel@suse.de>
>  Date: Mon Mar 21 10:33:51 2022 +0100
>  1 file changed, 57 insertions(+), 8 deletions(-)
> $ git status
> On branch 5.16.y
> Your branch is ahead of 'stable/linux-5.16.y' by 1 commit.
>   (use "git push" to publish your local commits)
> 
> It works here...

And then when you build the tree:

arch/x86/lib/iomem.c: In function ‘memcpy_fromio’:
arch/x86/lib/iomem.c:90:29: error: ‘CC_ATTR_GUEST_UNROLL_STRING_IO’ undeclared (first use in this function)
   90 |         if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO))
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/lib/iomem.c:90:29: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/lib/iomem.c: In function ‘memcpy_toio’:
arch/x86/lib/iomem.c:99:29: error: ‘CC_ATTR_GUEST_UNROLL_STRING_IO’ undeclared (first use in this function)
   99 |         if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO))
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/lib/iomem.c: In function ‘memset_io’:
arch/x86/lib/iomem.c:108:29: error: ‘CC_ATTR_GUEST_UNROLL_STRING_IO’ undeclared (first use in this function)
  108 |         if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO)) {
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [scripts/Makefile.build:287: arch/x86/lib/iomem.o] Error 1

I only have one "FAILED" email template, do I need another one for when
the patch applies yet breaks the build?

thanks,

greg k-h
