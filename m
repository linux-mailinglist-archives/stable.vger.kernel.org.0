Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E363A4D2E87
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 12:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiCIL7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 06:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiCIL7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 06:59:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24335B1083;
        Wed,  9 Mar 2022 03:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E61B8210E;
        Wed,  9 Mar 2022 11:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE68C340E8;
        Wed,  9 Mar 2022 11:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646827129;
        bh=3bfpEPDsk9wwRZ1k9LXiTn5sJRPNnBAFYHyZbWC+E3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVYNVJl/kMo00g5YVYFOyAarTyxu+CmWrB7PSEw6f1FFyCcp3PsBGqzPtZFs2r3Nk
         NYDpWLYW6v5m283XPOINf01RJDQI53Q2BtndrIP8Mq5GPnYy0vVv8RGwJ3XuL4LRqo
         UxqYhhHOUMYv4LI2stu55XoWK7K2JBW/v5y6wmug=
Date:   Wed, 9 Mar 2022 12:58:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 012/105] dmaengine: shdma: Fix runtime PM imbalance
 on error
Message-ID: <YiiWduSVDz1yYA9z@kroah.com>
References: <20220307091644.179885033@linuxfoundation.org>
 <20220307091644.529997660@linuxfoundation.org>
 <20220309105420.GA22677@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309105420.GA22677@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 11:54:20AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Yongzhi Liu <lyz_cs@pku.edu.cn>
> > 
> > [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
> > 
> > pm_runtime_get_() increments the runtime PM usage counter even
> > when it returns an error code, thus a matching decrement is needed on
> > the error handling path to keep the counter balanced.
> 
> This patch will break things.
> 
> Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
> actually abort/return error; we just printk. We'll do two
> pm_runtime_put's after the "fix".
> 
> Please drop from -stable.
> 
> It was discussed during AUTOSEL review:
> 
> Date: Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
> From: 刘永志 <lyz_cs@pku.edu.cn>
> To: pavel machek <pavel@denx.de>
> Cc: sasha levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
> Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
> 	imbalance on error

So 5.15 and 5.16 is ok, but older is not?

thanks,

greg k-h
