Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCFA4DB330
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiCPO1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356773AbiCPO06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:26:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C60538BD1
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2B6BCE1F60
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 14:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B53C340E9;
        Wed, 16 Mar 2022 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647440740;
        bh=B1tUAo6rgS/8F/cxP8zUL4LTRzK7vTWH/GnAuu/td9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2qTbJwTwbZskkd1/vPEyJQLP9exAUdW5LeFWkI/U/FAh1fcQp6oECbIepy9f4NNwV
         nVx4TXUW6JFlv0DZdPu8XCSkYNxTaSWVUQY6uu9iJU3RH3plrov1feDzo6FsHH95gN
         nMjcAxD2KSrVaWKxsVsbacq4r89PdP8sA1u5krU4=
Date:   Wed, 16 Mar 2022 15:25:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 2/2] sctp: fix the processing for INIT_ACK chunk
Message-ID: <YjHzVrzy6/oZpiTI@kroah.com>
References: <20220315132602.2094562-1-ovidiu.panait@windriver.com>
 <20220315132602.2094562-2-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315132602.2094562-2-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 03:26:02PM +0200, Ovidiu Panait wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 438b95a7c98f77d51cbf4db021f41b602d750a3f upstream.
> 
> Currently INIT_ACK chunk in non-cookie_echoed state is processed in
> sctp_sf_discard_chunk() to send an abort with the existent asoc's
> vtag if the chunk length is not valid. But the vtag in the chunk's
> sctphdr is not verified, which may be exploited by one to cook a
> malicious chunk to terminal a SCTP asoc.
> 
> sctp_sf_discard_chunk() also is called in many other places to send
> an abort, and most of those have this problem. This patch is to fix
> it by sending abort with the existent asoc's vtag only if the vtag
> from the chunk's sctphdr is verified in sctp_sf_discard_chunk().
> 
> Note on sctp_sf_do_9_1_abort() and sctp_sf_shutdown_pending_abort(),
> the chunk length has been verified before sctp_sf_discard_chunk(),
> so replace it with sctp_sf_discard(). On sctp_sf_do_asconf_ack() and
> sctp_sf_do_asconf(), move the sctp_chunk_length_valid check ahead of
> sctp_sf_discard_chunk(), then replace it with sctp_sf_discard().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [OP: adjusted context for 4.14]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  net/sctp/sm_statefuns.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)

All backports now queued up, thanks.

greg k-h
