Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD353CBB3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbiFCOoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245169AbiFCOoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E8643AD9;
        Fri,  3 Jun 2022 07:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27A34B82343;
        Fri,  3 Jun 2022 14:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4B2C385B8;
        Fri,  3 Jun 2022 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654267453;
        bh=CpjnsTFOIV6VM6JRW+RluS/ZLi3gemWGh7xo+U+GKCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tu24t6s9UYNqpISH5l7Vapy7l1I6CZ0s/6diqn9e3oh3qhNNF+vhDjYbX0bbMkZxs
         DEwOGDerMKjUxvOgaoPgCSSiUKi+gLT9R7kQN7ZDyetjHmfKnxBExs9addJLYZulby
         A7r550GzzNu6aLpPv7auP31RyX18TvSNH2Fut6+E=
Date:   Fri, 3 Jun 2022 16:44:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Lin, Tsung-hua (Ryan)" <Tsung-hua.Lin@amd.com>
Cc:     "Li, Leon" <Leon.Li@amd.com>,
        "Swarnakar, Praful" <Praful.Swarnakar@amd.com>,
        "S, Shirish" <Shirish.S@amd.com>,
        "Li, Ching-shih (Louis)" <Ching-shih.Li@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        Mark Yacoub <markyacoub@google.com>,
        "Li, Roman" <Roman.Li@amd.com>,
        Ikshwaku Chauhan <ikshwaku.chauhan@amd.corp-partner.google.com>,
        Simon Ser <contact@emersion.fr>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BACKPORT: drm/amdgpu/disply: set num_crtc earlier
Message-ID: <YpoeOu9rxeBAwI7U@kroah.com>
References: <20220530092902.810336-1-tsung-hua.lin@amd.com>
 <YpTBBPVxcdJ8sn8m@kroah.com>
 <DM6PR12MB441701EC6E6D2A678F42A480B2DF9@DM6PR12MB4417.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB441701EC6E6D2A678F42A480B2DF9@DM6PR12MB4417.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Jun 01, 2022 at 04:04:45AM +0000, Lin, Tsung-hua (Ryan) wrote:
> [AMD Official Use Only - General]
> 
> Hi Greg,
> 
> Thanks for your advice. I have modified the commit and submitted it to Gerrit and it's under code review now.

This makes no sense to me, we do not use gerrit for kernel development.

confused,

greg k-h
