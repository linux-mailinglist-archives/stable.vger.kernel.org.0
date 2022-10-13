Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F6B5FD3EC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 06:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJMEpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 00:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJMEpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 00:45:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EC3E4E6C;
        Wed, 12 Oct 2022 21:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9B7AB81B25;
        Thu, 13 Oct 2022 04:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2776EC433D6;
        Thu, 13 Oct 2022 04:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665636347;
        bh=tycp+HpY7xFT7uu/g1Wk0+ZRaC+dObiE4v4oSVgzYOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eOLJqZvpLwVqqqyza4XnyTcw6r87BdqvfKNi6SxUn43OfNLBAShpSQfOD8eWZvQJc
         dDatoFIjuAHyYCxfFgCyzNcs+uLYFW7xBf7dCmvq6VzrHDCbb1p6u9hesjlR1/Yuhl
         neXTh2Yq+CdIYNJAD6cMGdzI3glL0VqdGZszCT80=
Date:   Thu, 13 Oct 2022 06:46:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        remckee0@gmail.com, martin@kaiser.cx, straube.linux@gmail.com,
        makvihas@gmail.com, linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.19 47/63] staging: r8188eu: fix a potential
 memory leak in rtw_init_cmd_priv()
Message-ID: <Y0eYJ/LujniobZLu@kroah.com>
References: <20221013001842.1893243-1-sashal@kernel.org>
 <20221013001842.1893243-47-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013001842.1893243-47-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 08:18:21PM -0400, Sasha Levin wrote:
> From: Xiaoke Wang <xkernel.wang@foxmail.com>
> 
> [ Upstream commit 06bfdb6d889f57fe9ce7bd139ce278b68f3a59de ]
> 
> In rtw_init_cmd_priv(), if `pcmdpriv->rsp_allocated_buf` is allocated
> in failure, then `pcmdpriv->cmd_allocated_buf` will not be properly
> released. Besides, considering there are only two error paths and the
> first one can directly return, we do not need to implicitly jump to the
> `exit` tag to execute the error handling code.
> 
> So this patch added `kfree(pcmdpriv->cmd_allocated_buf);` on the error
> path to release the resource and simplified the return logic of
> rtw_init_cmd_priv(). As there is no proper device to test with, no
> runtime testing was performed.
> 
> Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
> Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> Link: https://lore.kernel.org/r/tencent_1B6AAE10471D4556788892F8FF3E4812F306@qq.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/r8188eu/core/rtw_cmd.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)

This isn't needed in stable trees, please drop from all branches.

greg k-h
