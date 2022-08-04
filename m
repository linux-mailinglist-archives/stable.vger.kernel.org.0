Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50168589B76
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbiHDMJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 08:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiHDMJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 08:09:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC865801
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 05:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B0D8B8250B
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 12:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BB6C433B5;
        Thu,  4 Aug 2022 12:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659614974;
        bh=sOyeATbVCbcESJsZ6oKImUJULq/nKmuJjCAvdgyu8C8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ygtjrTNCNrmBJqdQC/+ivKhJsGrRJ+RlU0UTLCslxkcDoG4tLvHyAD2HeqrgiBpcG
         uPa1b1991hgjj/b+WdMUmnE0U8wJCCK+nwTd251RkvsgNO4yCRUUf5zn753We47xMz
         RJqB2NMHIbHyH8l/Q+FAv3VuYXm9UeMNO1lhBgVM=
Date:   Thu, 4 Aug 2022 14:09:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "chenjun (AM)" <chenjun102@huawei.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "xuqiang (M)" <xuqiang36@huawei.com>
Subject: Re: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Message-ID: <Yuu2+08EZ/ZwggJj@kroah.com>
References: <20220804111539.96424-1-chenjun102@huawei.com>
 <20220804111539.96424-3-chenjun102@huawei.com>
 <YuuyebRA0slDJVwx@kroah.com>
 <26cfcda29c38417e83ecd4e0e35297c3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26cfcda29c38417e83ecd4e0e35297c3@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 12:01:57PM +0000, chenjun (AM) wrote:
> 在 2022/8/4 19:50, Greg KH 写道:
> > On Thu, Aug 04, 2022 at 11:15:38AM +0000, Chen Jun wrote:
> >> From: Helge Deller <deller@gmx.de>
> >>
> >> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
> >>
> >> We need to prevent that users configure a screen size which is smaller than the
> >> currently selected font size. Otherwise rendering chars on the screen will
> >> access memory outside the graphics memory region.
> >>
> >> This patch adds a new function fbcon_modechange_possible() which
> >> implements this check and which later may be extended with other checks
> >> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
> >> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
> >> for a too small screen size.
> >>
> >> Signed-off-by: Helge Deller <deller@gmx.de>
> >> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
> >> [sudip: adjust context]
> > 
> > Who is "sudip" here?
> 
> Em..I misunderstood the meaning "sudip". I just mean I made some 
> contextual adjustments.

Then please use your name here when you resend them.

> > And the Link: line wasn't in the original commit, where did that come
> > from?
> > 
> 
> The mainline commit appears to be from this link. Should I remove the link?

It is odd to see fields that are not in the upstream commit be added
without any explaination (i.e. it's not an obvious signed-off-by
addition), which is why I asked where it came from.

We can add these, but for some reason the upstream maintainer did not
when applying it to their trees, so it's up to you if you want to dig up
the information like this or not, it's not a trivial task at times.

thanks,

greg k-h
