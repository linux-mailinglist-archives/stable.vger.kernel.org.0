Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA08599AB4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348044AbiHSLM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347522AbiHSLM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5B9FEC6A
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:12:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E6E6174E
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62BFC433C1;
        Fri, 19 Aug 2022 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907576;
        bh=zgcHRS60fkKBcVtPJF3zRmLhRn1s7GVXaMWSOm9Hg4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iR+xct7IDDNBJMB/dDqe3i+frsD4xo3UMScaVUrchZK3E/DRo006FYy/9JS6sPi5X
         wnx7nuupHYku+wpF+HGV4jMwcZyxRgYBX389fUeQWnx+PurMzd8jdK+jD50eLM9Oi1
         /hMElaMXKP8aXGQYMU8gQ81dcjkeTmcjlo3J5Dpc=
Date:   Fri, 19 Aug 2022 13:12:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     stable@vger.kernel.org, huhai <huhai@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>
Subject: Re: [BACKPORT][PATCH -stable v4.19] firmware: arm_scpi: Ensure
 scpi_info is not assigned if the probe fails
Message-ID: <Yv9wNRC/K2ojLDHh@kroah.com>
References: <20220816090116.3350445-1-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816090116.3350445-1-sudeep.holla@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 10:01:16AM +0100, Sudeep Holla wrote:
> commit 689640efc0a2c4e07e6f88affe6d42cd40cc3f85 upstream.
> 
> When scpi probe fails, at any point, we need to ensure that the scpi_info
> is not set and will remain NULL until the probe succeeds. If it is not
> taken care, then it could result use-after-free as the value is exported
> via get_scpi_ops() and could refer to a memory allocated via devm_kzalloc()
> but freed when the probe fails.
> 
> Link: https://lore.kernel.org/r/20220701160310.148344-1-sudeep.holla@arm.com
> Cc: stable@vger.kernel.org # 4.19+
> Reported-by: huhai <huhai@kylinos.cn>
> Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  drivers/firmware/arm_scpi.c | 61 +++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 26 deletions(-)

Now queued up, thanks.

greg k-h
