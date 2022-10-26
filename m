Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359E460E3AC
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 16:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJZOrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 10:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiJZOrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 10:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7F79F34A;
        Wed, 26 Oct 2022 07:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C27E161F40;
        Wed, 26 Oct 2022 14:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2955C433D6;
        Wed, 26 Oct 2022 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666795665;
        bh=X2UhieQC0vkYAuIOP+R8NvoQajm/xqAszoQi26wF+rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hi8TM+flyocLYcbgEdcchBVnwTOr18yT+pNUXD+8TpjnWt8NNNaXCgmCqrEl7zeL2
         C4T3z5y7Wj2qGmv+KoM3gJEtGLwOqlpHBmPsc9blKH5yDOicE4ICVIaycOKG6ZyBDw
         bwR6o6kQmaAIsIzfEI0T5+mQ1dn6MlzBpOjPf42o=
Date:   Wed, 26 Oct 2022 16:47:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     javierm@redhat.com, deller@gmx.de, sashal@kernel.org,
        stable@vger.kernel.org,
        Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Zack Rusin <zackr@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2] video/aperture: Call sysfb_disable() before removing
 PCI devices
Message-ID: <Y1lIjt3awUj3MNIz@kroah.com>
References: <20221026144448.424-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026144448.424-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 04:44:48PM +0200, Thomas Zimmermann wrote:
> Call sysfb_disable() from aperture_remove_conflicting_pci_devices()
> before removing PCI devices. Without, simpledrm can still bind to
> simple-framebuffer devices after the hardware driver has taken over
> the hardware. Both drivers interfere with each other and results are
> undefined.
> 
> Reported modesetting errors [1] are shown below.

Now queued up, thanks.

greg k-h
