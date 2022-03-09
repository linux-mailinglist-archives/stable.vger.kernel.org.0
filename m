Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0454D3D1E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiCIWkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbiCIWkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A99120E8A;
        Wed,  9 Mar 2022 14:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FED8B8240D;
        Wed,  9 Mar 2022 22:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC1DC340FE;
        Wed,  9 Mar 2022 22:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646865568;
        bh=Oh8z49LjClTm6CvNAujzIHB+LG8tWJ/pO3EpDfQGzCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K6CsKXpqvCqsre/UPVbmOXm1mciOJ48tYcvg2xI/g84yndsefvxzUB7AcQRpWboiJ
         LLtQRQyKBNBze25pG3pkETsx9Fse0bBWWG1A1bYAWX58lEyu5+tcDRsaWJrJFc0cjA
         PupScCXxBwLNvJazQpxQJYdckD6x4KPrgJRdPInE=
Date:   Wed, 9 Mar 2022 23:39:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        srinivas.eeda@oracle.com
Subject: Re: [PATCH 4.9 02/24] x86/retpoline: Make CONFIG_RETPOLINE depend on
 compiler support
Message-ID: <Yiksm1FV2bbidIT3@kroah.com>
References: <20220309155856.295480966@linuxfoundation.org>
 <20220309155856.369868546@linuxfoundation.org>
 <ab991a7ac7215fa18ba83698df2450c1c2ded334.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab991a7ac7215fa18ba83698df2450c1c2ded334.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 08:58:06PM +0100, Ben Hutchings wrote:
> On Wed, 2022-03-09 at 16:59 +0100, Greg Kroah-Hartman wrote:
> > From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > 
> > commit 4cd24de3a0980bf3100c9dcb08ef65ca7c31af48 upstream.
> [...]
> 
> Sorry, there are a couple of fixes needed on top of this:
> 
> commit 25896d073d8a0403b07e6dec56f58e6c33678207
> Author: Masahiro Yamada <yamada.masahiro@socionext.com>
> Date:   Wed Dec 5 15:27:19 2018 +0900
>  
>     x86/build: Fix compiler support check for CONFIG_RETPOLINE
> 
> commit e4f358916d528d479c3c12bd2fd03f2d5a576380
> Author: WANG Chao <chao.wang@ucloud.cn>
> Date:   Tue Dec 11 00:37:25 2018 +0800
>  
>     x86, modpost: Replace last remnants of RETPOLINE with CONFIG_RETPOLINE
> 
> I've attached my backports of those.

Thanks, both now queued up.

greg k-h
