Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43644EC6FC
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiC3Osj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347019AbiC3Osi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A854026E767
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5162360F1F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7F2C340EC;
        Wed, 30 Mar 2022 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648651612;
        bh=+JjDm3y6PpUr8Ouq7ENBrtFIyOjOcZAiqwb0C6+aWvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyHHCZgzzZaKLjFcvRH0S4Qp1aw+wV26ZxjSRgKIz+jTV4N/XgBe7TqS9CaCOqPuS
         Rl9zxh7/MHpcalFaavDK+8F1G6OXx8hpip/FDLFYd7lKC40aLAoYPoIAuxHjHNLoud
         XpxpXJVsUic8iaPCOR4G3471Kf8W87i4UqNtBjNo=
Date:   Wed, 30 Mar 2022 16:46:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Message-ID: <YkRtWs7ieUA/7Xg9@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329220256.72283-2-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
> Please apply this to stable 5.10.y, and 5.15.y
> ---8<---
> 
> From: Kees Cook <keescook@chromium.org>
> 
> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
> 
> Under both -Warray-bounds and the object_size sanitizer, the compiler is
> upset about accessing prev/next of sk_buff when the object it thinks it
> is coming from is sk_buff_head. The warning is a false positive due to
> the compiler taking a conservative approach, opting to warn at casting
> time rather than access time.
> 
> However, in support of enabling -Warray-bounds globally (which has
> found many real bugs), arrange things for sk_buff so that the compiler
> can unambiguously see that there is no intention to access anything
> except prev/next.  Introduce and cast to a separate struct sk_buff_list,
> which contains _only_ the first two fields, silencing the warnings:

We don't have -Warray-bounds enabled on any stable kernel tree, so why
is this needed?

Where is this showing up as a problem?

thanks,

greg k-h
