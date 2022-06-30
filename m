Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83783561637
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 11:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbiF3JV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiF3JVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 05:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896674160F;
        Thu, 30 Jun 2022 02:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBD2B8294E;
        Thu, 30 Jun 2022 09:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A31C34115;
        Thu, 30 Jun 2022 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656580893;
        bh=NF3C4ANS+tZF24QCGgcbFP47TxaaB4zajkoerVTQVnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MfE6lqWfHC0D0mvBwBZJeTwCDKRlL5bsCwij0s2cvn17zq3xhEerfnBP7bA2Ndpad
         wTXxGMeUjhImMO6ZX9zMCn8+2NgL2qf6MOve+BABXMdWZ8vKvdsOupbVweJ56ppxEZ
         czXhkouYhxLoyL8KBVUT/T4jsy1Di2QhFQ1zXFqw=
Date:   Thu, 30 Jun 2022 11:21:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     Ronald Warsow <rwarsow@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <Yr1rGxekbuNp1MsU@kroah.com>
References: <f0cdac2a-79f3-af1c-eac9-698b0c8196a3@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0cdac2a-79f3-af1c-eac9-698b0c8196a3@tmb.nu>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 08:18:34PM +0000, Thomas Backlund wrote:
> Den 2022-06-27 kl. 19:38, skrev Ronald Warsow:
> > hallo Greg
> >
> > 5.18.8-rc1
> >
> > compiles (see [1]), boots and runs here on x86_64
> > (Intel i5-11400, Fedora 36)
> >
> > [1]
> > a regression against 5.18.7:
> >
> > ...
> >
> > LD      vmlinux.o
> >    MODPOST vmlinux.symvers
> > WARNING: modpost: vmlinux.o(___ksymtab_gpl+tick_nohz_full_setup+0x0):
> > Section mismatch in reference from the variable
> > __ksymtab_tick_nohz_full_setup to the function
> > .init.text:tick_nohz_full_setup()
> > The symbol tick_nohz_full_setup is exported and annotated __init
> > Fix this by removing the __init annotation of tick_nohz_full_setup or
> > drop the export.
> 
> 
> Should be fixed by:
> 
> 
>  From 2390095113e98fc52fffe35c5206d30d9efe3f78 Mon Sep 17 00:00:00 2001
> From: Masahiro Yamada <masahiroy@kernel.org>
> Date: Mon, 27 Jun 2022 12:22:09 +0900
> Subject: [PATCH] tick/nohz: unexport __init-annotated tick_nohz_full_setup()

Great, now queued up, thanks.

greg k-h
