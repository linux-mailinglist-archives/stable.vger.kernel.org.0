Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF83E3C76
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 21:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhHHTKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 15:10:22 -0400
Received: from sender4-of-o58.zoho.com ([136.143.188.58]:21846 "EHLO
        sender4-of-o58.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhHHTKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 15:10:22 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628449785; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=V/0g2zXgkcnEU7cZqd5oiW0yljfwQUgoFSMTLTOIL59AX6tHln+I9VfTWR4GMEhWQH7Q4RIbgT3xmNggxqBDEOpBusz9TiLuRw4jJIN1Tmcdt9r7H07qbC9/jYMLIBUYFJbZ/3YNCG14KO+9AVhaxD9lEzX7OuFbnGHB+zIHVz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1628449785; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gA8w0xb5eG5/2ysoihZoWJ6NWEiS8D1GIp2NAPTBvaQ=; 
        b=PPKrFfTDN2hou47rD8f9uAT91bBicSORfVOTjSxzCF/0KsvXuDIBBx55ipJeyVfyiR8fp0SKPh9NMx/fy71QAlJbvxPQmG6k0jO3a97nBXOvNYI2h7D3rG3C5T2EcpOU0gyOcsbVvWKXjBP7w/yCZgdvSq6LLMtVS4BBELUTgg4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=fnordco.com;
        spf=pass  smtp.mailfrom=klaatu@fnordco.com;
        dmarc=pass header.from=<jwoods@fnordco.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1628449785;
        s=zoho; d=fnordco.com; i=jwoods@fnordco.com;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=gA8w0xb5eG5/2ysoihZoWJ6NWEiS8D1GIp2NAPTBvaQ=;
        b=ObkVyKdS3g9X6GA1Kx9n0D9LAixHVtrX/JfwMzlBA7rR4Y8kl9l46ya4iR3/4v1d
        PxCkhV6nW/hQ7H/UY/2kbOQhRp0zus/HbFxZuPId+H1CzMZrHLnPJ6EFfoikFq1X0Mu
        sSa7itZA8WDEOPpV8vy12xLAgQSdWMLN3JOHQdUM=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1628449778840774.0347226881267; Sun, 8 Aug 2021 12:09:38 -0700 (PDT)
Date:   Sun, 08 Aug 2021 12:09:38 -0700
From:   Jeff Woods <jwoods@fnordco.com>
To:     "Takashi Iwai" <tiwai@suse.de>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>,
        "alsa-devel" <alsa-devel@alsa-project.org>,
        "stable" <stable@vger.kernel.org>,
        "regressions" <regressions@lists.linux.dev>
Message-ID: <17b272bac81.10ac3bd0570099.4091761174182420511@fnordco.com>
In-Reply-To: <s5him0gpghv.wl-tiwai@suse.de>
References: <17b1f9647ee.1179b6a05461889.5940365952430364689@fnordco.com>
        <YQ5Bb+mPgPivLqvX@kroah.com>
        <s5htuk1ppvb.wl-tiwai@suse.de>
        <17b22d08355.f21da1f938057.6900412371441404465@fnordco.com> <s5him0gpghv.wl-tiwai@suse.de>
Subject: Re: Kernel 5.13.6 breaks mmap with snd-hdsp module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 ---- On Sun, 08 Aug 2021 00:01:16 -0700 Takashi Iwai <tiwai@suse.de> wrote ----
 > On Sun, 08 Aug 2021 00:51:35 +0200,
 > Jeff Woods wrote:
 > > 
 > >  ---- On Sat, 07 Aug 2021 02:26:32 -0700 Takashi Iwai <tiwai@suse.de> wrote ----
 > >  > On Sat, 07 Aug 2021 10:16:47 +0200,
 > >  > Greg KH wrote:
 > >  > > 
 > >  > > On Sat, Aug 07, 2021 at 12:49:07AM -0700, Jeff Woods wrote:
 > >  > > > Specifically, commit c4824ae7db418aee6f50f308a20b832e58e997fd triggers the problem. Reverting this change restores functionality.
 > >  > > > 
 > >  > > > The device is an RME Multiface II, using the snd-hdsp driver.
 > >  > > > 
 > >  > > > Expected behavior: Device plays sound normally
 > >  > > > 
 > >  > > > Exhibited behavior: When a program attempts to open the device, the following ALSA lib error happens:
 > >  > > > 
 > >  > > > ALSA lib pcm_direct.c:1169:(snd1_pcm_direct_initialize_slave) slave plugin does not support mmap interleaved or mmap noninterleaved access
 > >  > > > 
 > >  > > > This change hasn't affected my other computers with less esoteric hardware, so probably the problem lies with the snd-hdsp driver, but the device is unusable without reverting that commit.
 > >  > > > 
 > >  > > > I am available to test any patches for this issue.
 > >  > > 
 > >  > > Have you notified the developers involved in this change about this
 > >  > > issue?
 > >  > 
 > >  > No, it's a new report :)
 > >  > 
 > >  > > Adding them now...
 > >  > 
 > >  > Could you try the patch below?
 > >  > 
 > >  > 
 > >  > thanks,
 > >  > 
 > >  > Takashi
 > >  > 
 > >  > -- 8< --
 > >  > From: Takashi Iwai <tiwai@suse.de>
 > >  > Subject: [PATCH] ALSA: pci: rme: Fix mmap breakage
 > >  > 
 > >  > The recent change in the PCM core restricts the mmap of unknown buffer
 > >  > type, and this broke the mmap on RME9652 and HDSP drivers that didn't
 > >  > set up properly.  Actually those driver do use the buffers allocated
 > >  > in a standard way, and the proper calls should fix the breakage.
 > >  > 
 > >  > Fixes: c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
 > >  > Cc: <stable@vger.kernel.org>
 > >  > Signed-off-by: Takashi Iwai <tiwai@suse.de>
 > >  > ---
 > >  >  sound/pci/rme9652/hdsp.c    | 6 ++----
 > >  >  sound/pci/rme9652/rme9652.c | 6 ++----
 > >  >  2 files changed, 4 insertions(+), 8 deletions(-)
 > >  > 
 > >  > diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
 > >  > index 8457a4bbc3df..b32a72e28917 100644
 > >  > --- a/sound/pci/rme9652/hdsp.c
 > >  > +++ b/sound/pci/rme9652/hdsp.c
 > >  > @@ -4518,8 +4518,7 @@ static int snd_hdsp_playback_open(struct snd_pcm_substream *substream)
 > >  >      snd_pcm_set_sync(substream);
 > >  >  
 > >  >          runtime->hw = snd_hdsp_playback_subinfo;
 > >  > -    runtime->dma_area = hdsp->playback_buffer;
 > >  > -    runtime->dma_bytes = HDSP_DMA_AREA_BYTES;
 > >  > +    snd_pcm_set_runtime_buffer(substream, hdsp->playback_dma_buf);
 > >  >  
 > >  >      hdsp->playback_pid = current->pid;
 > >  >      hdsp->playback_substream = substream;
 > >  > @@ -4595,8 +4594,7 @@ static int snd_hdsp_capture_open(struct snd_pcm_substream *substream)
 > >  >      snd_pcm_set_sync(substream);
 > >  >  
 > >  >      runtime->hw = snd_hdsp_capture_subinfo;
 > >  > -    runtime->dma_area = hdsp->capture_buffer;
 > >  > -    runtime->dma_bytes = HDSP_DMA_AREA_BYTES;
 > >  > +    snd_pcm_set_runtime_buffer(substream, hdsp->capture_dma_buf);
 > >  >  
 > >  >      hdsp->capture_pid = current->pid;
 > >  >      hdsp->capture_substream = substream;
 > >  > diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
 > >  > index f1aad38760d6..8036ed761d53 100644
 > >  > --- a/sound/pci/rme9652/rme9652.c
 > >  > +++ b/sound/pci/rme9652/rme9652.c
 > >  > @@ -2279,8 +2279,7 @@ static int snd_rme9652_playback_open(struct snd_pcm_substream *substream)
 > >  >      snd_pcm_set_sync(substream);
 > >  >  
 > >  >          runtime->hw = snd_rme9652_playback_subinfo;
 > >  > -    runtime->dma_area = rme9652->playback_buffer;
 > >  > -    runtime->dma_bytes = RME9652_DMA_AREA_BYTES;
 > >  > +    snd_pcm_set_runtime_buffer(substream, rme9652->playback_dma_buf);
 > >  >  
 > >  >      if (rme9652->capture_substream == NULL) {
 > >  >          rme9652_stop(rme9652);
 > >  > @@ -2339,8 +2338,7 @@ static int snd_rme9652_capture_open(struct snd_pcm_substream *substream)
 > >  >      snd_pcm_set_sync(substream);
 > >  >  
 > >  >      runtime->hw = snd_rme9652_capture_subinfo;
 > >  > -    runtime->dma_area = rme9652->capture_buffer;
 > >  > -    runtime->dma_bytes = RME9652_DMA_AREA_BYTES;
 > >  > +    snd_pcm_set_runtime_buffer(substream, rme9652->capture_dma_buf);
 > >  >  
 > >  >      if (rme9652->playback_substream == NULL) {
 > >  >          rme9652_stop(rme9652);
 > >  > -- 
 > >  > 2.26.2
 > >  > 
 > >  
 > > I applied the patch to kernel 5.13.8, but compilation fails with these errors:
 > 
 > Oops, sorry, that was the patch for linux-next, and I forgot the
 > recent code change.  And it turned out not to be effective.
 > 
 > Below is another try.  Scratch the previous one (although it cannot
 > hurt), and try this one instead.
 > 
 > 
 > thanks,
 > 
 > Takashi
 > 
 > -- 8< --
 > From: Takashi Iwai <tiwai@suse.de>
 > Subject: [PATCH] ALSA: pcm: Fix mmap breakage without explicit buffer setup
 > 
 > The recent fix c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
 > restricts the mmap capability only to the drivers that properly set up
 > the buffers, but it caused a regression for a few drivers that manage
 > the buffer on its own way.
 > 
 > For those with UNKNOWN buffer type (i.e. the uninitialized / unused
 > substream->dma_buffer), just assume that the driver handles the mmap
 > properly and blindly trust the hardware info bit.
 > 
 > Fixes: c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
 > Cc: <stable@vger.kernel.org>
 > Signed-off-by: Takashi Iwai <tiwai@suse.de>
 > ---
 >  sound/core/pcm_native.c | 5 ++++-
 >  1 file changed, 4 insertions(+), 1 deletion(-)
 > 
 > diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
 > index 09c0e2a6489c..71323d807dbf 100644
 > --- a/sound/core/pcm_native.c
 > +++ b/sound/core/pcm_native.c
 > @@ -251,7 +251,10 @@ static bool hw_support_mmap(struct snd_pcm_substream *substream)
 >  
 >      switch (substream->dma_buffer.dev.type) {
 >      case SNDRV_DMA_TYPE_UNKNOWN:
 > -        return false;
 > +        /* we can't know the device, so just assume that the driver does
 > +         * everything right
 > +         */
 > +        return true;
 >      case SNDRV_DMA_TYPE_CONTINUOUS:
 >      case SNDRV_DMA_TYPE_VMALLOC:
 >          return true;
 > -- 
 > 2.26.2
 > 
 > 

I applied the patch to 5.13.9, and it did indeed solve the problem.

Thank you very much!

For future reference, if I am reporting an issue with stable and I know the
commit that caused it, should I contact the committer directly *and* cc the
stable and regressions list?

I'm trying to keep protocol and not spam things up too much.

Thanks,
Jeff

