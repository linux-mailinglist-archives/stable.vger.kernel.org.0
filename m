Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E773460B55F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiJXSWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJXSW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B120C27FAA5;
        Mon, 24 Oct 2022 10:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E67061411;
        Mon, 24 Oct 2022 14:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0067C433D6;
        Mon, 24 Oct 2022 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666622960;
        bh=aNMizm9PnkcQx8w7hMYma7rLH8oQC4gPO1zAZJ3CMGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uWMjJkTAfsf/pinEZUSdtix0BZ0ouTlhgNDG4jtRRn8atbJhICY2dYFTCwtWqSh/2
         7cXdT9SexqmOpqETo3QkbAoifLEWgtY1jHZFhwvYVSFXgg7coHuUvTngkm2IE73eVY
         PWgmwHtQJg496GVpYbMQinNZ2PEfPhZjk6A5Hi+M=
Date:   Mon, 24 Oct 2022 16:50:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.0.y] Revert "ALSA: hda: Fix page fault in
 snd_hda_codec_shutdown()"
Message-ID: <Y1amII/xslL7GB1I@kroah.com>
References: <20221024143931.15722-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024143931.15722-1-tiwai@suse.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 04:39:31PM +0200, Takashi Iwai wrote:
> This reverts commit 7494e2e6c55ed192f2b91c821fd6832744ba8741.
> 
> Which was upstream commit f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338.
> 
> The patch caused a regression leading to the missing HD-audio device
> with ASoC SOF driver.  It was a part of large series and backporting
> it alone breaks things while backporting the whole is too intrusive
> as stable changes.  And, the issue the patch tries to address is a
> corner case, hence it's better to revert.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216613
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> It's only for 6.0.y; 6.1-rc is fine

Now queued up, thanks.

greg k-h
