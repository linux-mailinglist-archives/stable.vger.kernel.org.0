Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7CC51EED8
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiEHQQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 12:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiEHQQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 12:16:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFDFDEF5;
        Sun,  8 May 2022 09:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDC1D6121A;
        Sun,  8 May 2022 16:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8460DC385A4;
        Sun,  8 May 2022 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652026355;
        bh=P6W2XUCIDtOr95rgU7d3QpyWeAEQjkqN2CvdZhRnVUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEy8y0LNeJNz4tKeHwzbIhiCFHWOYrSj5lgBMNLoTwocZIanfrS13yFAKvj1LlZjg
         x/y7Dd1dJ5hmo8bU5yGGAA+BVxNhZNk7GVMjm6R+o8rg8PNxweRSNgD0tec1AWE/op
         ZeNb9L4CFjGEFYkQUg4u8KeTWwb1EgjT288lw1YQ=
Date:   Sun, 8 May 2022 18:12:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.17 162/225] ASoC: Intel: sof_es8336: Add a quirk for
 Huawei Matebook D15
Message-ID: <Ynfr8LxLZpNvbQ77@kroah.com>
References: <20220504153110.096069935@linuxfoundation.org>
 <20220504153124.439720094@linuxfoundation.org>
 <YnLk9DLTZcVjTdK/@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnLk9DLTZcVjTdK/@fedora64.linuxtx.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 03:41:24PM -0500, Justin Forbes wrote:
> On Wed, May 04, 2022 at 06:46:40PM +0200, Greg Kroah-Hartman wrote:
> > From: Mauro Carvalho Chehab <mchehab@kernel.org>
> > 
> > [ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]
> > 
> > Based on experimental tests, Huawei Matebook D15 actually uses
> > both gpio0 and gpio1: the first one controls the speaker, while
> > the other one controls the headphone.
> > 
> > Also, the headset is mapped as MIC1, instead of MIC2.
> > 
> > So, add a quirk for it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Link: https://lore.kernel.org/r/d678aef9fc9a07aced611aa7cb8c9b800c649e5a.1649357263.git.mchehab@kernel.org
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> This patch is missing some dependencies and fails to build:
> 
> sound/soc/intel/boards/sof_es8336.c:261:41: error: 'SOF_ES8336_HEADPHONE_GPIO' undeclared here (not in a function)
>   261 |                 .driver_data = (void *)(SOF_ES8336_HEADPHONE_GPIO |
> 
> SOF_ES8336_HEADPHONE_GPIO was defined in upstream commit:
> 6e1ff1459e008 ASoC: Intel: sof_es8336: support a separate gpio to control headphone
> which appeared with 5.18-rc4
> 
> sound/soc/intel/boards/sof_es8336.c:262:41: error: 'SOC_ES8336_HEADSET_MIC1' undeclared here (not in a function)
>   262 |                                         SOC_ES8336_HEADSET_MIC1)
> 
> SOC_ES8336_HEADSET_MIC1 was defined in upstream commit: 
> 7c7bb2a059b22 ASoC: Intel: sof_es8336: add a quirk for headset at mic1 port
> which also appeared with 5.18-rc4
> 
> We either need to bring in these 2 commits or drop this one from the
> stable queue.

I've dropped this one now, thanks.

greg k-h
