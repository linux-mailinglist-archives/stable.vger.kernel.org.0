Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE26BBE20
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCOUsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCOUsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:48:53 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 13:48:51 PDT
Received: from tu.jetro.fi (tu.jetro.fi [IPv6:2a01:4f9:c010:1a1b::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306A196AD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 13:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jetro.fi;
        s=170418; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L/3f0niBe+n8QtNjT0soQtqCZoQEjpVo14Zv9dQPrTU=; b=d7D1qcKlDOF6w58pcKFC+1HK+y
        Zn9aIASzbsmR0P1qmAI4pJ6Gs//Fe2fYk04FFQ1Z4Dr1WaZbBB4m5lMW8gLhBbDscHRqjrLbYJoGK
        4aj9Xv6qAUsN+ABpF1Br2UX0JHxRfb8sBSK4AJ8HZHAMgIq1v9RdeeH7jM21R5+eLSTo=;
Received: from [2001:470:28:7b9::190] (port=51694 helo=mopti)
        by tu.jetro.fi with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jje-lxkl@jetro.fi>)
        id 1pcXFh-00CQu9-0R;
        Wed, 15 Mar 2023 21:57:37 +0200
Date:   Wed, 15 Mar 2023 21:57:36 +0200
From:   Jetro Jormalainen <jje-lxkl@jetro.fi>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Meng Tang <tangmeng@uniontech.com>, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [REGRESSION] External mic not working on Lenovo Ideapad U310,
 ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
Message-ID: <20230315215736.419ac9eb@mopti>
In-Reply-To: <87o7ou9jfi.wl-tiwai@suse.de>
References: <20230308215009.4d3e58a6@mopti>
        <87o7ou9jfi.wl-tiwai@suse.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Wed, 15 Mar 2023 15:29:53 +0100
Takashi Iwai <tiwai@suse.de> kirjoitti:

> On Wed, 08 Mar 2023 20:50:09 +0100,
> Jetro Jormalainen wrote:
> > 
> > External mic on Lenovo Ideapad U310 has not been working with and
> > after 5.19.2 release. Same problem still exists on 6.3.0-rc1.
> > Reverting this commit makes external mic to work on 6.3.0-rc1.
> > These were tested on vanilla kernels.
> > 
> > Bisecting shows that this commit breaks external mic:
> > f83bb2592482fe94c6eea07a8121763c80f36ce5
> > ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model  
> 
> Sounds like multiple models using the same PCI SSID.
> Could you share the alsa-info.sh output?

I added alsa-info.sh output on non-working kernel to here:
https://e.pcloud.link/publink/show?code=XZjUqhZVP3JPN9gcyyh9lG23r5g3pKwaD8k

If it's any use here is also output on same kernel with the commit
reverted:
https://e.pcloud.link/publink/show?code=XZ9UqhZ90gGNhCqiEkFwsKoQ6LWI0ECt8a7

BR Jetro


> Meng, also could you give alsa-info.sh output of Lenovo 20149, too?
> 
> 
> thanks,
> 
> Takashi
> 
> 
> > After this commit Pulseaudio only shows "Microphone" port as before
> > there was "Internal microphone" and "Microphone". However when
> > recording this "Microphone" port that seems to record internal
> > microphone. External mic cannot be recorded at all after this
> > commit.
> > 
> > External mic not working (dmesg):
> > 
> > [    7.565222] snd_hda_codec_conexant hdaudioC1D0: CX20590: BIOS
> > auto-probing. [    7.566141] snd_hda_codec_conexant hdaudioC1D0:
> > autoconfig for CX20590: line_outs=1 (0x1f/0x0/0x0/0x0/0x0)
> > type:speaker [    7.566152] snd_hda_codec_conexant hdaudioC1D0:
> > speaker_outs=0 (0x0/0x0/0x0/0x0/0x0) [    7.566158]
> > snd_hda_codec_conexant hdaudioC1D0:    hp_outs=1
> > (0x19/0x0/0x0/0x0/0x0) [    7.566162] snd_hda_codec_conexant
> > hdaudioC1D0:    mono: mono_out=0x0 [    7.566166]
> > snd_hda_codec_conexant hdaudioC1D0:    inputs: [    7.566169]
> > snd_hda_codec_conexant hdaudioC1D0:      Mic=0x23 [    7.566172]
> > snd_hda_codec_conexant hdaudioC1D0:    dig-in=0x1a
> > 
> > External mic working (dmesg):
> > 
> > [    8.381160] snd_hda_codec_conexant hdaudioC1D0: CX20590: BIOS
> > auto-probing. [    8.381691] snd_hda_codec_conexant hdaudioC1D0:
> > autoconfig for CX20590: line_outs=1 (0x1f/0x0/0x0/0x0/0x0)
> > type:speaker [    8.381700] snd_hda_codec_conexant hdaudioC1D0:
> > speaker_outs=0 (0x0/0x0/0x0/0x0/0x0) [    8.381705]
> > snd_hda_codec_conexant hdaudioC1D0:    hp_outs=1
> > (0x19/0x0/0x0/0x0/0x0) [    8.381710] snd_hda_codec_conexant
> > hdaudioC1D0:    mono: mono_out=0x0 [    8.381714]
> > snd_hda_codec_conexant hdaudioC1D0:    inputs: [    8.381717]
> > snd_hda_codec_conexant hdaudioC1D0:      Internal Mic=0x23 [
> > 8.381721] snd_hda_codec_conexant hdaudioC1D0:      Mic=0x1a
> > 
> > 
> > cat /proc/version:
> > Linux version 6.3.0-rc1-1 (linux@archlinux) (gcc (GCC) 12.2.1
> > 20230201, GNU ld (GNU Binutils) 2.40) #10 SMP PREEMPT_DYNAMIC Wed,
> > 08 Mar 2023 17:45:22 +0000
> > 
> > hostnamectl | grep "Operating System":
> > Operating System: Arch Linux
> > 
> > uname -mi:
> > x86_64 unknown
> > 
> > #regzbot introduced: f83bb2592482  
> 

