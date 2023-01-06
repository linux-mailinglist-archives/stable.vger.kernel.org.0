Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC18F65FBAA
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 08:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjAFHEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 02:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjAFHEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 02:04:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2AF6ECAC;
        Thu,  5 Jan 2023 23:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A77561CE6;
        Fri,  6 Jan 2023 07:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8A2C433EF;
        Fri,  6 Jan 2023 07:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672988662;
        bh=qlGN7Q8BEBO44VTZMj82wjsb2amhsplawHPBpCT6abQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPTL/we73HWr5T98/8LoQxrTFaHLrNePzFCmc+rGdApeyVG+af5XsOhXGVJ0AsMY9
         pEkLUVoCwjfT78I0BPFy18YC4jR0daQZbyGydviVWoyC6y4fNSuyTl6HQ/MpUisJ3P
         ze5LoigI424ngRJvsPEVu7YrKzCG7qrAFEaNnon0=
Date:   Fri, 6 Jan 2023 08:04:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Sandy Huang <hjc@rock-chips.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7fH88gNfja364JD@kroah.com>
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 05:40:17PM -0800, Brian Norris wrote:
> The self-refresh helper framework overloads "disable" to sometimes mean
> "go into self-refresh mode," and this mode activates automatically
> (e.g., after some period of unchanging display output). In such cases,
> the display pipe is still considered "on", and user-space is not aware
> that we went into self-refresh mode. Thus, users may expect that
> vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
> properly.
> 
> However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
> vblank enabled here.
> 
> Add a new exception, such that we allow CRTCs to be "disabled" (with
> self-refresh active) with vblank interrupts still enabled.
> 
> Cc: <stable@vger.kernel.org> # dependency for subsequent patch

"subsequent" doesn't mean much when it is committed, give it a name
perhaps?

thanks,

greg k-h
