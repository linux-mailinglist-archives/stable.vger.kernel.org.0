Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3453CB84
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbiFCOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiFCOaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:30:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F084C42B
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 07:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B0ADB8234F
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 14:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEECCC385A9;
        Fri,  3 Jun 2022 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654266649;
        bh=eFIYrq5TsbcgqrwqxOtUoClZbSHWL+A/KBQr99NGMwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/JQrn8+1JwV0epBQTnko6Dg/HS7Yss5OjmuUXYrimY+7X4qiQnMbdXpCPrZ648vk
         EJ004TD1sRUI6WesDuzu2qgKjx2tRbu61d0foSMwtzLpZuMoDhAJ8Y23m4j7lOvXLr
         Y6HFGKl1jGgt+lU/O/5nzCAYeJj/pKpbyGrgDU/0=
Date:   Fri, 3 Jun 2022 16:30:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ipa: compute proper aggregation limit
Message-ID: <YpobFgEcdslfDAq2@kroah.com>
References: <20220603123024.27609-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603123024.27609-1-elder@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:30:22AM -0500, Alex Elder wrote:
> commit c5794097b269f15961ed78f7f27b50e51766dec9 upstream.
> 
> The aggregation byte limit for an endpoint is currently computed
> based on the endpoint's receive buffer size.
> 
> However, some bytes at the front of each receive buffer are reserved
> on the assumption that--as with SKBs--it might be useful to insert
> data (such as headers) before what lands in the buffer.
> 
> The aggregation byte limit currently doesn't take into account that
> reserved space, and as a result, aggregation could require space
> past that which is available in the buffer.
> 
> Fix this by reducing the size used to compute the aggregation byte
> limit by the NET_SKB_PAD offset reserved for each receive buffer.
> 
> Cc: <stable@vger.kernel.org>    # 5.10.x
> Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints");
> Signed-off-by: Alex Elder <elder@linaro.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> The original commit doesn't cherry-pick cleanly to v5.10.119.  -Alex

All now queued up, thanks.

greg k-h
