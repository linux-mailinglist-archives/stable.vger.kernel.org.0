Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48DD4D4058
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiCJEgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCJEgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B28F957D;
        Wed,  9 Mar 2022 20:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3511F617D7;
        Thu, 10 Mar 2022 04:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DC5C340E8;
        Thu, 10 Mar 2022 04:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886948;
        bh=FGEeHKgGa6xAxtUm0UWusuPBT4FNS/qfCOsJTNPDB84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i58XivLkb4qBdQFmirKpwI9QCTayv8dGXU4cMbiZZzRvvnDqB4HU4AoH/l5QeIZ7I
         IRHCGSYJD/45vwFtIm4Bh7mUYqJ6y/v11CmBRSULcILxpzdNPGbBZlkJowoMLVrTaJ
         nbKGH0XA3F8cXZACbJZtcCs39J4M1jpXuaoPgeJp/qydk+NNe11XxFGZt8BFC3OUWQ
         DWcTCRoqESwhq9+PFbZmRlhfMIuJNPhj6MPVCnWYmNz2nqgjO53u3eAqZxGQz9kfmb
         ABwQlj9RP+mqrLaDR7+1asC/zmKc3HijP4YG9EXfghKOj0pKfD7vKw4pHroTrcnWd7
         HJcLHqq1lxLag==
Date:   Thu, 10 Mar 2022 10:05:44 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 012/105] dmaengine: shdma: Fix runtime PM imbalance
 on error
Message-ID: <YimAIPBs4FNlXIs3@matsya>
References: <20220307091644.179885033@linuxfoundation.org>
 <20220307091644.529997660@linuxfoundation.org>
 <20220309105420.GA22677@duo.ucw.cz>
 <YiiWduSVDz1yYA9z@kroah.com>
 <20220309123509.GA30506@duo.ucw.cz>
 <YiiuaHFKuAv30zxW@kroah.com>
 <20220309135708.GB30506@duo.ucw.cz>
 <Yii+KtAnZ3XSJtXg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yii+KtAnZ3XSJtXg@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09-03-22, 15:48, Greg Kroah-Hartman wrote:
> On Wed, Mar 09, 2022 at 02:57:08PM +0100, Pavel Machek wrote:
> > On Wed 2022-03-09 14:40:56, Greg Kroah-Hartman wrote:
> > > On Wed, Mar 09, 2022 at 01:35:09PM +0100, Pavel Machek wrote:
> > > > On Wed 2022-03-09 12:58:46, Greg Kroah-Hartman wrote:
> > > > > On Wed, Mar 09, 2022 at 11:54:20AM +0100, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > From: Yongzhi Liu <lyz_cs@pku.edu.cn>
> > > > > > > 
> > > > > > > [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
> > > > > > > 
> > > > > > > pm_runtime_get_() increments the runtime PM usage counter even
> > > > > > > when it returns an error code, thus a matching decrement is needed on
> > > > > > > the error handling path to keep the counter balanced.
> > > > > > 
> > > > > > This patch will break things.
> > > > > > 
> > > > > > Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
> > > > > > actually abort/return error; we just printk. We'll do two
> > > > > > pm_runtime_put's after the "fix".
> > > > > > 
> > > > > > Please drop from -stable.
> > > > > > 
> > > > > > It was discussed during AUTOSEL review:
> > > > > > 
> > > > > > Date: Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
> > > > > > From: 刘永志 <lyz_cs@pku.edu.cn>
> > > > > > To: pavel machek <pavel@denx.de>
> > > > > > Cc: sasha levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
> > > > > > Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
> > > > > > 	imbalance on error
> > > > > 
> > > > > So 5.15 and 5.16 is ok, but older is not?
> > > > 
> > > > I believe commit is wrong for mainline and all stable releases, and
> > > > author seems to agree. Drop from everywhere.
> > > 
> > > Is it reverted in Linus's tree yet?
> > 
> > It will take you a minute to check.
> > 
> > Take a look at the patch. There's no return in error path, thus doing
> > runtime_put is clearly bogus. Should take you less than minute to
> > verify.
> > 
> > Please drop the patch.
> 
> I want to have it reverted in Linus's tree as well, otherwise that's a
> regression that people will hit.

I have reverted now, it will be in -next tomorrow and in mainline during
upcoming merge window

-- 
~Vinod
