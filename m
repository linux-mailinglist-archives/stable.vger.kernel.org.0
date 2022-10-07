Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA05F745B
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 08:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJGGs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 02:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJGGs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 02:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDABC4C3D
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 23:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B234161BCE
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 06:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF022C433D7;
        Fri,  7 Oct 2022 06:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665125307;
        bh=1ae0kSj8d3XQWR/80M5biR26N8kwPK0dRXq8zvebbCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZM59tdSVBO4L+8yCiloQwy9/c87pYjBOJC056P0kyyRBgPNKUc5FSfWaaz1aTaeH
         diuqRvueZG48O2BaGtHjJojyP07Suim0kSZfHEVyQ8MpotnvDXi01GGvx3XKQA9P56
         PL64ZKe5wWFhp6cElsdNQ7vcGb2oq92ASDTJAv0Q=
Date:   Fri, 7 Oct 2022 08:49:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        butterflyhuangxx@gmail.com, groeck@chromium.org
Subject: Re: [PATCH v5.10.y] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Message-ID: <Yz/L47ZUgnBdpCoG@kroah.com>
References: <20221006173127.2895108-1-zsm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006173127.2895108-1-zsm@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 10:31:27AM -0700, Zubin Mithra wrote:
> From: Takashi Iwai <tiwai@suse.de>
> 
> commit 8423f0b6d513b259fdab9c9bf4aaa6188d054c2d upstream.
> 
> There is a small race window at snd_pcm_oss_sync() that is called from
> OSS PCM SNDCTL_DSP_SYNC ioctl; namely the function calls
> snd_pcm_oss_make_ready() at first, then takes the params_lock mutex
> for the rest.  When the stream is set up again by another thread
> between them, it leads to inconsistency, and may result in unexpected
> results such as NULL dereference of OSS buffer as a fuzzer spotted
> recently.
> 
> The fix is simply to cover snd_pcm_oss_make_ready() call into the same
> params_lock mutex with snd_pcm_oss_make_ready_locked() variant.
> 
> Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
> Reviewed-by: Jaroslav Kysela <perex@perex.cz>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/CAFcO6XN7JDM4xSXGhtusQfS2mSBcx50VJKwQpCq=WeLt57aaZA@mail.gmail.com
> Link: https://lore.kernel.org/r/20220905060714.22549-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Zubin Mithra <zsm@google.com>
> ---
> Note:
> * 8423f0b6d513 is present in linux-5.15.y and linux-5.4.y; missing in
> linux-5.10.y.
> * Backport addresses conflict due to surrounding context.
> * Tests run: build and boot.

Now queued up, thanks.

greg k-h
