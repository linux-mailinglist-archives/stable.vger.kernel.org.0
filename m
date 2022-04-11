Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A14FBCCC
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiDKNLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345599AbiDKNLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:11:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12EB12ADD;
        Mon, 11 Apr 2022 06:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DA16CE184A;
        Mon, 11 Apr 2022 13:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C73CC385A4;
        Mon, 11 Apr 2022 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649682560;
        bh=VSwGacvOIORYZ4p7jE5plCMbiYi86WyNmuPn5c91/U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGsWydM7UTNCSTpWl0qgNRrevYzXH25I4roxevR9uxu4JsKpMMBYvHSO1qQhAuKCV
         IUfj7pmMAaghRAUeKpVrkLxqJcietZtgW0xVkjG0QhVgEySJlUpPr/QoNnCE8PkqZn
         o7ebzr+tk3pN2c55sAMM4ZV9vCofyCiJXmQvfNGc=
Date:   Mon, 11 Apr 2022 15:09:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 012/105] dmaengine: shdma: Fix runtime PM imbalance
 on error
Message-ID: <YlQofqkmgKMeHCLW@kroah.com>
References: <20220307091644.179885033@linuxfoundation.org>
 <20220307091644.529997660@linuxfoundation.org>
 <20220309105420.GA22677@duo.ucw.cz>
 <YiiWduSVDz1yYA9z@kroah.com>
 <20220309123509.GA30506@duo.ucw.cz>
 <YiiuaHFKuAv30zxW@kroah.com>
 <20220309135708.GB30506@duo.ucw.cz>
 <Yii+KtAnZ3XSJtXg@kroah.com>
 <YimAIPBs4FNlXIs3@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YimAIPBs4FNlXIs3@matsya>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 10:05:44AM +0530, Vinod Koul wrote:
> On 09-03-22, 15:48, Greg Kroah-Hartman wrote:
> > On Wed, Mar 09, 2022 at 02:57:08PM +0100, Pavel Machek wrote:
> > > On Wed 2022-03-09 14:40:56, Greg Kroah-Hartman wrote:
> > > > On Wed, Mar 09, 2022 at 01:35:09PM +0100, Pavel Machek wrote:
> > > > > On Wed 2022-03-09 12:58:46, Greg Kroah-Hartman wrote:
> > > > > > On Wed, Mar 09, 2022 at 11:54:20AM +0100, Pavel Machek wrote:
> > > > > > > Hi!
> > > > > > > 
> > > > > > > > From: Yongzhi Liu <lyz_cs@pku.edu.cn>
> > > > > > > > 
> > > > > > > > [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
> > > > > > > > 
> > > > > > > > pm_runtime_get_() increments the runtime PM usage counter even
> > > > > > > > when it returns an error code, thus a matching decrement is needed on
> > > > > > > > the error handling path to keep the counter balanced.
> > > > > > > 
> > > > > > > This patch will break things.
> > > > > > > 
> > > > > > > Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
> > > > > > > actually abort/return error; we just printk. We'll do two
> > > > > > > pm_runtime_put's after the "fix".
> > > > > > > 
> > > > > > > Please drop from -stable.
> > > > > > > 
> > > > > > > It was discussed during AUTOSEL review:
> > > > > > > 
> > > > > > > Date: Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
> > > > > > > From: 刘永志 <lyz_cs@pku.edu.cn>
> > > > > > > To: pavel machek <pavel@denx.de>
> > > > > > > Cc: sasha levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
> > > > > > > Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
> > > > > > > 	imbalance on error
> > > > > > 
> > > > > > So 5.15 and 5.16 is ok, but older is not?
> > > > > 
> > > > > I believe commit is wrong for mainline and all stable releases, and
> > > > > author seems to agree. Drop from everywhere.
> > > > 
> > > > Is it reverted in Linus's tree yet?
> > > 
> > > It will take you a minute to check.
> > > 
> > > Take a look at the patch. There's no return in error path, thus doing
> > > runtime_put is clearly bogus. Should take you less than minute to
> > > verify.
> > > 
> > > Please drop the patch.
> > 
> > I want to have it reverted in Linus's tree as well, otherwise that's a
> > regression that people will hit.
> 
> I have reverted now, it will be in -next tomorrow and in mainline during
> upcoming merge window

Thanks, now queued up.

greg k-h
