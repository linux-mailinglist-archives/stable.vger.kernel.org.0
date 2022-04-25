Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18F50E03B
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbiDYMae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242142AbiDYMaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:30:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D442131DFF
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F3FB815CC
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54CAC385A7;
        Mon, 25 Apr 2022 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650889519;
        bh=Cg2sZNo9J0lo6BL0E4qSuRqPivN9AiDC8YJTJfKOz1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TBocbomRhm472JiD9u+QDB9iHwOC88wrVcTJGDbV0BH0NNhLGcYjOMPbC3N4reI1U
         DsypSA9sFHuk3rVrxCvhVEovOITBrS3lgZe2mReNxGpOE4F8beSHVLGzLykrlyyRDj
         vLXA5WuAsoHQXEjBIdEHBYV46wZMG/uVYWP9TLnQ=
Date:   Mon, 25 Apr 2022 14:25:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     stable@vger.kernel.org, sashal@kernel.org, mkl@pengutronix.de,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: Re: [PATCH stable 5.10.y] can: isotp: stop timeout monitoring when
 no first frame was sent
Message-ID: <YmaTLEth/Thv7szN@kroah.com>
References: <20220425115701.2197-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425115701.2197-1-socketcan@hartkopp.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 01:57:01PM +0200, Oliver Hartkopp wrote:
> [ Upstream commit d73497081710c876c3c61444445512989e102152 ]
> 
> The first attempt to fix a the 'impossible' WARN_ON_ONCE(1) in
> isotp_tx_timer_handler() focussed on the identical CAN IDs created by
> the syzbot reproducer and lead to upstream fix/commit 3ea566422cbd
> ("can: isotp: sanitize CAN ID checks in isotp_bind()"). But this did
> not catch the root cause of the wrong tx.state in the tx_timer handler.
> 
> In the isotp 'first frame' case a timeout monitoring needs to be started
> before the 'first frame' is send. But when this sending failed the timeout
> monitoring for this specific frame has to be disabled too.
> 
> Otherwise the tx_timer is fired with the 'warn me' tx.state of ISOTP_IDLE.
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Link: https://lore.kernel.org/all/20220405175112.2682-1-socketcan@hartkopp.net
> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  net/can/isotp.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
