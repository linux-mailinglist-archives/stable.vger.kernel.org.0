Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B595367FFBD
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 16:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjA2PEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 10:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2PEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 10:04:38 -0500
Received: from sonata.ens-lyon.org (domu-toccata.ens-lyon.fr [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2751E9E3;
        Sun, 29 Jan 2023 07:04:37 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id E60B620101;
        Sun, 29 Jan 2023 16:04:33 +0100 (CET)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b4_rJgW-ZcYF; Sun, 29 Jan 2023 16:04:33 +0100 (CET)
Received: from begin (lfbn-bor-1-1163-184.w92-158.abo.wanadoo.fr [92.158.138.184])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 889D7200F9;
        Sun, 29 Jan 2023 16:04:33 +0100 (CET)
Received: from samy by begin with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1pM9EP-00Gy4h-0I;
        Sun, 29 Jan 2023 16:04:33 +0100
Date:   Sun, 29 Jan 2023 16:04:33 +0100
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Subject: Re: [PATCH] fbcon: Check font dimension limits
Message-ID: <20230129150433.gmdmger2ah63nsg7@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Jiri Slaby <jirislaby@kernel.org>, gregkh@linuxfoundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
References: <20230126004911.869923511@ens-lyon.org>
 <20230126004921.616264824@ens-lyon.org>
 <3bcd9911-5fdd-2a1a-0a76-55e1b8f7642a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bcd9911-5fdd-2a1a-0a76-55e1b8f7642a@kernel.org>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jiri Slaby, le jeu. 26 janv. 2023 10:02:55 +0100, a ecrit:
> On 26. 01. 23, 1:49, Samuel Thibault wrote:
> > Index: linux-6.0/drivers/video/fbdev/core/fbcon.c
> > ===================================================================
> > --- linux-6.0.orig/drivers/video/fbdev/core/fbcon.c
> > +++ linux-6.0/drivers/video/fbdev/core/fbcon.c
> > @@ -2489,9 +2489,12 @@ static int fbcon_set_font(struct vc_data
> >   	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
> >   		return -EINVAL;
> > +	if (font->width > 32 || font->height > 32)
> > +		return -EINVAL;
> > +
> >   	/* Make sure drawing engine can handle the font */
> > -	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
> > -	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
> > +	if (!(info->pixmap.blit_x & (1U << (font->width - 1))) ||
> > +	    !(info->pixmap.blit_y & (1U << (font->height - 1))))
> 
> So use BIT() properly then? That should be used in all these shifts anyway.
> Exactly to avoid UB.

Right, I'll use that in next version.

Samuel
