Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6C0504FA9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiDRMDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiDRMDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF36413D3C
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 782A960EB6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 12:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486C8C385A7;
        Mon, 18 Apr 2022 12:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650283266;
        bh=HLtFXHGQJB55+HOwvAp/TkhKJ4oDaKpvNJUtqfNRSxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyB4fReXknncIj+pxe2TiF839OjC2xXD1RBgoxZq7FXlDJa78QFuHCJIKEhI+1yAU
         GyYW2B9ruZdkOxvJ7hWNJL8RT4dxbH6Rgm/CB+7Gw1CLNZLGUtlJlg71QSEJ3Nj/Hz
         Qf0WLbHw/rp5wQhAWmZGC8lPMPrXhGL28Se+gFwg=
Date:   Mon, 18 Apr 2022 14:01:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     jroedel@suse.de, stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: Re: FAILED: patch "[PATCH] x86/sev: Unroll string mmio with" failed
 to apply to 5.16-stable tree
Message-ID: <Yl1S//YPDMMzyepO@kroah.com>
References: <1649058222102139@kroah.com>
 <Ykx8XWViJCKf3nGQ@zn.tnic>
 <Yk0yBIMXQ5OCf6M1@kroah.com>
 <Yk103F0EzAU2GkEd@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk103F0EzAU2GkEd@zn.tnic>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 01:09:16PM +0200, Borislav Petkov wrote:
> On Wed, Apr 06, 2022 at 08:24:04AM +0200, Greg KH wrote:
> > make[1]: *** [scripts/Makefile.build:287: arch/x86/lib/iomem.o] Error 1
> 
> Bah, building is overrated.
> 
> I guess you need
> 
>   8260b9820f70 ("x86/sev: Use CC_ATTR attribute to generalize string I/O unroll")
> 
> before that.
> 
> > I only have one "FAILED" email template, do I need another one for when
> > the patch applies yet breaks the build?
> 
> I guess you could change that first sentence to
> 
> "The patch below does not apply (or build) to the X.XX-stable tree."
> 
> It seems I took it literally to mean it only doesn't apply.
> 
> :-)

Fair enough :)

So, 5.16 is now dead and end-of-life, but the original commit here still
looks to be needed in older kernels going back quite a ways.  And
8260b9820f70 ("x86/sev: Use CC_ATTR attribute to generalize string I/O
unroll") does not apply cleanly to 5.15 or older and given that it's
touching memory encryption code, I'm not comfortable guessing about the
backport.

So can you, or anyone else that cares, provide a set of backported
patches for this issue that we can apply to the stable trees?

thanks,

greg k-h
