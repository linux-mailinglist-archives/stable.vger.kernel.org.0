Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57F056CF66
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiGJOSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGJOSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:18:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27FEDF4B
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 07:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA88611E1
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 14:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D57C3411E;
        Sun, 10 Jul 2022 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657462682;
        bh=eV7eKDx9Qy4jDuznrj9Up/xU5ON7WlAvgN3pikH1b10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WAH5pvJJhOm3d8/siwTIHqxn7WRYE7X8N0zLgy460/an5T/X1onGKgn0HexFe7i74
         VxKS9nMlo9T4bs8V+UjPhiiH4OYI4QAODNL7orvZZV/KNGzUU2CJe+xX3q3T5jKR+3
         /rrTucqNc05E2tk6geFFYpA0EvRKbF4fOG/qjzmg=
Date:   Sun, 10 Jul 2022 16:17:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: qca8k: reset cpu port on MTU change
Message-ID: <Ysrfl4drxUeX9R6W@kroah.com>
References: <20220628143010.17526-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628143010.17526-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 04:30:10PM +0200, Christian Marangi wrote:
> commit 386228c694bf1e7a7688e44412cb33500b0ac585 upstream.
> 
> It was discovered that the Documentation lacks of a fundamental detail
> on how to correctly change the MAX_FRAME_SIZE of the switch.
> 
> In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> switch panics and cease to send any packet. This cause the mgmt ethernet
> system to not receive any packet (the slow fallback still works) and
> makes the device not reachable. To recover from this a switch reset is
> required.
> 
> To correctly handle this, turn off the cpu ports before changing the
> MAX_FRAME_SIZE and turn on again after the value is applied.
> 
> Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Link: https://lore.kernel.org/r/20220621151122.10220-1-ansuelsmth@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ backport: fix conflict using the old port_sts struct instead of bitmap ]
> ---
>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

This only applied to 5.15.y and 5.18.y, what about 5.10.y?  Please give
us a hint as to what kernel(s) a backport is for when sending them.

thanks,

greg k-h
