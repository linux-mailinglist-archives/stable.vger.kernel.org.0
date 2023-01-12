Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0D667280
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjALMsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjALMrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:47:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5315917E19;
        Thu, 12 Jan 2023 04:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04CBCB81E5D;
        Thu, 12 Jan 2023 12:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5051FC433EF;
        Thu, 12 Jan 2023 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527636;
        bh=VEi+TNc98bXm6k1eONoZBaZaKZzPyqd1h6QmXp44/vc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bA1T3Tr/4OWRjeZccuqHOZHcGWll09eTbOxJ4Lb4ZaNkBsaxnt7SomMZRJrb0bw3y
         rou9v/e0gThNHxsr+Cesi4nFlQJ15Mxfis+wBJHhqROq/qT2bgMf7nCPJ9UKc7nIha
         s3bgbj9heIreFwrcR9ZJ2OglBVxwke5q2+N4e5n4=
Date:   Thu, 12 Jan 2023 13:47:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        stable@vger.kernel.org, linux-serial@vger.kernel.org,
        Indan Zupancic <Indan.Zupancic@mep-info.com>
Subject: Re: [PATCH 5.10 1/2] fsl_lpuart: Don't enable interrupts too early
Message-ID: <Y8ABUYClE1ychdVp@kroah.com>
References: <20221223042354.4080724-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223042354.4080724-1-dominique.martinet@atmark-techno.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 01:23:53PM +0900, Dominique Martinet wrote:
> From: Indan Zupancic <Indan.Zupancic@mep-info.com>
> 
> [ Upstream commit 401fb66a355eb0f22096cf26864324f8e63c7d78 ]
> 
> If an irq is pending when devm_request_irq() is called, the irq
> handler will cause a NULL pointer access because initialisation
> is not done yet.
> 
> Fixes: 9d7ee0e28da59 ("tty: serial: lpuart: avoid report NULL interrupt")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Indan Zupancic <Indan.Zupancic@mep-info.com>
> Link: https://lore.kernel.org/r/20220505114750.45423-1-Indan.Zupancic@mep-info.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [5.10 did not have lpuart_global_reset or anything after
> uart_add_one_port(), so add the remove call in cleanup manually]
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
> This was originally intended as a prerequirement to backport the patch
> submitted in [1] for 5.10, but even with that part of the patch gone it
> makes sense as a fix on its own.
> 
> [1] https://lkml.kernel.org/r/20221222114414.1886632-1-linux@rasmusvillemoes.dk
> 
>  drivers/tty/serial/fsl_lpuart.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 

Both now queued up, thanks.

greg k-h
