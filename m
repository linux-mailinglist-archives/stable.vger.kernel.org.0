Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34E755147E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 11:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiFTJiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 05:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiFTJiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 05:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D042A1123
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 02:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CDF461458
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70377C3411B;
        Mon, 20 Jun 2022 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655717879;
        bh=bdqRLYOQfMs9KRB0hRsZr8M/8IZRrDltwiVsSVdif14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXZ1+id/HeTrpSZ/nfT37iSvho2VKp6lNjTfWzjQUc3ne8+QgZ7ZxhEAZQsOp7ENu
         ds7RGA23PGL3CIIkNFl/Xxts06qEsVHet1FVtorEugMbQwyN6xDprVnpBmedjTrEJQ
         JePTa5sNA/O53ewjHzK06lShL2vUiBjdcM7xN8Hg=
Date:   Mon, 20 Jun 2022 11:37:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     stable@kernel.org, u.kleine-koenig@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH stable-5.18 (and below)] serial: 8250: Store to
 lsr_save_flags after lsr read
Message-ID: <YrA/9KUI3AHJXsGD@kroah.com>
References: <c41374bb-b114-ef16-aa15-f01d96f351cc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c41374bb-b114-ef16-aa15-f01d96f351cc@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 11:42:31AM +0300, Ilpo Järvinen wrote:
> [ Upstream commit be03b0651ffd8bab69dfd574c6818b446c0753ce ]
> 
> Not all LSR register flags are preserved across reads. Therefore, LSR
> readers must store the non-preserved bits into lsr_save_flags.
> 
> This fix was initially mixed into feature commit f6f586102add ("serial:
> 8250: Handle UART without interrupt on TEMT using em485"). However,
> that feature change had a flaw and it was reverted to make room for
> simpler approach providing the same feature. The embedded fix got
> reverted with the feature change.
> 
> Re-add the lsr_save_flags fix and properly mark it's a fix.
> 
> Link: https://lore.kernel.org/all/1d6c31d-d194-9e6a-ddf9-5f29af829f3@linux.intel.com/T/#m1737eef986bd20cf19593e344cebd7b0244945fc
> Fixes: e490c9144cfa ("tty: Add software emulated RS485 support for 8250")
> Cc: stable <stable@kernel.org>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Link: https://lore.kernel.org/r/f4d774be-1437-a550-8334-19d8722ab98c@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Here's the backport for 5.18. I think it applies fine to older kernel 
> versions too.

Thanks for the backport, now all queued up.

greg k-h
