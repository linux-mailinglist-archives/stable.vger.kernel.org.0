Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1731B4E8A64
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 00:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiC0WPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 18:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbiC0WPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 18:15:16 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737CF49F8A;
        Sun, 27 Mar 2022 15:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
        In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pV29UjFYmfGiilWwyQNlVjFasUPj3jYxTXkmhIEc+XM=; b=BHU0kAa6aPENeSDuCOZPHe56vV
        qpF2gdxkZMMrvTtlKbEeVlVbwiTgG6JyTb8gftMEhKrtLpNWaa+2q0BPH+65voWXa1q7NN74q6Xdk
        th1/kUkA2/12kAlPqkbJPBL3Si86W2SSXNOyEEuh7Fp3oFnLn4XHtogu9xe0fsk6lC6HHPI+/SoWe
        /NHJMOZOmG8fXRXW03DiEq5WOfqfZ0XQGrYz4QtaSqmmpE711w5bK9DZIDbCGu/oQ2Sk/YnoRC/E/
        XNqvj0NZF2EzGzZSoW1oBeq1O9wY8LiKpiKXFVd2l2KSn+jaQ13cZcuNRw8ppEu2TFNTZf8SvCShR
        WPYY8utA==;
Received: from webng-gw.kapsi.fi ([91.232.154.200] helo=roundcube.kapsi.fi)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <jyri.sarha@iki.fi>)
        id 1nYb8V-00024d-Uh; Mon, 28 Mar 2022 01:13:23 +0300
MIME-Version: 1.0
Date:   Mon, 28 Mar 2022 01:13:21 +0300
From:   Jyri Sarha <jyri.sarha@iki.fi>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     tomba@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tilcdc: tilcdc_external: fix an incorrect NULL check on
 list iterator
In-Reply-To: <20220327061516.5076-1-xiam0nd.tong@gmail.com>
References: <20220327061516.5076-1-xiam0nd.tong@gmail.com>
Message-ID: <eadea5bbb40c168ee1bbf955c10979cb@iki.fi>
X-Sender: jyri.sarha@iki.fi
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 91.232.154.200
X-SA-Exim-Mail-From: jyri.sarha@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-27 9:15, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!encoder) {
> 
> The list iterator value 'encoder' will *always* be set and non-NULL
> by list_for_each_entry(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> is found.
> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'encoder' as a dedicated pointer
> to point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: ec9eab097a500 ("drm/tilcdc: Add drm bridge support for
> attaching drm bridge drivers")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Thanks for the patch. Good catch.

Reviewed-by: Jyri Sarha <jyri.sarha@iki.fi>
Tested-by: Jyri Sarha <jyri.sarha@iki.fi>

I'll apply this to drm-misc-next in couple of days.

Best regards,
Jyri

> ---
>  drivers/gpu/drm/tilcdc/tilcdc_external.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c
> b/drivers/gpu/drm/tilcdc/tilcdc_external.c
> index 7594cf6e186e..3b86d002ef62 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
> @@ -60,11 +60,13 @@ struct drm_connector
> *tilcdc_encoder_find_connector(struct drm_device *ddev,
>  int tilcdc_add_component_encoder(struct drm_device *ddev)
>  {
>  	struct tilcdc_drm_private *priv = ddev->dev_private;
> -	struct drm_encoder *encoder;
> +	struct drm_encoder *encoder = NULL, *iter;
> 
> -	list_for_each_entry(encoder, &ddev->mode_config.encoder_list, head)
> -		if (encoder->possible_crtcs & (1 << priv->crtc->index))
> +	list_for_each_entry(iter, &ddev->mode_config.encoder_list, head)
> +		if (iter->possible_crtcs & (1 << priv->crtc->index)) {
> +			encoder = iter;
>  			break;
> +		}
> 
>  	if (!encoder) {
>  		dev_err(ddev->dev, "%s: No suitable encoder found\n", __func__);
