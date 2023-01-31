Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98312682FB8
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjAaOvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 09:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAaOvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:51:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382B015546;
        Tue, 31 Jan 2023 06:51:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD02BB81D1C;
        Tue, 31 Jan 2023 14:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1D6C4339C;
        Tue, 31 Jan 2023 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675176676;
        bh=nsoBopMAz4duSNJoBKEMLJBHGuAUe6NkWDgn9CCh3/4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=jrZ5LzfK8AEfiC/TmgzXeNEONR4Mq4jatwVKbFU4gGz0Mw2kq/x9arXRqUqNGOBWU
         o7sWjlV4GDDw2bcEe3Nol5ovWozKWP2yTpn3LhSjh0FGJQX7p5hMBb1bwDIPNCaWk5
         Lhcu71W618BwJcpkjBs3TP27/tZdvySzpSzbr0Ak=
Date:   Tue, 31 Jan 2023 15:51:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@knights.ucf.edu>
Subject: Re: [PATCHv2] fbcon: Check font dimension limits
Message-ID: <Y9kq4ZoBs8LkEtqs@kroah.com>
References: <20230129151740.x5p7jj2pbuilpzzt@begin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129151740.x5p7jj2pbuilpzzt@begin>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 04:17:40PM +0100, Samuel Thibault wrote:
> blit_x and blit_y are u32, so fbcon currently cannot support fonts
> larger than 32x32.
> 
> The 32x32 case also needs shifting an unsigned int, to properly set bit
> 31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
> as reported on:
> 
> http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07MB9830.namprd07.prod.outlook.com
> Kernel Branch: 6.2.0-rc5-next-20230124
> Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?usp=sharing
> Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?usp=sharing
> 
> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Fixes: 2d2699d98492 ("fbcon: font setting should check limitation of driver")
> Cc: stable@vger.kernel.org

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
