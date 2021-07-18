Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935283CCABD
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhGRVG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 17:06:58 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:55590 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhGRVG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 17:06:57 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id A0E67B3DDCA;
        Sun, 18 Jul 2021 23:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1626642233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3YxVoLczERTUjugGi6wK+E4gG/09EfnBSgLqn9WMb98=;
        b=Aiu27/VlrN8YToAjQ6uuksEVNriJJ2eFy6sBUD+S57Q+xiLltfeERcmGwu9IXpq7nwTdoi
        AqmMmFU5szOP+/s115EwfADw+sWwQI1pi5TMPzq9NKXJg7Ztld9RH+X8lhw87i58iLWu7H
        xRD4/41XkdE0hoVLoVy+eOFZhs2i0mY=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Date:   Sun, 18 Jul 2021 23:03:51 +0200
Message-ID: <6698965.kvI7vG0SvZ@natalenko.name>
In-Reply-To: <2245518.LNIG0phfVR@natalenko.name>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com> <2245518.LNIG0phfVR@natalenko.name>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ stable@vger.kernel.org

On ned=C4=9Ble 18. =C4=8Dervence 2021 23:01:24 CEST Oleksandr Natalenko wro=
te:
> Hello.
>=20
> On sobota 17. =C4=8Dervence 2021 22:22:08 CEST Chris Clayton wrote:
> > I checked the output from dmesg yesterday and found the following warni=
ng:
> >=20
> > [Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
> > [Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at
> > kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0 [Fri Jul
> > 16
> > 09:15:29 2021] Modules linked in: uas hidp rfcomm bnep xt_MASQUERADE
> > iptable_nat nf_nat xt_LOG nf_log_syslog xt_limit xt_multiport xt_conntr=
ack
> > iptable_filter btusb btintel wmi_bmof uvcvideo videobuf2_vmalloc
> > videobuf2_memops videobuf2_v4l2 videobuf2_common coretemp hwmon
> > snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_codec_realtek
> > snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg
> > snd_hda_codec snd_hwdep snd_hda_core i2c_i801 i2c_smbus iwlmvm mac80211
> > iwlwifi i915 mei_me mei cfg80211 intel_lpss_pci intel_lpss wmi
> > nf_conntrack_ftp xt_helper nf_conntrack nf_defrag_ipv4 tun
> > [Fri Jul 16 09:15:29 2021] CPU: 11 PID: 2701 Comm: lpqd Not tainted 5.1=
3.2
> > #1 [Fri Jul 16 09:15:29 2021] Hardware name: Notebook
> >=20
> >   NP50DE_DB                       /NP50DE_DB , BIOS 1.07.04 02/17/2020
> >=20
> > [Fri Jul 16 09:15:29 2021] RIP: 0010:rcu_note_context_switch+0x37/0x3d0
> > [Fri Jul 16 09:15:29 2021] Code: 02 00 e8 ec a0 6c 00 89 c0 65 4c 8b 2c=
 25
> > 00 6d 01 00 48 03 1c c5 80 56 e1 b6 40 84 ed 75 0d 41 8b 95 04 03 00 00=
 85
> > d2 7e 02 <0f> 0b 65 48 8b 04 25 00 6d 01 00 8b 80 04 03 00 00 85 c0 7e =
0a
> > 41 [Fri Jul 16 09:15:29 2021] RSP: 0000:ffffb5d483837c70 EFLAGS: 000100=
02
> > [Fri Jul 16 09:15:29 2021] RAX: 000000000000000b RBX: ffff9b77806e1d80
> > RCX:
> > 0000000000000100 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000001 RSI:
> > ffffffffb6d82ead RDI: ffffffffb6da5e4e [Fri Jul 16 09:15:29 2021] RBP:
> > 0000000000000000 R08: 0000000000000001 R09: 0000000000000000 [Fri Jul 16
> > 09:15:29 2021] R10: 000000067bce4fff R11: 0000000000000000 R12:
> > ffff9b77806e1100 [Fri Jul 16 09:15:29 2021] R13: ffff9b734a833a00 R14:
> > ffff9b734a833a00 R15: 0000000000000000 [Fri Jul 16 09:15:29 2021] FS:
> > 00007fccbfc5fe40(0000) GS:ffff9b77806c0000(0000) knlGS:0000000000000000
> > [Fri Jul 16 09:15:29 2021] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033 [Fri Jul 16 09:15:29 2021] CR2: 00007fccc2db7290 CR3:
> > 00000003fb0b8002 CR4: 00000000007706e0 [Fri Jul 16 09:15:29 2021] PKRU:
> > 55555554
> > [Fri Jul 16 09:15:29 2021] Call Trace:
> > [Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
> > [Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
> > [Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
> > [Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
> > [Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
> > [Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
> > [Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
> > [Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
> > [Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170
> > [Fri Jul 16 09:15:29 2021]  ? find_vma+0x5b/0x70
> > [Fri Jul 16 09:15:29 2021]  exc_page_fault+0x1ab/0x610
> > [Fri Jul 16 09:15:29 2021]  ? fpregs_assert_state_consistent+0x19/0x40
> > [Fri Jul 16 09:15:29 2021]  ? asm_exc_page_fault+0x8/0x30
> > [Fri Jul 16 09:15:29 2021]  asm_exc_page_fault+0x1e/0x30
> > [Fri Jul 16 09:15:29 2021] RIP: 0033:0x7fccc2d3c520
> > [Fri Jul 16 09:15:29 2021] Code: 68 4c 00 00 00 e9 20 fb ff ff ff 25 7a=
 ad
> > 07 00 68 4d 00 00 00 e9 10 fb ff ff ff 25 72 ad 07 00 68 4e 00 00 00 e9=
 00
> > fb ff ff <ff> 25 6a ad 07 00 68 4f 00 00 00 e9 f0 fa ff ff ff 25 62 ad =
07
> > 00 [Fri Jul 16 09:15:29 2021] RSP: 002b:00007ffebd529048 EFLAGS: 000102=
93
> > [Fri Jul 16 09:15:29 2021] RAX: 0000000000000001 RBX: 00007fccc46e2890
> > RCX:
> > 0000000000000010 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000010 RSI:
> > 0000000000000000 RDI: 00007fccc46e2890 [Fri Jul 16 09:15:29 2021] RBP:
> > 000056264f1dd4a0 R08: 000056264f21aba0 R09: 000056264f1f58a0 [Fri Jul 16
> > 09:15:29 2021] R10: 0000000000000007 R11: 0000000000000246 R12:
> > 000056264f21ac00 [Fri Jul 16 09:15:29 2021] R13: 000056264f1e0a30 R14:
> > 00007ffebd529080 R15: 00000000000dd87b [Fri Jul 16 09:15:29 2021] ---[ =
end
> > trace c8b06e067d8b0fc2 ]---
> >=20
> > At the time the warning was issued I was creating a (weekly) backup of =
my
> > linux system (home-brewed based on the guidance from Linux From Scratch=
).
> > My backup routine is completed by copying the archive files (created wi=
th
> > dar) and a directory that contains about 7000 source and binary rpm fil=
es
> > to an external USB drive. I didn't spot the warning until later in the
> > day,
> > so I'm not sure exactly where I was in my backup process.
> >=20
> > I haven't seen this warning before. Consequently, I don;t know how easy
> > (or
> > otherwise) it is to reproduce.
> >=20
> > Let me know if I can provide any additional diagnostics, but please cc =
me
> > as I'm not subscribed.
>=20
> Confirming the same for me with v5.13.2, and cross-referencing another
> report [1] against v5.12.17.
>=20
> Also Cc'ing relevant people on this.
>=20
> Thanks.
>=20
> [1]
> https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=3D_E=
h_1k
> EHLHA@mail.gmail.com/


=2D-=20
Oleksandr Natalenko (post-factum)


