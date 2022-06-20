Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0D5517BC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiFTLsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiFTLsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEB517057
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF59BB810DD
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336A0C3411B;
        Mon, 20 Jun 2022 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655725683;
        bh=owKBoPIUDtgfyoryKU9HjvmMfzEoK2YHly38yml+LCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XeiP3AOOVwrbY/47MLBepnUOrI/pLGh/Nf2Y2K+B8uggSZ3vt/1X1iJXrA8qIdqeW
         yH1p4msXOznlmqiwrkzKJ5mO9c2Otxg5yoUCUdAGVT53wsJhurPzlZCc6LQKPUh6ME
         E9yM6xidMppXb7aXN63Oi+3oWzFHJQXxrCubM/c4=
Date:   Mon, 20 Jun 2022 13:48:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     stable@vger.kernel.org, echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: [PATCH 5.10] net/sched: act_police: more accurate MTU policing
Message-ID: <YrBecGERMPdVEWaw@kroah.com>
References: <9793e31d40fa043c5965d3008d8534d01f533fa0.1655471603.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9793e31d40fa043c5965d3008d8534d01f533fa0.1655471603.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 03:32:59PM +0200, Davide Caratti wrote:
> commit 4ddc844eb81da59bfb816d8d52089aba4e59e269 upstream.
> 
> in current Linux, MTU policing does not take into account that packets at
> the TC ingress have the L2 header pulled. Thus, the same TC police action
> (with the same value of tcfp_mtu) behaves differently for ingress/egress.
> In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
> the policer drops GSO packets even when individual segments have the L2 +
> L3 + L4 + payload length below the configured valued of tcfp_mtu.
> 
> Improve the accuracy of MTU policing as follows:
>  - account for mac_len for non-GSO packets at TC ingress.
>  - compare MTU threshold with the segmented size for GSO packets.
> Also, add a kselftest that verifies the correct behavior.
> 
> [dcaratti: fix conflicts due to lack of the following commits:
>  - commit 2ffe0395288a ("net/sched: act_police: add support for
>    packet-per-second policing")
>  - commit 53b61f29367d ("selftests: forwarding: Add tc-police tests for
>    packets per second")]
> Link: https://lore.kernel.org/netdev/876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/sched/act_police.c                        | 16 +++++-
>  .../selftests/net/forwarding/tc_police.sh     | 52 +++++++++++++++++++
>  2 files changed, 67 insertions(+), 1 deletion(-)

Both now queued up, thanks.

greg k-h
