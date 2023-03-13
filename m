Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F996B6F5E
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 07:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCMGLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 02:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCMGLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 02:11:01 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC7241B62;
        Sun, 12 Mar 2023 23:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=8FgVny58WchhP2I1FaqaWXzk13dWbdg3Y8M85JeLLaw=;
        b=f79byfS+1Xs0c7VHXoWanQA0Cz0Y0oF1C5AAEJrQ7qvvvmj3ZT0rUt1NPZ3FllKAOlyS7qh4jR4/e
         AuRnGMuHl5dmzYH/dHijdzD6aCMCmqeo1AjEk97OdUWJbGrCN3GyhMIOT62Ai5oq1N/eT4NPyvi3Xp
         sb43PHNZi3IfeBSDSoU+cZ3amEo7wHA7JaDdMnhR6ZKEo0bFfBsO4yzEAR9ykC4A1Y6OFxs4wYpB4C
         XBLcecKY3K3WkG29LakcgAnQyROQEPvGnN1+0/eif4yy8UGtXQlJ4o8QsJE3xE0I+8x5as95zAk03C
         w1F/vlLnEF755lF2XnFq3/amz7pjVAg==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.1.1470, Stamp: 3], Multi: [Enabled, t: (0.000014,0.009966)], BW: [Enabled, t: (0.000024,0.000001)], RTDA: [Enabled, t: (0.082624), Hit: No, Details: v2.48.0; Id: 15.zr4kz.1grcpf856.1trjv; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from x260 ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 13 Mar 2023 09:10:36 +0300
Date:   Mon, 13 Mar 2023 09:10:30 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     linux-imx@nxp.com
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: imx-weim: fix branch condition evaluates to a
 garbage value
Message-ID: <20230313061030.jdo5w6fs5cu33txm@x260>
References: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
 <20230306132526.8763-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306132526.8763-1-i.bornyakov@metrotek.ru>
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 04:25:26PM +0300, Ivan Bornyakov wrote:
> If bus type is other than imx50_weim_devtype and have no child devices,
> variable 'ret' in function weim_parse_dt() will not be initialized, but
> will be used as branch condition and return value. Fix this by
> initializing 'ret' with 0.
> 
> This was discovered with help of clang-analyzer, but the situation is
> quite possible in real life.
> 
> Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Cc: stable@vger.kernel.org
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/bus/imx-weim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> ChangeLog:
>   v1:
> [https://lore.kernel.org/all/20230306060505.11657-1-i.bornyakov@metrotek.ru/]
>   v2:
>     * add "Fixes" tag
>     * add Fabio's "Reviewed-by" tag
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

Ping.

