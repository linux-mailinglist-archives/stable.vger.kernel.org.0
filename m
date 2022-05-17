Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A339052A966
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351499AbiEQRhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 13:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244701AbiEQRhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 13:37:52 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA901FA5D
        for <stable@vger.kernel.org>; Tue, 17 May 2022 10:37:49 -0700 (PDT)
Received: from zimbra40-e7.priv.proxad.net (unknown [172.20.243.190])
        by smtp4-g21.free.fr (Postfix) with ESMTP id 7E87C19F576;
        Tue, 17 May 2022 19:37:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652809067;
        bh=TZqymf6Fd0z2ivb0cBfCy0zOSgkDFTXQcOSDDRiVibM=;
        h=Date:From:To:Cc:In-Reply-To:Subject:From;
        b=CkLfvW7GgomDB47WfuLCCAhZDho4VCa5zijqAeeJSStG0weiHALwh8ZotXGKIe4YV
         3UeD6nx4b/oiqbNI7BuZEXuRRj9+74CPFwuur19RL4tJja5DG3VQ7FEHnBqe8P7FeW
         w+0C1EAtAEIW+C+PKVytGxeysbqO2RyczvCLfEPypiMYeikQAvdyB65ys5i/Ne2Oc+
         sKAsPk2+iDnItqPW78NsNMdfJ1Wsev3dLArwI/A+lWWMVMHDs7czYg60YyYehRjwyv
         uFCH5CkiePnwxtT0tI7zvDSWEd+eH7lLrDMuRni6WfSuaTwo5wutgggru2xnxd2nhe
         jFi1POdX+zNVQ==
Date:   Tue, 17 May 2022 19:37:46 +0200 (CEST)
From:   casteyde.christian@free.fr
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Message-ID: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
In-Reply-To: <CAAd53p7Sw+EAjn2fH++g7dQaAHxzTqdN81f6xNVKy4hqCWgztw@mail.gmail.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video
 since 5.17.4 (works 5.17.3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [82.65.8.64]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - FF3.0 (Linux)/7.2.0-GA2598)
X-Authenticated-User: casteyde.christian@free.fr
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HEXHASH_WORD,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da ("drm/=
amdgpu: Ensure HDA function is suspended before ASIC reset"), and the probl=
em disappears so it's really this commit that breaks.

Following are dmesg for 5.18-rc7:
- when it fails (dmesg-bad.txt);
- when it works (dmesg-good.txt).

CC

----- Mail original -----
De: "Kai-Heng Feng" <kai.heng.feng@canonical.com>
=C3=80: "Christian Casteyde" <casteyde.christian@free.fr>
Cc: stable@vger.kernel.org, "Thorsten Leemhuis" <regressions@leemhuis.info>=
, regressions@lists.linux.dev, "alexander deucher" <alexander.deucher@amd.c=
om>, gregkh@linuxfoundation.org, "Mario Limonciello" <mario.limonciello@amd=
.com>
Envoy=C3=A9: Mardi 17 Mai 2022 08:58:30
Objet: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since=
 5.17.4 (works 5.17.3)

On Tue, May 17, 2022 at 2:36 PM Christian Casteyde
<casteyde.christian@free.fr> wrote:
>
> No, the problem is there even without acpicall. Fyi I use it to shutdown =
the NVidia card that eats the battery otherwise.
>
> I managed to get a dmesg output with 2.18rc7 I will post it this evening =
(basically exact same behavior as 2.17.4).

Can you please also attach dmesg without the offending commit (i.e.
when it's working)?

Kai-Heng

>
> CC
>
> =E2=81=A3T=C3=A9l=C3=A9charger BlueMail pour Android
>
> Le 17 mai 2022 =C3=A0 04:03, =C3=A0 04:03, Kai-Heng Feng <kai.heng.feng@c=
anonical.com> a =C3=A9crit:
> >On Tue, May 17, 2022 at 1:23 AM Christian Casteyde
> ><casteyde.christian@free.fr> wrote:
> >>
> >> I've tried with 5.18-rc7, it doesn't work either. I guess 5.18 branch
> >have all
> >> commits.
> >>
> >> full dmesg appended (not for 5.18, I didn't manage to resume up to
> >the point
> >> to get a console for now).
> >
> >Interestingly, I found you are using acpi_call:
> >[   30.667348] acpi_call: loading out-of-tree module taints kernel.
> >
> >Does removing the acpi_call solve the issue?
> >
> >Kai-Heng
> >
> >>
> >> CC
> >>
> >> Le lundi 16 mai 2022, 04:47:25 CEST Kai-Heng Feng a =C3=A9crit :
> >> > [+Cc Mario]
> >> >
> >> > On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
> >> >
> >> > <casteyde.christian@free.fr> wrote:
> >> > > I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
> >> > > This does not fix the problem on my laptop.
> >> >
> >> > Maybe some commits are still missing?
> >> >
> >> > > For informatio, here is a part of the log around the suspend
> >process:
> >> > Is it possible to attach full dmesg?
> >> >
> >> > Kai-Heng
> >> >
> >> > > May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can't
> >change
> >> > > power state from D3cold to D0 (config space inaccessible)
> >> > > May 14 19:21:41 geek500 kernel: PM: late suspend of devices
> >failed
> >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> >]------------
> >> > > May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03:
> >Transfer while
> >> > > suspended
> >> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive
> >routing for
> >> > > PCI INT A
> >> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
> >GSI
> >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at
> >drivers/i2c/
> >> > > busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
> >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> >unloaded:
> >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm:
> >> > > kworker/u32:18 Tainted: G           O      5.17.7+ #7
> >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> >Gaming
> >> > > Laptop
> >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> >> > > May 14 19:21:41 geek500 kernel: Workqueue: events_unbound
> >> > > async_run_entry_fn May 14 19:21:41 geek500 kernel: RIP:
> >> > > 0010:i2c_dw_xfer+0x3f6/0x440
> >> > > May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b
> >67 50 4d
> >> > > 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
> >> > >
> >> > >  ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc ff
> >ff e9 2d
> >> > >  9c>
> >> > > 4b 00 83 f8 01 74
> >> > > May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68
> >EFLAGS:
> >> > > 00010286
> >> > > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> >> > > ffff888540f170e8
> >> > > RCX: 0000000000000be5
> >> > > May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI:
> >> > > 0000000000000086
> >> > > RDI: ffffffffac858df8
> >> > > May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08:
> >> > > ffffffffabe46d60
> >> > > R09: 00000000ac86a0f6
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11:
> >> > > ffffffffffffffff
> >> > > R12: ffff888540f5c070
> >> > > May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14:
> >> > > 00000000ffffff94
> >> > > R15: ffff888540f17028
> >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> >> > > GS:ffff88885f640000(0000) knlGS:0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> > > 0000000080050033
> >> > > May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
> >> > > 0000000045e0c000
> >> > > CR4: 0000000000350ee0
> >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> >> > > May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >newidle_balance.constprop.0+0x1f7/0x3b0
> >> > > May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
> >> > > May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
> >> > > May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
> >> > > May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >acpi_subsys_resume_early+0x50/0x50
> >> > > May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
> >> > > May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
> >> > > May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
> >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >kthread_complete_and_exit+0x20/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> >]---
> >> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00:
> >failed to
> >> > > change power setting.
> >> > > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> >> > > acpi_subsys_resume+0x0/0x50 returns -108
> >> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM:
> >failed
> >> > > to
> >> > > resume async: error -108
> >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
> >> > > [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
> >> > > May 14 19:21:41 geek500 kernel:
> >[drm:amdgpu_device_ip_resume_phase2]
> >> > > *ERROR* resume of IP block <gfx_v9_0> failed -110
> >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> >> > > amdgpu_device_ip_resume failed (-110).
> >> > > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> >> > > pci_pm_resume+0x0/0x120 returns -110
> >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed
> >to resume
> >> > > async: error -110
> >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> >]------------
> >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> >drivers/clk/
> >> > > clk.c:971 clk_core_disable+0x80/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> >unloaded:
> >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> >Gaming
> >> > > Laptop
> >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> >> > > May 14 19:21:41 geek500 kernel: RIP:
> >0010:clk_core_disable+0x80/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
> >00 00 48
> >> > > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d
> >87 c4
> >> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
> >0f a3 05
> >> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
> >0018:ffff8dbfc1c47d50
> >> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel:
> >> > > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> >> > > ffff8885401b6300
> >> > > RCX: 0000000000000027
> >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> >> > > 0000000000000001
> >> > > RDI: ffff88885f59f460
> >> > > May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08:
> >> > > ffffffffabf26da8
> >> > > R09: 00000000ffffdfff
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> >> > > ffffffffabe46dc0
> >> > > R12: ffff8885401b6300
> >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> >> > > 0000000000000008
> >> > > R15: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> > > 0000000080050033
> >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> >> > > 0000000102956000
> >> > > CR4: 0000000000350ee0
> >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> >> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> >> > > May 14 19:21:41 geek500 kernel:
> >acpi_subsys_runtime_suspend+0x9/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >kthread_complete_and_exit+0x20/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> >]---
> >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> >]------------
> >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> >drivers/clk/
> >> > > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> >unloaded:
> >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> >Gaming
> >> > > Laptop
> >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> >> > > May 14 19:21:41 geek500 kernel: RIP:
> >0010:clk_core_unprepare+0xb1/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
> >85 db 74
> >> > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
> >87 c4
> >> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
> >a3 05 ea
> >> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
> >0018:ffff8dbfc1c47d60
> >> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
> >0000000000000000
> >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> >> > > 0000000000000001
> >> > > RDI: ffff88885f59f460
> >> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> >> > > ffffffffabf26da8
> >> > > R09: 00000000ffffdfff
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> >> > > ffffffffabe46dc0
> >> > > R12: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> >> > > 0000000000000008
> >> > > R15: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> > > 0000000080050033
> >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> >> > > 0000000102956000
> >> > > CR4: 0000000000350ee0
> >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> >> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> >> > > May 14 19:21:41 geek500 kernel:
> >acpi_subsys_runtime_suspend+0x9/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel: done.
> >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >kthread_complete_and_exit+0x20/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> >]---
> >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> >]------------
> >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> >drivers/clk/
> >> > > clk.c:971 clk_core_disable+0x80/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> >unloaded:
> >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> >Gaming
> >> > > Laptop
> >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> >> > > May 14 19:21:41 geek500 kernel: RIP:
> >0010:clk_core_disable+0x80/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
> >00 00 48
> >> > > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d
> >87 c4
> >> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
> >0f a3 05
> >> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
> >0018:ffff8dbfc1c47d50
> >> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel: RAX:
> >0000000000000000
> >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> >> > > 0000000000000001
> >> > > RDI: ffff88885f59f460
> >> > > May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08:
> >> > > ffffffffabf26da8
> >> > > R09: 00000000ffffdfff
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> >> > > ffffffffabe46dc0
> >> > > R12: ffff8885401b6300
> >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> >> > > 0000000000000008
> >> > > R15: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> > > 0000000080050033
> >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> >> > > 0000000102956000
> >> > > CR4: 0000000000350ee0
> >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> >> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> >> > > May 14 19:21:41 geek500 kernel:
> >acpi_subsys_runtime_suspend+0x9/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >kthread_complete_and_exit+0x20/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> >]---
> >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> >]------------
> >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> >drivers/clk/
> >> > > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> >unloaded:
> >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> >Gaming
> >> > > Laptop
> >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> >> > > May 14 19:21:41 geek500 kernel: RIP:
> >0010:clk_core_unprepare+0xb1/0x1a0
> >> > > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
> >85 db 74
> >> > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
> >87 c4
> >> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
> >a3 05 ea
> >> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
> >0018:ffff8dbfc1c47d60
> >> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
> >0000000000000000
> >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> >> > > 0000000000000001
> >> > > RDI: ffff88885f59f460
> >> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> >> > > ffffffffabf26da8
> >> > > R09: 00000000ffffdfff
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> >> > > ffffffffabe46dc0
> >> > > R12: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> >> > > 0000000000000008
> >> > > R15: 0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> > > 0000000080050033
> >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> >> > > 0000000102956000
> >> > > CR4: 0000000000350ee0
> >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> >> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
> >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> >> > > May 14 19:21:41 geek500 kernel:
> >acpi_subsys_runtime_suspend+0x9/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> >> > > May 14 19:21:41 geek500 kernel:  ?
> >kthread_complete_and_exit+0x20/0x20
> >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> >]---
> >> > > May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0:
> >Unable to
> >> > > sync register 0x4f0800. -5
> >> > > May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
> >> > > May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> >Power
> >> > > consumption will be higher as BIOS has not been configured for
> >> > > suspend-to-idle. To use suspend-to-idle change the sleep mode in
> >BIOS
> >> > > setup.
> >> > > May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can't
> >change
> >> > > power state from D3cold to D0 (config space inaccessible)
> >> > > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive
> >routing for
> >> > > PCI INT A
> >> > > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
> >GSI
> >> > > May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command
> >0xfc20 tx
> >> > > timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallback
> >timer
> >> > > expired on ring sdma0
> >> > > May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download fw
> >command
> >> > > failed (-110)
> >> > > May 14 19:21:59 geek500 kernel: done.
> >> > > May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0:
> >Unable to
> >> > > sync register 0x4f0800. -5
> >> > > May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in
> >/etc/dnsmasq.d/
> >> > > dnsmasq-resolv.conf, will retry
> >> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > sdma0
> >> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:02 geek500 last message buffered 2 times
> >> > > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:05 geek500 last message buffered 2 times
> >> > > May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
> >expired on
> >> > > ring sdma0
> >> > > May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > gfx May 14 19:22:06 geek500 last message buffered 1 times
> >> > > ...
> >> > > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > sdma0
> >> > > May 14 19:22:18 geek500 kernel:
> >[drm:amdgpu_dm_atomic_commit_tail] *ERROR*
> >> > > Waiting for fences timed out!
> >> > > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
> >expired on ring
> >> > > sdma0
> >> > >
> >> > > CC
> >> > >
> >> > > Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a =C3=A9cri=
t :
> >> > > > Hi, this is your Linux kernel regression tracker. Thanks for
> >the report.
> >> > > >
> >> > > > On 14.05.22 16:41, Christian Casteyde wrote:
> >> > > > > #regzbot introduced v5.17.3..v5.17.4
> >> > > > > #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
> >> > > >
> >> > > > FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA
> >function is
> >> > > > suspended before ASIC reset") upstream.
> >> > > >
> >> > > > Recently a regression was reported where 887f75cfd0da was
> >suspected as
> >> > > > the culprit:
> >> > > > https://gitlab.freedesktop.org/drm/amd/-/issues/2008
> >> > > >
> >> > > > And a one related to it:
> >> > > > https://gitlab.freedesktop.org/drm/amd/-/issues/1982
> >> > > >
> >> > > > You might want to take a look if what was discussed there might
> >be
> >> > > > related to your problem (I'm not directly involved in any of
> >this, I
> >> > > > don't know the details, it's just that 887f75cfd0da looked
> >familiar to
> >> > > > me). If it is, a fix for these two bugs was committed to master
> >earlier
> >> > > > this week:
> >> > > >
> >> > > >
> >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi
> >> > > > t/?i d=3Da56f445f807b0276
> >> > > >
> >> > > > It will likely be backported to 5.17.y, maybe already in the
> >over-next
> >> > > > release. HTH.
> >> > > >
> >> > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression
> >tracker' hat)
> >> > > >
> >> > > > P.S.: As the Linux kernel's regression tracker I deal with a
> >lot of
> >> > > > reports and sometimes miss something important when writing
> >mails like
> >> > > > this. If that's the case here, don't hesitate to tell me in a
> >public
> >> > > > reply, it's in everyone's interest to set the public record
> >straight.
> >> > > >
> >> > > > > Hello
> >> > > > > Since 5.17.4 my laptop doesn't resume from suspend anymore.
> >At resume,
> >> > > > > symptoms are variable:
> >> > > > > - either the laptop freezes;
> >> > > > > - either the screen keeps blank;
> >> > > > > - either the screen is OK but mouse is frozen;
> >> > > > > - either display lags with several logs in dmesg:
> >> > > > > [  228.275492] [drm] Fence fallback timer expired on ring gfx
> >> > > > > [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
> >Waiting for
> >> > > > > fences timed out!
> >> > > > > [  228.779490] [drm] Fence fallback timer expired on ring gfx
> >> > > > > [  229.283484] [drm] Fence fallback timer expired on ring
> >sdma0
> >> > > > > [  229.283485] [drm] Fence fallback timer expired on ring gfx
> >> > > > > [  229.787487] [drm] Fence fallback timer expired on ring gfx
> >> > > > > ...
> >> > > > >
> >> > > > > I've bisected the problem.
> >> > > > >
> >> > > > > Please note this laptop has a strange behaviour on suspend:
> >> > > > > The first suspend request always fails (this point has never
> >been
> >> > > > > fixed
> >> > > > > and
> >> > > > > plagues us when trying to diagnose another regression on
> >touchpad not
> >> > > > > resuming in the past). The screen goes blank and I can get it
> >OK when
> >> > > > > pressing the power button, this seems to reset it. After that
> >all
> >> > > > > suspend/resume works OK.
> >> > > > >
> >> > > > > Since 5.17.4, it is not possible anymore to get the laptop
> >working
> >> > > > > again
> >> > > > > after the first suspend failure.
> >> > > > >
> >> > > > > HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated +
> >NVidia
> >> > > > > 1650Ti
> >> > > > > (turned off with ACPI call in order to get more battery, I'm
> >not using
> >> > > > > NVidia driver).
> >>
>
