Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB26EC655
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 08:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDXGeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 02:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjDXGeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 02:34:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33752688;
        Sun, 23 Apr 2023 23:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 354816143F;
        Mon, 24 Apr 2023 06:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD6BC433D2;
        Mon, 24 Apr 2023 06:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682318042;
        bh=F6cq3i7+fK8WgYpmoueBDEwENUOp4V9e+2lWszeFgao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u1QlRsyOiwyGff18b8vQH/6KqdKAKdvobMrFiExaPdlLxbCpbbJl0l7OVQdz9HKVv
         tIG2XSBvYKzsSWOKf0go3Y6+ropK9+P6QVfEBaaBConN/JCMlwrJkEb+wVuQiO7wDI
         Xwlcl25nQt7DAbbIrw/1mtfWFtNFkuNaiPj9ebRI=
Date:   Mon, 24 Apr 2023 08:34:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 v4 3/5] counter: 104-quad-8: Fix race condition
 between FLAG and CNTR reads
Message-ID: <2023042423-catching-pronto-dbe6@gregkh>
References: <20230423232047.12589-1-william.gray@linaro.org>
 <20230423232047.12589-3-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423232047.12589-3-william.gray@linaro.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 23, 2023 at 07:20:45PM -0400, William Breathitt Gray wrote:
> commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.
> 
> The Counter (CNTR) register is 24 bits wide, but we can have an
> effective 25-bit count value by setting bit 24 to the XOR of the Borrow
> flag and Carry flag. The flags can be read from the FLAG register, but a
> race condition exists: the Borrow flag and Carry flag are instantaneous
> and could change by the time the count value is read from the CNTR
> register.
> 
> Since the race condition could result in an incorrect 25-bit count
> value, remove support for 25-bit count values from this driver.
> 
> Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> ---
>  drivers/counter/104-quad-8.c | 20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 

This patch also breaks the build, same error as on 5.10.y.

Can you send new 5.4.y and 5.10.y versions?  All the other ones were
fine.

thanks,

greg k-h
