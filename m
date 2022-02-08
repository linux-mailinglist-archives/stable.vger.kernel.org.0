Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72694ADF22
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiBHRR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiBHRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:17:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33C9C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 09:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0870B81C6D
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 17:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE369C004E1;
        Tue,  8 Feb 2022 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644340645;
        bh=tOo9judSzzhFgtdtJTy0xrIA1N6abnNq3/n+Ncv1//A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AeB8ADJoYpCWnix3UqEdCvHr+ssfA0MuYx1r51SBUBT0gSjoPIgnYWQMVbsqDpImO
         dqRVY3hGLfdNd5zLSoRkEQhPRd4f/UKAW1jcRJgcJWu+fUjhV1WfP20ztvYooUiJOr
         /NwKPerynaqOZfIltUi2TJ0gjvCZ6ejNgtzJiYs4=
Date:   Tue, 8 Feb 2022 18:17:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH for-5.4,5.10] kbuild: simplify access to the kernel's
 version
Message-ID: <YgKlosDt91Hf3+iJ@kroah.com>
References: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
 <e781d772-71a8-f073-66cf-0b415399413e@flygoat.com>
 <YgKK7xskaM6NroIM@kroah.com>
 <516b790f-8f67-0523-a95b-9d359036bd59@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <516b790f-8f67-0523-a95b-9d359036bd59@flygoat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 03:47:13PM +0000, Jiaxun Yang wrote:
> 
> 
> 在 2022/2/8 15:23, Greg KH 写道:
> > On Tue, Feb 08, 2022 at 02:46:36PM +0000, Jiaxun Yang wrote:
> > > Oh Please ignore this series of backport.
> > For all branches?
> Yep.
> > 
> > > We find another way to workaround the issue.
> > What is your solution?  I am sure that others would be interested in it.
> Oh we just define them in Makefile with cflags
> like:
> 
> 
> --- a/Makefile.kernel
> +++ b/Makefile.kernel
> @@ -60,3 +60,5 @@ obj-$(CPTCFG_WLAN) += drivers/net/wireless/
>  #obj-$(CPTCFG_USB_USBNET) += drivers/net/usb/
>  #
>  #obj-$(CPTCFG_STAGING) += drivers/staging/
> +
> +subdir-ccflags-y += -DCOMPAT_KERNEL_SUBLEVEL=$(SUBLEVEL)

Ah, that works, nice!

greg k-h
