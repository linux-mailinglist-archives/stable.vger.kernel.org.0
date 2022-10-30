Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0DA612AF2
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 15:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJ3OUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 10:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3OUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 10:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065B9B4BB
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 07:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7FC60EE0
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 14:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CDEC433C1;
        Sun, 30 Oct 2022 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667139599;
        bh=Kw695yxXuAnFD23r57QmUtv9Hbzg3kMlkq1QlQVvbdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LWczTDkNed8KeY+Mjc1w+w8UF2RyfOHhpGPLM/8yY64TkbCFwEUgGpCRd+gRO67Yq
         jkjafUnigmoevzh+0/oY6zJDzy7xFVFZDI8sX/lOMmyH9oh/hWTuRcovX1AtXa22Te
         8wSVlApDA5AJMQ9TjYIdk/03taxGbQno1+vYbYDU=
Date:   Sun, 30 Oct 2022 15:20:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jaak Ristioja <jaak@ristioja.ee>
Cc:     stable@vger.kernel.org
Subject: Re: drivers/platform/x86/amd/pmc.c compile error in 6.0.6
Message-ID: <Y16IRs2ogZBxGMS3@kroah.com>
References: <d166779c-a845-2483-41c6-4cd7e06c22c3@ristioja.ee>
 <Y14mgmo+ZEKTR4/v@kroah.com>
 <ddeed421-cf75-4a44-4f5d-f26cd0359b78@ristioja.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddeed421-cf75-4a44-4f5d-f26cd0359b78@ristioja.ee>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 30, 2022 at 03:44:55PM +0200, Jaak Ristioja wrote:
> On 30.10.22 09:23, Greg Kroah-Hartman wrote:
> > On Sun, Oct 30, 2022 at 01:51:59AM +0300, Jaak Ristioja wrote:
> > > Hello,
> > > 
> > > The following error popped up when compiling Linux kernel version 6.0.6:
> > > 
> > > drivers/platform/x86/amd/pmc.c: In function 'amd_pmc_verify_czn_rtc':
> > > drivers/platform/x86/amd/pmc.c:640:22: error: implicit declaration of
> > > function 'amd_pmc_get_smu_version' [-Werror=implicit-function-declaration]
> > >    640 |                 rc = amd_pmc_get_smu_version(pdev);
> > >        |                      ^~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > This function call was introduced backported with commit e9847175b266 with
> > > the subject line "platform/x86/amd: pmc: Read SMU version during suspend on
> > > Cezanne systems".
> > > 
> > > Please note that amd_pmc_get_smu_version() is defined in an #ifdef
> > > CONFIG_DEBUG_FS block, but the new function call is compiled regardless of
> > > CONFIG_DEBUG_FS, causing the aforementioned error when building without the
> > > Debug Filesystem.
> > 
> > Ah, good catch.  Is this issue also there in Linus's tree?  If not, any
> > hint on what commit fixed it?
> 
> It looks like applying commit b37fe34c8309 titled "platform/x86/amd: pmc:
> remove CONFIG_DEBUG_FS checks" fixes the compile error. Hope it helps :)

Thanks a lot, that does help.  Patch is now queued up.

greg k-h
