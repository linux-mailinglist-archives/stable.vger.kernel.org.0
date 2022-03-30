Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8001E4EC846
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348221AbiC3Pa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348222AbiC3Paz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:30:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C61FF41F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4EFF616F7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BC6C340EE;
        Wed, 30 Mar 2022 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648654149;
        bh=nqh9m6JYid9s0zKv5g3yBhAzLsRYdwgriF9LJ6+N9qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pTqOXARb0ftm2C3IKMpSpoJ1fq06xRDB5G9pTRqXUoKe+X0ItxfSkgNeCqcN9Eo2d
         kxFCtIuMyv0+BVgVm2F25NCv/ZnJ5hwbOXim+vnsKeXQ9mxLvP6xdONwP5zi0RqF+e
         mWGOu3c6krYkygkDYcnK31OGtqe78QykLTQYXG50=
Date:   Wed, 30 Mar 2022 17:29:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Message-ID: <YkR3Qdao7cSf7sjV@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkRtWs7ieUA/7Xg9@kroah.com>
 <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 07:59:57AM -0700, Tadeusz Struk wrote:
> On 3/30/22 07:46, Greg KH wrote:
> > On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
> > > Please apply this to stable 5.10.y, and 5.15.y
> > > ---8<---
> > > 
> > > From: Kees Cook<keescook@chromium.org>
> > > 
> > > Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
> > > 
> > > Under both -Warray-bounds and the object_size sanitizer, the compiler is
> > > upset about accessing prev/next of sk_buff when the object it thinks it
> > > is coming from is sk_buff_head. The warning is a false positive due to
> > > the compiler taking a conservative approach, opting to warn at casting
> > > time rather than access time.
> > > 
> > > However, in support of enabling -Warray-bounds globally (which has
> > > found many real bugs), arrange things for sk_buff so that the compiler
> > > can unambiguously see that there is no intention to access anything
> > > except prev/next.  Introduce and cast to a separate struct sk_buff_list,
> > > which contains_only_  the first two fields, silencing the warnings:
> > We don't have -Warray-bounds enabled on any stable kernel tree, so why
> > is this needed?
> > 
> > Where is this showing up as a problem?
> 
> The issue shows up and hinders testing stable kernels in test automations
> like syzkaller:
> 
> https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000
> 
> Applying it to stable would enable more test coverage.

Ok, again, that was not obvious, it seemed like you only needed this for
build warnings.

thanks,

greg k-h
