Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76B6AC072
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCFNLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCFNLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:11:18 -0500
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E52029160;
        Mon,  6 Mar 2023 05:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=0lPKYqp5KzpJCaV63cbjBO6MIb6dz7vOpMZcld4bLPA=;
        b=AB+AqP1S71ese3cohv4aD3rBSZFL6cfSKrfRGIT0mp+BUC8V7TkKL7CU9wEBjB8hefaWTL61AEzJN
         fllf3YKhScKnM9XqHrn9ZIIDOonSvt1J7lXHJPluQ0h9n1Fbd7J1k5zq3w0pMy1NVypFjZvPKEaCDa
         GTYgOI3FrYKy2J864FFZHWu6cYCkS8SZDhcwb5M6LlCYSmp15BMaQbRp0JWY6JL7d5bau/vH1SICpf
         YZdCXRrnrZ8LUFAKOjinKwDcnYkswVobcFpO6RiJh9l1pj+SZZ+Qvc+ol/lvbEBbXflXSIZFlA7pgQ
         RPprw28j9oMxXOBVeNwjn2uXiJ3WKVw==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.1.1470, Stamp: 3], Multi: [Enabled, t: (0.000012,0.008337)], BW: [Enabled, t: (0.000031,0.000001)], RTDA: [Enabled, t: (0.085092), Hit: No, Details: v2.48.0; Id: 15.q69xp.1gqrgnj4l.7b1; mclb], total: 0(700)
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from x260 ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 6 Mar 2023 16:10:46 +0300
Date:   Mon, 6 Mar 2023 16:10:40 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     linux-imx@nxp.com
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] bus: imx-weim: fix branch condition evaluates to
 a garbage value
Message-ID: <20230306131040.f6757retj5utp6lf@x260>
References: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 09:05:05AM +0300, Ivan Bornyakov wrote:
> If bus type is other than imx50_weim_devtype and have no child devices,
> variable 'ret' in function weim_parse_dt() will not be initialized, but
> will be used as branch condition and return value. Fix this by
> initializing 'ret' with 0.
> 
> This was discovered with help of clang-analyzer, but the situation is
> quite possible in real life.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Cc: stable@vger.kernel.org

Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")

Is it OK, or should I post v2 with "Fixes:" tag?

> ---
>  drivers/bus/imx-weim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
> index 828c66bbaa67..55d917bd1f3f 100644
> --- a/drivers/bus/imx-weim.c
> +++ b/drivers/bus/imx-weim.c
> @@ -204,8 +204,8 @@ static int weim_parse_dt(struct platform_device *pdev)
>  	const struct of_device_id *of_id = of_match_device(weim_id_table,
>  							   &pdev->dev);
>  	const struct imx_weim_devtype *devtype = of_id->data;
> +	int ret = 0, have_child = 0;
>  	struct device_node *child;
> -	int ret, have_child = 0;
>  	struct weim_priv *priv;
>  	void __iomem *base;
>  	u32 reg;
> -- 
> 2.39.2
> 

