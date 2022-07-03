Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C914156456F
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 08:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGCGop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 02:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCGop (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 02:44:45 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 02 Jul 2022 23:44:43 PDT
Received: from mailrelay2-1.pub.mailoutpod1-cph3.one.com (mailrelay2-1.pub.mailoutpod1-cph3.one.com [46.30.210.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C670864D0
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 23:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=vxP0cGw3hHh8TfpWoKjeipnz7SqgYobDoDSTvlK7xfI=;
        b=BdYzAY7AndzrdqXiZrVmQ+K3Y+sJHfZ71LyfcIm95V83WcdXusc6jj3tVIp+LwGtablMQ3VIE6tMF
         laGLsSRfgztZj/KABU97clWyFT5lNp5Oy/EbAUPcHNQC14gqrjyeZ+/PRnBsYipc1qalyo+x7mehkd
         PjIGQ80L6+lMug8l33Jk2SaE/r3MD3eeZRRJaxf4xLgd0hbY2GYHHduvanzjNfvfkPneuI52AFweNj
         IZELEobn/pWDWqOaOQbTnu/m7Yk2aM3GoxH7Al/A1Vj5YMEfsWFdgpnWXV9pAEYvy4iIlvMWFdGjcl
         gJhBk2ODXhFdTTS6amjCQl7RihyIDAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=vxP0cGw3hHh8TfpWoKjeipnz7SqgYobDoDSTvlK7xfI=;
        b=QJPUfLbpvJmfb1Na9QQPmRMMP/16yIZVld0HfuL7gtHH7x14JBK1p/OoSeWTcK3R1SErQxvhLBSPp
         xZMyBDXDg==
X-HalOne-Cookie: 62bbb06fc9a29970a031891bb17428932ea70f5a
X-HalOne-ID: 787f57d8-fa9b-11ec-a917-d0431ea8a290
Received: from mailproxy4.cst.dirpod4-cph3.one.com (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 787f57d8-fa9b-11ec-a917-d0431ea8a290;
        Sun, 03 Jul 2022 06:43:39 +0000 (UTC)
Date:   Sun, 3 Jul 2022 08:43:37 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, list@opendingux.net,
        Christophe Branchereau <cbranchereau@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/ingenic: Use the highest possible DMA burst size
Message-ID: <YsE6mZanHLy9LpBd@ravnborg.org>
References: <20220702230727.66704-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220702230727.66704-1-paul@crapouillou.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On Sun, Jul 03, 2022 at 12:07:27AM +0100, Paul Cercueil wrote:
> Until now, when running at the maximum resolution of 1280x720 at 32bpp
> on the JZ4770 SoC the output was garbled, the X/Y position of the
> top-left corner of the framebuffer warping to a random position with
> the whole image being offset accordingly, every time a new frame was
> being submitted.
> 
> This problem can be eliminated by using a bigger burst size for the DMA.

Are there any alignment constraints of the framebuffer that depends on
the burst size? I am hit by this with some atmel IP - which is why I
ask.

Patch looks good and is a-b.

> 
> Set in each soc_info structure the maximum burst size supported by the
> corresponding SoC, and use it in the driver.
> 
> Set the new value using regmap_update_bits() instead of
> regmap_set_bits(), since we do want to override the old value of the
> burst size. (Note that regmap_set_bits() wasn't really valid before for
> the same reason, but it never seemed to be a problem).
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
