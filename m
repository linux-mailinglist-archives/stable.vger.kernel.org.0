Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27D16713D5
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 07:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjARGWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 01:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjARGUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 01:20:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592C646D75;
        Tue, 17 Jan 2023 22:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F254615B0;
        Wed, 18 Jan 2023 06:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE7C433D2;
        Wed, 18 Jan 2023 06:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674022107;
        bh=wJKzVtiwlBDSkpF0tCKhmbESueBYIIC1ljEZoRcApd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQ16+kTHXljxWWrlz3cs8bXXZ6YbI+m3Uex9mKKd1yJV/xr2tYPhJ6ZGY8W1m5jeB
         sr68AvpDIoQam4Wf0ZRHJ55sUrExyTU86RiaGLW7fP0HsV4+0espWmqNnwzvaM7div
         rfzB5YZtd891k2SRyXuVgY1LzPFEeZ9uXb7yZ6UQ=
Date:   Wed, 18 Jan 2023 07:08:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     hch@lst.de, stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8eM1ln+uGaR5h72@kroah.com>
References: <20230117151136.CB79.409509F4@e16-tech.com>
 <Y8Znr6CAFi8ikhdH@kroah.com>
 <20230118101433.734D.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118101433.734D.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 10:14:35AM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> > > 
> > > It seems patch *1 related.
> > > *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> > > 
> > > the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.
> > 
> > Argh, yes, let me go drop these again.
> > 
> > Sasha, can you blacklist these from your tools so they don't get picked
> > up again?
> 
> this panic does not happen on  upstream 6.2.0-rc4.
> or maybe we need a bigger patch set?

We just need to stop attempting to backport these to 6.1 :)
