Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95668C722
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 20:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBFT6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 14:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBFT6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 14:58:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B356610DF
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 11:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675713465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoZExbiXqpG23UyqtcXP1++ZpBqq0tifWjk0XdIB/q4=;
        b=S8A33YtG8ObVkKw2bDNmcqwTLF8KRzhTVJX/pawVoY7K5kjQ+K6SN5qyald9BxrJ+Qe0sX
        vWDbu5u8GRrXpgmqeZwjSZAN4S6/Kmvzo2/4aSFK5jvBdYlHe9J/rUa6Pi6Y3Tjc80HU+1
        KbiF5pUl75Kb1xZ6d5JMXTGWrcIPISw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-Wpz-ueZSNNCLFoAWbibdTQ-1; Mon, 06 Feb 2023 14:57:44 -0500
X-MC-Unique: Wpz-ueZSNNCLFoAWbibdTQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-507aac99fdfso125069267b3.11
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 11:57:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XoZExbiXqpG23UyqtcXP1++ZpBqq0tifWjk0XdIB/q4=;
        b=HQNbuAnLIpybb5O7OY7IInB11iYfw0hHhOgzw5xJZ+ZaeJ3vVZSckL0Q4O3W02NCnB
         aRhuvpJxySac+XJlk7h1JyuweR6QpFyPH3JJfn+g3wmP6AKOuLPIg6fCuEkpxCLWJNB3
         rN4JTEpKPZtfXJfwOCQgVvkc5OhU/DKptGRy8Bk+wz5V72G7KVnQZvWktXAh6aX9p5WE
         RbrJy7dcZHUXBCptLbeY/K7TGZJnF4HLaPUkSXdKG8LKHr/f9/Jzrt5hY5jQ2TvHtQiP
         PEf2uX5FZ575TdWrB8eZF/O4zqO9v7MHMfx7vLvnilfuHd0E/jVu95sAPexWwrsoVYhW
         G8fg==
X-Gm-Message-State: AO0yUKXO1gGuFEuXkznpvxPEL4sgEECkD5CTlbxTkbgmNOxKAsNPgIUJ
        XfPLCW5M+YigGGDXPiaDv3to0yBK6SzpdY2s2pHCmF5LlFkAnkRYWnfr/JPfhAZ1Z7u3JqCodtZ
        LTWf7cQM0KsGvNr/2LLVsYvYNe/gtu18Q
X-Received: by 2002:a0d:e484:0:b0:50a:87fe:1e45 with SMTP id n126-20020a0de484000000b0050a87fe1e45mr44400ywe.338.1675713462483;
        Mon, 06 Feb 2023 11:57:42 -0800 (PST)
X-Google-Smtp-Source: AK7set/jMzCmGEKuLWPqEHLTltoh3gI9r+C/xXKLZ/kyX0OCZ3SkJ8AVDkkyp+YD9FjK9M1lBcBy0p2ZM588GVHXrWM=
X-Received: by 2002:a0d:e484:0:b0:50a:87fe:1e45 with SMTP id
 n126-20020a0de484000000b0050a87fe1e45mr44396ywe.338.1675713462143; Mon, 06
 Feb 2023 11:57:42 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info> <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com> <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
 <6262bd72-cc2b-9d2a-e8f0-55c2b2bb7861@linux.intel.com> <CAJD_bPKxbsDi10FGX2mrMeuxcphDOvO8Q87j+AvnnQpe5cvmSA@mail.gmail.com>
 <CAJD_bP+RUemsss_YiAZ5v08ak8aTzXCB0gk7q623zyF455bh7g@mail.gmail.com>
 <a423c627-d303-3b50-5f11-78c06ed3b985@linux.intel.com> <CAJD_bPKO+zCeRojkOr2uY+nXvhsjO3Um86Lh53ZCuCUm3Ci3PA@mail.gmail.com>
In-Reply-To: <CAJD_bPKO+zCeRojkOr2uY+nXvhsjO3Um86Lh53ZCuCUm3Ci3PA@mail.gmail.com>
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Mon, 6 Feb 2023 14:57:31 -0500
Message-ID: <CAJD_bPJfT5DA8EdN+timzXa3-itnPD5epq552S=NQ6Spr7iTUw@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     =?UTF-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 6, 2023 at 8:51 AM Jason Montleon <jmontleo@redhat.com> wrote:
>
> On Mon, Feb 6, 2023 at 4:04 AM Amadeusz S=C5=82awi=C5=84ski
> <amadeuszx.slawinski@linux.intel.com> wrote:
> >
> > On 2/4/2023 4:16 PM, Jason Montleon wrote:
> > > I have built kernels for 6.0.19 (I don't think anyone confirmed
> > > whether or not it worked), plus every 6.1 tag from 6.1-rc1 up to
> > > 6.1.7. 6.0.19 worked. No 6.1 kernels worked. For rc1 to rc5 I built
> > > with and without the legacy dai renaming patch added in rc6 that I
> > > believe would be necessary, but it made no difference either way.
> >
> > Hi,
> >
> > thank you for trying to narrow it down, if I understand correctly -rc1
> > doesn't work, which means that problem was introduced somewhere between
> > 6.0 and 6.1-rc1 (just for the sake of being sure, can you test 6.0
> > instead of 6.0.19?) There is one commit which I'm bit suspicious about:
> > ef6f5494faf6a37c74990689a3bb3cee76d2544c it changes how HDMI are
> > assigned and as a machine board present on EVE makes use of HDMI, it ma=
y
> > potentially cause some problems. Can you try reverting it?
> > (If reverting on top of v6.1.8 you need to revert both
> > f9aafff5448b1d8d457052271cd9a11b24e4d0bd and
> > ef6f5494faf6a37c74990689a3bb3cee76d2544c which has minor conflict,
> > easily resolved with just adding both lines.
> >
>
> Yes, happy to give that a shot and will report back.
>

Removing f9aafff5448b1d8d457052271cd9a11b24e4d0bd and
ef6f5494faf6a37c74990689a3bb3cee76d2544c did not make things work.

You may be onto something with pulseaudio and/or HDMI, however.
When setting up Slackware I saw an interesting aplay hang.
Normally aplay -l will list like this with working audio:
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: kblr55145663max [kbl-r5514-5663-max], device 0: Audio (*) []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: kblr55145663max [kbl-r5514-5663-max], device 2: Headset Audio (*) [=
]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: kblr55145663max [kbl-r5514-5663-max], device 6: Hdmi1 (*) []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: kblr55145663max [kbl-r5514-5663-max], device 7: Hdmi2 (*) []
  Subdevices: 1/1
  Subdevice #0: subdevice #0

Both on Slackware and Fedora with broken audio it hangs like so
(haven't tried on Arch):
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: kblr55145663max [kbl-r5514-5663-max], device 0: Audio (*) []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: kblr55145663max [kbl-r5514-5663-max], device 2: Headset Audio (*) [=
]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: kblr55145663max [kbl-r5514-5663-max], device 6: Hdmi1 (*) []
  Subdevices: 1/1
  Subdevice #0: subdevice #0

If I remove or disable pulseaudio it lists without hanging, but it's
difficult for me to tell whether it's working since aplay, etc. seem
to want pulseaudio to play anything. Shutdown hangs persist
regardless.

Also, Slackware with 6.1.9 behaves as badly for me as everything else.
If Sasa has working audio I do not know how he has managed to
configure it. On each distro, as soon as I add topology and firmware
files everything goes bad, regardless of whether I add ucm
configuration or not, etc.

> > I also still wonder, why problem reproduces only on some
> > distributions... any chance you can try and boot with
> > pipewire/pulseaudio disabled and see if it still happens, iirc those
> > tools try to check all FEs and this may be breaking something during
> > enumeration.
>
> I can definitely try disabling pulseaudio and switching to pipewire
> and seeing if anything changes as well.
>
> FWIW, I installed Arch on a thumb drive this weekend and was able to
> reproduce the issue and work around it by reverting the commit from my
> first bisect. So, for me it behaves just like Fedora. The instructions
> for Arch for building a custom kernel are great except they generalize
> the bootloader instructions, so you need to know what to do at the end
> to add the grub boot entries, if using grub for example, and I suspect
> that may be where the confusion came from, though I don't know. I'm
> trying to get one of the two to reproduce my results to confirm and at
> least get them a workaround.
>
> I have slackware on another thumb drive already, but I have yet to
> even get it updated to 6.1.8.
>
> If any of them behave differently I was hoping to tease out whether
> it's firmware, kernel config, or something else, but so far the first
> has been more of the same.
>
> > Thanks,
> > Amadeusz
> >
> > >
> > > On Wed, Feb 1, 2023 at 9:33 AM Jason Montleon <jmontleo@redhat.com> w=
rote:
> > >>
> > >> On Wed, Feb 1, 2023 at 6:05 AM Amadeusz S=C5=82awi=C5=84ski
> > >> <amadeuszx.slawinski@linux.intel.com> wrote:
> > >>>
> > >>> On 1/31/2023 4:16 PM, Jason Montleon wrote:
> > >>>> On Tue, Jan 31, 2023 at 7:37 AM Cezary Rojewski
> > >>>> <cezary.rojewski@intel.com> wrote:
> > >>>>>
> > >>>>> On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:
> > >>>>>
> > >>>>>> Dear Czarek, many thanks for the answer and taking care of it. I=
f
> > >>>>>> needed something from my side please jest let me know
> > >>>>>> and I will try to do it.
> > >>>>>
> > >>>>>
> > >>>>> Hello Sasa,
> > >>>>>
> > >>>>> Could you provide us with the topology and firmware binary presen=
t on
> > >>>>> your machine?
> > >>>>>
> > >>>>> Audio topology is located at /lib/firmware and named:
> > >>>>>
> > >>>>> 9d71-GOOGLE-EVEMAX-0-tplg.bin
> > >>>>> -or-
> > >>>>> dfw_sst.bin
> > >>>>>
> > >>>>> Firmware on the other hand is found in /lib/firmware/intel/.
> > >>>>> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing t=
o an
> > >>>>> actual AudioDSP firmware binary.
> > >>>>>
> > >>>> Maybe this is the problem.
> > >>>>
> > >>>> I think most of us are pulling the topology and firmware from the
> > >>>> chromeos recovery images for lack of any other known source, and i=
t
> > >>>> looks a little different than this. Those can be downloaded like s=
o:
> > >>>> https://gist.github.com/jmontleon/8899cb83138f2653f520fbbcc5b830a0
> > >>>>
> > >>>> After placing the topology file you'll see these errors and audio =
will
> > >>>> not work until they're also copied in place.
> > >>>> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> > >>>> dsp_lib_dsm_core_spt_release.bin failed with error -2
> > >>>> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> > >>>> intel/dsp_fw_C75061F3-F2B2-4DCC-8F9F-82ABB4131E66.bin failed with
> > >>>> error -2
> > >>>>
> > >>>> Once those were in place, up to 6.0.18 audio worked.
> > >>>>
> > >>>> Is there a better source for the topology file?
> > >>>>
> > >>>>> The reasoning for these asks is fact that problem stopped reprodu=
cing on
> > >>>>> our end once we started playing with kernel versions (moved away =
from
> > >>>>> status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP.
> > >>>>> However, we might be using newer configuration files when compare=
d to
> > >>>>> equivalent of yours.
> > >>>>>
> > >>>>> Recent v6.2-rc5 broonie/sound/for-next - no repro
> > >>>>> Our internal tree based on Mark's for-next - no repro
> > >>>>> 6.1.7 stable [1] - no repro
> > >>>>>
> > >>>>> Of course we will continue with our attempts. Will notify about t=
he
> > >>>>> progress.
> > >>>>>
> > >>>>>
> > >>>>> [1]:
> > >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/=
commit/?h=3Dv6.1.7&id=3D21e996306a6afaae88295858de0ffb8955173a15
> > >>>>>
> > >>>>>
> > >>>>> Kind regards,
> > >>>>> Czarek
> > >>>>>
> > >>>>
> > >>>>
> > >>>
> > >>> Hi Jason,
> > >>>
> > >>> as I understand you've tried to do bisect, can you instead try buil=
ding
> > >>> kernels checking out following tags:
> > >>> v6.1      v6.1.1    v6.1.2    v6.1.3    v6.1.4    v6.1.5    v6.1.6
> > >>> v6.1.7    v6.1.8
> > >>> and report when it stops working, so it narrows scope of what we lo=
ok
> > >>> at? I assume that kernel builds are done using upstream stable kern=
el
> > >>> (from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.=
git/).
> > >>>
> > >>> Thanks,
> > >>> Amadeusz
> > >>>
> > >> Hi Amadeusz,
> > >> Yes, I did the bisects using
> > >> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
> > >>
> > >> The only thing I did to these was add
> > >> 392cc13c5ec72ccd6bbfb1bc2339502cc59dd285, otherwise audio breaks wit=
h
> > >> the dai not registered error message in dmesg from the rt5514 bug fr=
om
> > >> 6.0 and up. It wasn't added to 6.1 until rc6, I believe. If there's =
a
> > >> better way to work around the multiple bugs I can try again, otherwi=
se
> > >> I will start working on builds from tags and see if I learn anything=
.
> > >>
> > >> FWIW, I've seen two people complain that Arch isn't working either
> > >> since it moved to 6.1. For the one who was trying, patching out the
> > >> commit I came to with the first bisect did not regain them sound lik=
e
> > >> it did for me. And yet Sasa reports Slackware is mostly working for
> > >> him with 6.1.8 on Slackware. I don't know what to make of it, but
> > >> thought I'd share in case it helps point someone else to something.
> > >> https://github.com/jmontleon/pixelbook-fedora/issues/51#issuecomment=
-1410222840
> > >> https://github.com/jmontleon/pixelbook-fedora/issues/51#issuecomment=
-1410673371
> > >> https://github.com/jmontleon/pixelbook-fedora/issues/53#issuecomment=
-1408699252
> > >>
> > >> Probably less relevant since they aren't from upstream and I know th=
ey
> > >> don't mean as much, but I have tried 6.1.5-6.1.8 Fedora packages for
> > >> certain, and went back trying several others from koji back into rc
> > >> builds, although using prebuilt kernels, anything before 6.1-rc6 won=
't
> > >> work, as mentioned above. Nothing worked. But as I said I'll build
> > >> from tags and see if I can learn anything.
> > >>
> > >> Thank you,
> > >> Jason Montleon
> > >>
> > >> --
> > >> Jason Montleon        | email: jmontleo@redhat.com
> > >> Red Hat, Inc.         | gpg key: 0x069E3022
> > >> Cell: 508-496-0663    | irc: jmontleo / jmontleon
> > >
> > >
> > >
> >
>
>
> --
> Jason Montleon        | email: jmontleo@redhat.com
> Red Hat, Inc.         | gpg key: 0x069E3022
> Cell: 508-496-0663    | irc: jmontleo / jmontleon



--=20
Jason Montleon        | email: jmontleo@redhat.com
Red Hat, Inc.         | gpg key: 0x069E3022
Cell: 508-496-0663    | irc: jmontleo / jmontleon

