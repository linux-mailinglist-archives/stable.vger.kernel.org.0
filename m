Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69C166ABCC
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 14:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjANNt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 08:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjANNt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 08:49:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B574E4EF6;
        Sat, 14 Jan 2023 05:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E2560A1E;
        Sat, 14 Jan 2023 13:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30831C433EF;
        Sat, 14 Jan 2023 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673704194;
        bh=3hfW/fmch3IQRYW7fl/lW+MZBSnaTyauyLuPYbzEz8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GnOGzheHLFDtSQSUDV8r9c8frnSa0eD3iIN8+waNK8CTWKait1kJ/r6ryYOVpqcnr
         AtX2t+y18rmzTb2JHACxaNSLuv7ffwGzYbP5QpcM8KdtKraoN0Top0COG2Od/3xFpr
         mj7NVpyfvPY2sLEKYHXlFKr5CCmURHGdSMewgeTU=
Date:   Sat, 14 Jan 2023 14:49:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ran Drori <rdrori@nvidia.com>,
        Frode Nordahl <frode.nordahl@canonical.com>
Subject: Re: [PATCH 5.15 049/230] net/mlx5e: Check action fwd/drop flag
 exists also for nic flows
Message-ID: <Y8Ky/3oq4HG0pe0x@kroah.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090605.473699898@linuxfoundation.org>
 <Y8CEv90mCZkmuFAq@xps13.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8CEv90mCZkmuFAq@xps13.dannf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 03:07:59PM -0700, dann frazier wrote:
> On Mon, Jul 11, 2022 at 11:05:05AM +0200, Greg Kroah-Hartman wrote:
> > From: Roi Dayan <roid@nvidia.com>
> > 
> > [ Upstream commit 6b50cf45b6a0e99f3cab848a72ecca8da56b7460 ]
> > 
> > The driver should add offloaded rules with either a fwd or drop action.
> > The check existed in parsing fdb flows but not when parsing nic flows.
> > Move the test into actions_match_supported() which is called for
> > checking nic flows and fdb flows.
> > 
> > Signed-off-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Maor Dickman <maord@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> hey Sasha,
> 
>   A contact at Nvidia tells me that this has caused a regression w/
> OVN HW offload. To fix that, commit 7f8770c7 ("net/mlx5e: Set action
> fwd flag when parsing tc action goto") is also required.
> 
>  I'm not really sure what flagged this patch for stable, so I don't
> know whether to suggest it be reverted, or that additonal patch be
> applied. Roi - what's your thought?

I've queued up the additional change now, thanks.

greg k-h
