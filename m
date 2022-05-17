Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11437529ED5
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbiEQKIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343712AbiEQKHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C2101C6;
        Tue, 17 May 2022 03:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F0E96159F;
        Tue, 17 May 2022 10:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251E7C385B8;
        Tue, 17 May 2022 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652782020;
        bh=Wtg35uVUr6hMwIWoaURTUK7Y2GU9twVAt6QGoTAABv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yyCpCgftolA8RmlkGqK2Rn+p7Lx2EZTQLrEhiTkO9Cqk+KWPHxa5PtTWw6qIIn9q4
         TYN+cHA/GilYl/Y/lEYqXqx2I79MkLYME2fBC1nCYTHQacetrx09BhZCTNcc1u8hmV
         pfjdVojy2uUDKdY9JZtsp0q+QeWcPDNLP6F2YWew=
Date:   Tue, 17 May 2022 12:06:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: fix a potential infinite loop
Message-ID: <YoNzwe9BodtxAH1N@kroah.com>
References: <20220517095809.7791-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095809.7791-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:58:09PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> In the for-loop in _rtl92e_update_rxcounts(),
> i is a u8 counter while priv->rtllib->LinkDetectInfo.SlotNum is
> a u16 num, there is a potential infinite loop if SlotNum is larger
> than u8_max.
> 
> Change the u8 loop counter i into u16.
> 
> Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> index b9ce71848023..3c5082abc583 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> @@ -1342,7 +1342,7 @@ static void _rtl92e_update_rxcounts(struct r8192_priv *priv, u32 *TotalRxBcnNum,
>  				    u32 *TotalRxDataNum)
>  {
>  	u16	SlotIndex;
> -	u8	i;
> +	u16	i;
>  
>  	*TotalRxBcnNum = 0;
>  	*TotalRxDataNum = 0;
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
