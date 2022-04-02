Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2A4F0108
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiDBLZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240504AbiDBLZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757CD104A5A
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B01B80758
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 11:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67284C340EC;
        Sat,  2 Apr 2022 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648898593;
        bh=MxHVbL+6mXNrMl50SsXHdZKH2giQjHG7F2qr77mfjBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRwPwL9Proy9NWSRHgpS1g9S1WkQoIxr2lrCwDaYfuvH5pC4+AI+lhPuh9iTU2jO1
         V5Zkb+Lr09w8xozvL3ucgQGc6wNUoI9J4gQsEvn0DLnawVo39Y1fQldi61SVLuflRS
         yQrBYG+rG40LueZWx89ty6/k1oG1tY/Wz8l1jzEY=
Date:   Sat, 2 Apr 2022 13:23:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH stable v5.10-v5.17] can: isotp: sanitize CAN ID checks in
 isotp_bind()
Message-ID: <YkgyH6q9ymookm9g@kroah.com>
References: <20220402091239.3039-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402091239.3039-1-socketcan@hartkopp.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 11:12:39AM +0200, Oliver Hartkopp wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> commit 3ea566422cbde9610c2734980d1286ab681bb40e upstream.
> 
> Syzbot created an environment that lead to a state machine status that
> can not be reached with a compliant CAN ID address configuration.
> The provided address information consisted of CAN ID 0x6000001 and 0xC28001
> which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> 
> Sanitize the SFF/EFF CAN ID values before performing the address checks.
> 
> Cc: stable@vger.kernel.org # v5.10 - v5.17
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Link: https://lore.kernel.org/all/20220316164258.54155-1-socketcan@hartkopp.net
> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  net/can/isotp.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)

Now queued up, thanks.

greg k-h
