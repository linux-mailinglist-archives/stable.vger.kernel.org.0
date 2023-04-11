Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7336DDE39
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjDKOkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjDKOkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5106DE
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D60861F84
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8FBC433EF;
        Tue, 11 Apr 2023 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681224018;
        bh=ApfH9GyhdPzowTHe5Fw3vEM0GPZTh8dQLBSY+HkAxg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m2doML/+0/HJxrfx8cAquxBXX95SKwHnP54gGjlHjepUYeMXSnCd3T3S6wqeS8GUe
         +Om//+TMQkpHLbswdYE8JijTs+2V5yBh6FWuMuJMAFgT1sjDPIAoxK1Oq449tcdYcg
         cyLT6xaMDvaoLUA6ih7o2v9TcbYNVnKswQhSO/6M=
Date:   Tue, 11 Apr 2023 16:40:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     mkl@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: isotp: isotp_recvmsg(): use
 sock_recv_cmsgs() to get" failed to apply to 5.10-stable tree
Message-ID: <2023041146-reveler-scooter-ecc6@gregkh>
References: <2023041107-basically-gas-eb2c@gregkh>
 <9dadb8ab-f8d5-7ce3-c110-7bcae1bfb00e@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dadb8ab-f8d5-7ce3-c110-7bcae1bfb00e@hartkopp.net>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 04:34:25PM +0200, Oliver Hartkopp wrote:
> Hi Greg,
> 
> this must be a false positive for 5.10 and 5.15.
> 
> I can apply the commit 0145462fc802cd447ef5d029758043c7f15b4b1e on 5.10.y
> and 5.15.y without problems as the code around
> 
>     sock_recv_timestamp(msg, sk, skb);
> 
> did not change from 5.10 to 6.3-rc
> 
> But 'git am' tells the offset is about ~80 lines.
> Could this be the reason for the failure?

No, the failure is:

> On 4/11/23 13:36, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x 0145462fc802cd447ef5d029758043c7f15b4b1e
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041107-basically-gas-eb2c@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..
> > 
> > Possible dependencies:
> > 
> > 0145462fc802 ("can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos")
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> >  From 0145462fc802cd447ef5d029758043c7f15b4b1e Mon Sep 17 00:00:00 2001
> > From: Oliver Hartkopp <socketcan@hartkopp.net>
> > Date: Thu, 30 Mar 2023 19:02:48 +0200
> > Subject: [PATCH] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get
> >   SOCK_RXQ_OVFL infos
> > 
> > isotp.c was still using sock_recv_timestamp() which does not provide
> > control messages to detect dropped PDUs in the receive path.
> > 
> > Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> > Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > Link: https://lore.kernel.org/all/20230330170248.62342-1-socketcan@hartkopp.net
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > 
> > diff --git a/net/can/isotp.c b/net/can/isotp.c
> > index 9bc344851704..47c2ebad10ed 100644
> > --- a/net/can/isotp.c
> > +++ b/net/can/isotp.c
> > @@ -1120,7 +1120,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> >   	if (ret < 0)
> >   		goto out_err;
> > -	sock_recv_timestamp(msg, sk, skb);
> > +	sock_recv_cmsgs(msg, sk, skb);

This function is not in the 5.15.y or 5.10.y tree, so it breaks the
build.

thanks,

greg k-h
