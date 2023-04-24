Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082956EC651
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 08:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDXGdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 02:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjDXGdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 02:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2FC211F;
        Sun, 23 Apr 2023 23:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83316143F;
        Mon, 24 Apr 2023 06:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9905C433D2;
        Mon, 24 Apr 2023 06:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682318001;
        bh=lvovhZ5kc9XSHl+BHptc+M50M4+SNtk3zMTG/Axt4MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XOQ6HHxc8iEBwhLWnEeV1SthX11vSU6DHzXYSKsIqis6uSfSEM55VXVnLa/l7fs7X
         peRCBSJcqr2aVH/T1Z6jR6fp43AD3YwpF/FenPYMtsoWrtUBOJBFFQiZk7CQsKLWAe
         Nt1EqpUO9iIH0QZJSbFBNjNQUbGz9eF1/3NECKBc=
Date:   Mon, 24 Apr 2023 08:33:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v4 4/5] counter: 104-quad-8: Fix race condition
 between FLAG and CNTR reads
Message-ID: <2023042454-cahoots-rotten-f3f7@gregkh>
References: <20230423232047.12589-1-william.gray@linaro.org>
 <20230423232047.12589-4-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230423232047.12589-4-william.gray@linaro.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 23, 2023 at 07:20:46PM -0400, William Breathitt Gray wrote:
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
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> ---
>  drivers/counter/104-quad-8.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)

This patch breaks the build:

  CC [M]  drivers/counter/104-quad-8.o
drivers/counter/104-quad-8.c: In function ‘quad8_read_raw’:
drivers/counter/104-quad-8.c:117:34: error: ‘QUAD8_FLAG_BT’ undeclared (first use in this function); did you mean ‘QUAD8_FLAG_E’?
  117 |                 borrow = flags & QUAD8_FLAG_BT;
      |                                  ^~~~~~~~~~~~~
      |                                  QUAD8_FLAG_E
drivers/counter/104-quad-8.c:117:34: note: each undeclared identifier is reported only once for each function it appears in
drivers/counter/104-quad-8.c:118:36: error: ‘QUAD8_FLAG_CT’ undeclared (first use in this function); did you mean ‘QUAD8_FLAG_E’?
  118 |                 carry = !!(flags & QUAD8_FLAG_CT);
      |                                    ^~~~~~~~~~~~~
      |                                    QUAD8_FLAG_E


