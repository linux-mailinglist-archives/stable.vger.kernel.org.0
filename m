Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F8652E6EA
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 10:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbiETIEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 04:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiETIEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 04:04:48 -0400
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 01:04:47 PDT
Received: from relay3.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DE414D78B
        for <stable@vger.kernel.org>; Fri, 20 May 2022 01:04:47 -0700 (PDT)
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id A07E7814D3;
        Fri, 20 May 2022 07:59:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 5987220012;
        Fri, 20 May 2022 07:59:15 +0000 (UTC)
Message-ID: <ab048a2a99b7ff26da98ad01b575b036df7ddec9.camel@perches.com>
Subject: Re: [PATCH v3] nvmem: brcm_nvram: check for allocation failure
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date:   Fri, 20 May 2022 00:59:12 -0700
In-Reply-To: <20220520064516.GX4009@kadam>
References: <20220520064516.GX4009@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5987220012
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: uszn4rq8yguwbgz4noujdmrr6hoayhn8
X-Rspamd-Server: rspamout05
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19k4XSOnPuhcFCvKet5IpLxGxgUIDlzBFA=
X-HE-Tag: 1653033555-188531
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-05-20 at 09:45 +0300, Dan Carpenter wrote:
> Check for if the kcalloc() fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6e977eaa8280 ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Rafał Miłecki <rafal@milecki.pl>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> v3: Update fixes tag
> v2: I don't think anything changed in v2?  Added tags?
[]
> diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
[]
> @@ -97,6 +97,8 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
>  	len = le32_to_cpu(header.len);
>  
>  	data = kcalloc(1, len, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

trivia:

Not sure the kcalloc(1. ..) is useful.

It might be simpler using kzalloc, though given the memcpy_fromio
below a kcalloc/kzalloc seems dubious and kmalloc could be used.

>  	memcpy_fromio(data, priv->base, len);
>  	data[len - 1] = '\0';
>  


