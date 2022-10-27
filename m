Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E7060FB1A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 17:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiJ0PDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiJ0PDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 11:03:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D74F18DD5D;
        Thu, 27 Oct 2022 08:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00C78B8266C;
        Thu, 27 Oct 2022 15:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526FCC433C1;
        Thu, 27 Oct 2022 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666882998;
        bh=iS6o9yPRjOvIiZxlWU+wOkxC2wOPrtzC2YPgynWGcG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0aPvFdqaSltf92Zut2Z8b6wIoVoMerT/1DoilA+ExXpoPTOJ8uKE+5cy+VdSyAUSa
         F50/uuBSMQjaUN8t0dxuSfJ1mc33VyEePZSCKR7o/EYjMNRgNyFDHgo9C8MxgXWH6O
         RHL8C9xAOuiyuyPPWO8dDHDp5+l97oErl3M+94Ro=
Date:   Thu, 27 Oct 2022 17:03:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaurav Kohli <gauravkohli@linux.microsoft.com>
Cc:     stable@vger.kernel.org, haiyangz@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 5.4] hv_netvsc: Fix race between VF offering and VF
 association message from host
Message-ID: <Y1qdtCOPufTJ+OJv@kroah.com>
References: <1666872632-8476-1-git-send-email-gauravkohli@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666872632-8476-1-git-send-email-gauravkohli@linux.microsoft.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 05:10:32AM -0700, Gaurav Kohli wrote:
> [ Upstream commit 365e1ececb2905f94cc10a5817c5b644a32a3ae2 ]
> 
> During vm boot, there might be possibility that vf registration
> call comes before the vf association from host to vm.
> 
> And this might break netvsc vf path, To prevent the same block
> vf registration until vf bind message comes from host.
> 
> Cc: stable@vger.kernel.org
> Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/hyperv/hyperv_net.h |  3 +++
>  drivers/net/hyperv/netvsc.c     |  4 ++++
>  drivers/net/hyperv/netvsc_drv.c | 20 ++++++++++++++++++++
>  3 files changed, 27 insertions(+)

Now queued up, thanks.

greg k-h
