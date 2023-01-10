Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD6663ABF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjAJISp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbjAJISj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:18:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B7341D53
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93A44614FD
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD30C433D2;
        Tue, 10 Jan 2023 08:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338717;
        bh=gHe5knJqVEK6fEE3yI8j279Q6I5MLYSKJIeTRgHSd94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z6QM2GodGYHMGN9XsbBBHYco9Relq3bxa4s9gYC/J8rF+gOTQ81IMHQWbEp6qs5BQ
         ce9pcSkBKG8EW78whFmbDanZcH78vMIEn3j5MbrzRAoKorDjIHCiA0deCN8GdBnT9e
         RfDrpPq3hSW+kJS6N5aDXd9JQelJbFT8NpOtIT7M=
Date:   Tue, 10 Jan 2023 09:18:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     rhythm.m.mahajan@oracle.com
Cc:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org,
        tiwai@suse.de, perex@perex.cz, butterflyhuangxx@gmail.com,
        groeck@chromium.org, harshit.m.mogalapalli@oracle.com
Subject: Re: [PATCH v5.10.y] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Message-ID: <Y70fWZBWe9W7KX1Q@kroah.com>
References: <20221006173127.2895108-1-zsm@google.com>
 <Yz/L47ZUgnBdpCoG@kroah.com>
 <47d19f5f-8bb8-397b-dc0e-6027551539cf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47d19f5f-8bb8-397b-dc0e-6027551539cf@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 01:40:59PM +0530, rhythm.m.mahajan@oracle.com wrote:
> 
> 
> On 07/10/22 12:19 pm, Greg KH wrote:
> > On Thu, Oct 06, 2022 at 10:31:27AM -0700, Zubin Mithra wrote:
> > > From: Takashi Iwai <tiwai@suse.de>
> > > 
> > > commit 8423f0b6d513b259fdab9c9bf4aaa6188d054c2d upstream.
> > > 
> > > There is a small race window at snd_pcm_oss_sync() that is called from
> > > OSS PCM SNDCTL_DSP_SYNC ioctl; namely the function calls
> > > snd_pcm_oss_make_ready() at first, then takes the params_lock mutex
> > > for the rest.  When the stream is set up again by another thread
> > > between them, it leads to inconsistency, and may result in unexpected
> > > results such as NULL dereference of OSS buffer as a fuzzer spotted
> > > recently.
> > > 
> > > The fix is simply to cover snd_pcm_oss_make_ready() call into the same
> > > params_lock mutex with snd_pcm_oss_make_ready_locked() variant.
> > > 
> > > Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
> > > Reviewed-by: Jaroslav Kysela <perex@perex.cz>
> > > Cc: <stable@vger.kernel.org>
> > > Link: https://lore.kernel.org/r/CAFcO6XN7JDM4xSXGhtusQfS2mSBcx50VJKwQpCq=WeLt57aaZA@mail.gmail.com
> > > Link: https://lore.kernel.org/r/20220905060714.22549-1-tiwai@suse.de
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > Signed-off-by: Zubin Mithra <zsm@google.com>
> > > ---
> > > Note:
> > > * 8423f0b6d513 is present in linux-5.15.y and linux-5.4.y; missing in
> > > linux-5.10.y.
> > > * Backport addresses conflict due to surrounding context.
> > > * Tests run: build and boot.
> > 
> > Now queued up, thanks.
> > 
> > greg k-h
> 
> This patch applies cleanly on 4.14 LTS as well. Can we have this patch in
> 4.14? I have tested for build and boot.

Can you provide a working patch for this for 4.14.y and 4.19.y that you
have tested the sound works properly with this patch applied?  Booting
doesn't invoke sound usually :)

thanks,

greg k-h
