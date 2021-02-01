Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5330A0D4
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 05:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhBAEZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 23:25:56 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:16636 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhBAEZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 23:25:50 -0500
Date:   Mon, 01 Feb 2021 04:24:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1612153500;
        bh=Zb7ULZT7e66rly2USppGm7Xzx2fnacIRQRjSbtzMRNk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QJps2d/UT/K6V3FVJKgq1sL2ySKj1557bsXooFjaT12HgN74NcR8/GcQB3MzcHU7U
         IUJzePEIXuxL8YmxCFCAtcMdrAUu0dIM8JJhCyXprRdUFPbaaASmT0VKuL7dsVgPqd
         117T2VTY7KWM1gNW/nZF3aOy0HD/uOpGrvxqOIgY=
To:     Takashi Iwai <tiwai@suse.de>
From:   Erich Ritz <erich.public@protonmail.com>
Cc:     Michael Catanzaro <mcatanzaro@redhat.com>,
        "N, Harshapriya" <harshapriya.n@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kai.vehmanen@intel.com" <kai.vehmanen@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Reply-To: Erich Ritz <erich.public@protonmail.com>
Subject: Re: [REGRESSION] "ALSA: HDA: Early Forbid of runtime PM" broke my laptop's internal audio
Message-ID: <CJr5txskJyVLQIDd7L6WNNMBMJ3eQEltNH7Y_yJ_r2X8aflHnfGHT9_Mpuznx8iDgfAu03gs9aIqVO7gXbRp4WCL--tXZAUajwyo_Eet5Os=@protonmail.com>
In-Reply-To: <s5hft2jlnt4.wl-tiwai@suse.de>
References: <EM1ONQ.OL5CFJTBEBBW@redhat.com> <BY5PR11MB430713319F12454CF71A1E73FDB99@BY5PR11MB4307.namprd11.prod.outlook.com> <U3BPNQ.P8Q6LYEGXHB5@redhat.com> <s5hsg6jlr4q.wl-tiwai@suse.de> <9ACPNQ.AF32G3OJNPHA3@redhat.com> <IECPNQ.0TZXZXWOZX8L2@redhat.com> <8CEPNQ.GAG87LR8RI871@redhat.com> <s5hft2jlnt4.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, January 29, 2021 9:17 AM, Takashi Iwai <tiwai@suse.de> wrote:

> On Fri, 29 Jan 2021 17:12:08 +0100,
> Michael Catanzaro wrote:
>
> > On Fri, Jan 29, 2021 at 9:30 am, Michael Catanzaro
> > mcatanzaro@redhat.com wrote:
> >
> > > OK, I found "ALSA: hda/via: Apply the workaround generically for
> > > Clevo machines" which was just merged yesterday. So I will test
> > > again to find out.
> >
> > Hi Takashi, hi Harsha,
> > I can confirm that the problem is fixed by this commit:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D4961167bf7482944ca09a6f71263b9e47f949851
>
> Thanks, good to hear.
>
> Then I think we can drop the entry from power_save_denylist in
> hda_intel.c. Could you try that it still works with the patch below?
>
> thanks,
>
> Takashi
>
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -2217,8 +2217,6 @@ static const struct snd_pci_quirk power_save_denyli=
st[] =3D {
> /* https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 /
> SND_PCI_QUIRK(0x1043, 0x8733, "Asus Prime X370-Pro", 0),
> / https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 */
>
> -   SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
> -   /* https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 /
>     SND_PCI_QUIRK(0x1028, 0x0497, "Dell Precision T3600", 0),
>     / https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 /
>     / Note the P55A-UD3 and Z87-D3HP share the subsys id for the HDA dev =
*/

For me applying patch 4961167bf7482944ca09a6f71263b9e47f949851 on top of 5.=
10.12 fixes audio, but the above quoted patch applied to 5.10.12 does NOT f=
ix audio.  What I mean by fixes:
Audio works normally on 5.4.94, and on 5.10.12 with patch 4961167 applied.
I hear no audio from the laptop speakers on 5.10.12 and 5.10.12 with the ab=
ove quoted patch applied.  Opening pavucontrol shows a graphical response i=
n the meter, but no audio is heard from the speakers.  I did not test plugg=
ing in headphones and did not test audio over HDMI.

I have a System76 Gazelle Pro 7 (gazp7).

# lspci -s "00:1b" -vv
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family=
 High Definition Audio Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer 7 Series/C210 Series Chipset Family=
 High Definition Audio Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 36
        Region 0: Memory at f7e10000 (64-bit, non-prefetchable) [size=3D16K=
]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D=
2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee003b8  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, M=
SI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tr=
ansPend-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTra=
ns-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR25=
6-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTra=
ns-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR25=
6-
                        Ctrl:   Enable+ ID=3D1 ArbSelect=3DFixed TC/VC=3D22
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=3D0f ComponentID=3D00 EltType=3DConfig
                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D00 AssocR=
CRB- LinkType=3DMemMapped LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

And on kernel 5.4.94:
# dmesg | grep hda
[   21.307684] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_aud=
io_component_bind_ops [i915])
[   21.493303] snd_hda_codec_via hdaudioC0D0: autoconfig for VT1802: line_o=
uts=3D1 (0x24/0x0/0x0/0x0/0x0) type:speaker
[   21.493306] snd_hda_codec_via hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/=
0x0/0x0/0x0)
[   21.493309] snd_hda_codec_via hdaudioC0D0:    hp_outs=3D1 (0x25/0x0/0x0/=
0x0/0x0)
[   21.493310] snd_hda_codec_via hdaudioC0D0:    mono: mono_out=3D0x0
[   21.493312] snd_hda_codec_via hdaudioC0D0:    inputs:
[   21.493315] snd_hda_codec_via hdaudioC0D0:      Mic=3D0x2b
[   21.493317] snd_hda_codec_via hdaudioC0D0:      Internal Mic=3D0x29


Apologies if this is noise.  I haven't been able to find if 4961167bf748294=
4ca09a6f71263b9e47f949851 is queued up for the next stable release of 5.10.

Erich
