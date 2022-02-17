Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CAA4BA903
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiBQS67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:58:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244900AbiBQS6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFD811A0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A45B823C4
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE947C340E8;
        Thu, 17 Feb 2022 18:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124313;
        bh=9IzTlGPI+shroekFnPTCvD4dEH9VtS641oEuT/hOG/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A91kNfIA8dAytKNVDgQo5+a1MgYAWpF9O2F0gHC8zV0KO0uskiOr4D1RFX5f65fea
         TaoAKCfe5VHkVVFcqdsib8nYMOfDfpQWu6g5TkvwfGgvaQkRzZg59NmkRB9a5a3d9m
         vVJSeMAKb3CBeVjLa1tHAQ6Jj+OaYm+hIoRIhcNE=
Date:   Thu, 17 Feb 2022 19:58:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     stable@vger.kernel.org, Thomas Wagner <thwa1@web.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [BACKPORT stable Linux-5.10.y 2/2] can: isotp: add SF_BROADCAST
 support for functional addressing
Message-ID: <Yg6a1uJGpZoOSewT@kroah.com>
References: <20220216063137.2023-1-socketcan@hartkopp.net>
 <20220216063137.2023-2-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216063137.2023-2-socketcan@hartkopp.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 07:31:37AM +0100, Oliver Hartkopp wrote:
> Upstream commit 921ca574cd382142add8b12d0a7117f495510de5
> 
> The patch was intended for 5.10 but missed the merge window by some days.
> This missing patch continously breaks the backport of stable fixes and is
> the only missing feature of upstream isotp in Linux 5.10 e.g. for RasPi.
> 
> When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
> socket is switched into functional addressing mode, where only single frame
> (SF) protocol data units can be send on the specified CAN interface and the
> given tp.tx_id after bind().
> 
> In opposite to normal and extended addressing this socket does not register a
> CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
> segmented bi-directional data transfer.
> 
> Sending SFs on this socket is therefore a TX-only 'broadcast' operation.
> 
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Thomas Wagner <thwa1@web.de>
> Link: https://lore.kernel.org/r/20201206144731.4609-1-socketcan@hartkopp.net
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  include/uapi/linux/can/isotp.h |  2 +-
>  net/can/isotp.c                | 50 ++++++++++++++++++++++++----------
>  2 files changed, 37 insertions(+), 15 deletions(-)

Both now queued up, thanks.

greg k-h
