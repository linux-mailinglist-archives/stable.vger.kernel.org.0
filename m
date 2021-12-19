Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C77D479F33
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 06:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhLSFB6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Dec 2021 00:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhLSFB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 00:01:58 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2213DC061574;
        Sat, 18 Dec 2021 21:01:57 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1myoKY-0000mq-Kt; Sun, 19 Dec 2021 06:01:54 +0100
Message-ID: <f1ea22d3-cff8-406a-ad6a-cb8e0124a9b4@leemhuis.info>
Date:   Sun, 19 Dec 2021 06:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     kvm@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     doc@lame.org
Subject: [regression] kvm: Kernel OOPS in vmx.c when starting a kvm VM since
 v5.15.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639890117;9ad8891b;
X-HE-SMSGID: 1myoKY-0000mq-Kt
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

TWIMC, I stumbled on a bug report from George Shearer about a KVM
problem I couldn't find any further discussions about, that's why I'm
forwarding it manually here.

https://bugzilla.kernel.org/show_bug.cgi?id=215351

George, BTW: if reverting the change you suspect doesn't help, please
consider doing a bisection to find the culprit.

> KVM stopped working on two of my x86_64 systems as of version 5.15.7. Downgrading to 5.15.6 resolves all issues with no other changes.
> 
> Attemping to boot kvm produces:
> kvm_set_irq: Input/output error
> 
> kernel log:
> [ 1270.750295] ------------[ cut here ]------------
> [ 1270.750301] WARNING: CPU: 10 PID: 2523 at arch/x86/kvm/vmx/vmx.c:6247 vmx_sync_pir_to_irr+0x3a/0x120 [kvm_intel]
> [ 1270.750326] Modules linked in: tun bridge stp nct6775 llc hwmon_vid intel_rapl_msr intel_rapl_common iTCO_wdt intel_pmc_bxt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp intel_wmi_thunderbolt mxm_wmi coretemp kvm_intel kvm rapl intel_cstate intel_uncore raid0 snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi md_mod lpc_ich snd_hda_intel i2c_i801 i2c_smbus snd_intel_dspcfg snd_intel_sdw_acpi wacom snd_usb_audio snd_hda_codec uvcvideo snd_usbmidi_lib snd_rawmidi snd_hda_core videobuf2_vmalloc snd_hwdep snd_seq_device videobuf2_memops snd_pcm mousedev nvidia_drm(POE) videobuf2_v4l2 nvidia_modeset(POE) snd_timer joydev videobuf2_common e1000e snd mei_me soundcore mei wmi v4l2loopback(OE) videodev mc nvidia_uvm(POE) nvidia(POE) mac_hid crypto_user fuse ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted asn1_encoder tee tpm rng_core usbhid dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> [ 1270.750432]  aesni_intel crypto_simd cryptd sr_mod xhci_pci cdrom xhci_pci_renesas vfio_pci vfio_pci_core irqbypass vfio_virqfd vfio_iommu_type1 vfio vfat fat nls_iso8859_1
> [ 1270.750454] CPU: 10 PID: 2523 Comm: qemu-system-x86 Tainted: P           OE     5.15.10-arch1-1 #1 bbe3990b16b2d76240a936ebf8dc5ba666258542
> [ 1270.750460] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X99 Extreme4, BIOS P3.80 04/06/2018
> [ 1270.750463] RIP: 0010:vmx_sync_pir_to_irr+0x3a/0x120 [kvm_intel]
> [ 1270.750478] Code: 04 25 28 00 00 00 48 89 44 24 08 31 c0 80 3d fc fb 09 ff 00 c7 44 24 04 00 00 00 00 75 47 48 8b 07 80 b8 04 c2 00 00 00 75 16 <0f> 0b 48 8b 3f be 04 03 00 00 c6 87 04 c2 00 00 01 e8 d0 71 fe fe
> [ 1270.750481] RSP: 0018:ffffb57a43b6b9e0 EFLAGS: 00010246
> [ 1270.750485] RAX: ffffb57a43f45000 RBX: ffffa03e3283c000 RCX: 0000000000000000
> [ 1270.750488] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa03e3283c000
> [ 1270.750491] RBP: ffffa03dca000000 R08: 0000000000000000 R09: 0000000000000000
> [ 1270.750493] R10: 0000000000000000 R11: 0000000000000000 R12: ffffb57a43b6bb40
> [ 1270.750495] R13: ffffb57a43b6bb88 R14: 00007f9199ddb120 R15: ffffa03e3283c000
> [ 1270.750499] FS:  00007f9199ddc640(0000) GS:ffffa05cdfc80000(0000) knlGS:0000000000000000
> [ 1270.750502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1270.750505] CR2: 000056523dccf000 CR3: 0000000105e84006 CR4: 00000000003726e0
> [ 1270.750508] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1270.750511] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1270.750513] Call Trace:
> [ 1270.750517]  <TASK>
> [ 1270.750521]  kvm_arch_vcpu_ioctl+0xcd6/0x1560 [kvm 97b295b32edb47f6953359c3801fec0571c9fadd]
> [ 1270.750631]  kvm_vcpu_ioctl+0x42e/0x6e0 [kvm 97b295b32edb47f6953359c3801fec0571c9fadd]
> [ 1270.750694]  ? syscall_exit_to_user_mode+0x23/0x50
> [ 1270.750702]  ? __fget_files+0x9c/0xd0
> [ 1270.750712]  __x64_sys_ioctl+0x8b/0xd0
> [ 1270.750717]  do_syscall_64+0x59/0x90
> [ 1270.750721]  ? syscall_exit_to_user_mode+0x23/0x50
> [ 1270.750727]  ? do_syscall_64+0x69/0x90
> [ 1270.750730]  ? do_syscall_64+0x69/0x90
> [ 1270.750733]  ? do_syscall_64+0x69/0x90
> [ 1270.750736]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1270.750744] RIP: 0033:0x7f919d2b859b
> [ 1270.750748] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a5 a8 0c 00 f7 d8 64 89 01 48
> [ 1270.750751] RSP: 002b:00007f9199ddb078 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 1270.750756] RAX: ffffffffffffffda RBX: 000000008400ae8e RCX: 00007f919d2b859b
> [ 1270.750759] RDX: 00007f9199ddb120 RSI: ffffffff8400ae8e RDI: 0000000000000019
> [ 1270.750782] RBP: 000056523db2db60 R08: 000056523cb2eac4 R09: 000056523cb2ea24
> [ 1270.750785] R10: 000056523cb2e8c0 R11: 0000000000000246 R12: 00007f9199ddb120
> [ 1270.750787] R13: 000000aa00000000 R14: 0000005500000000 R15: 000fff0000000000
> [ 1270.750793]  </TASK>
> [ 1270.750795] ---[ end trace e0f3b79e15ad0008 ]---
> 
> $ cat /proc/cmdline 
> quiet splash vga=current nomodeset loglevel=0 rd.systemd.show_status=false rd.udev.log_priority=0 intremap=no_x2apic_optout mitigations=off root=/dev/vg00/root rw rootfstype=ext4 add_efi_memmap initrd=EFI\arch\intel-ucode.img initrd=EFI\arch\initramfs.img init=/usr/lib/systemd/systemd intel_iommu=on iommu=pt rd.luks.uuid=f863c926-fd06-4135-841b-a825f6aacb25 rd.luks.options=discard
> 
> $ cat /etc/modprobe.d/kvm.conf 
> options kvm ignore_msrs=1
> options kvm-intel nested=y ept=y enable_apicv=n
> 
> NOTE-- if I change that enable_apicv to 'y' -- my kvm instance boots but hangs when attempting to access SRV-IO PCI-E GPU.
> 
> $ grep 'model name' /proc/cpuinfo |head -1; uname -a
> model name	: Intel(R) Core(TM) i7-6800K CPU @ 3.40GHz
> Linux docslinuxbox 5.15.10-arch1-1 #1 SMP PREEMPT Fri, 17 Dec 2021 11:17:37 +0000 x86_64 GNU/Linux
> 
> $ free
>                total        used        free      shared  buff/cache   available
> Mem:       132031320    19011304   110854572      110980     2165444   110007200
> Swap:       16777212           0    16777212

> I believe this problem has something to do with this work:
> 
> https://www.spinics.net/lists/stable/msg519358.html

> (In reply to Thorsten Leemhuis from comment #3)
>> Hi, this is your Linux kernel regression tracker speaking.
>> 
>> 5.15.10 is out and contains a fix for a KVM issue. Could you give it a try?
>> If not, we should bring the report to the mailing lists, as outlined in 
>> https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
>> 
>> And btw: have you tried to revert the change you pointed to above to see if
>> it fixes the problem?
> 
> Yes, the problem persist in 5.15.10, here's a fresh cut/paste:
> 
> [  137.123571] ------------[ cut here ]------------
> [  137.123575] WARNING: CPU: 1 PID: 3606 at arch/x86/kvm/vmx/vmx.c:6247 vmx_sync_pir_to_irr+0x3a/0x120 [kvm_intel]
> [  137.123587] Modules linked in: tun rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc fscache netfs intel_rapl_msr intel_rapl_common bridge stp nct6775 llc hwmon_vid iTCO_wdt intel_pmc_bxt iTCO_vendor_support x86_pkg_temp_thermal intel_wmi_thunderbolt mxm_wmi intel_powerclamp coretemp kvm_intel kvm rapl intel_cstate snd_hda_codec_realtek intel_uncore raid0 snd_hda_codec_generic snd_hda_codec_hdmi ledtrig_audio md_mod snd_hda_intel i2c_i801 snd_intel_dspcfg lpc_ich i2c_smbus e1000e snd_intel_sdw_acpi snd_usb_audio snd_hda_codec wacom snd_hda_core uvcvideo snd_usbmidi_lib videobuf2_vmalloc videobuf2_memops snd_rawmidi snd_hwdep nvidia_drm(POE) videobuf2_v4l2 snd_seq_device mousedev nvidia_modeset(POE) joydev videobuf2_common snd_pcm snd_timer snd mei_me soundcore mei wmi v4l2loopback(OE) videodev mc nvidia_uvm(POE) nvidia(POE) mac_hid crypto_user fuse ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted asn1_encoder tee tpm
> [  137.123628]  rng_core usbhid dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd sr_mod xhci_pci cdrom xhci_pci_renesas vfio_pci vfio_pci_core irqbypass vfio_virqfd vfio_iommu_type1 vfio vfat fat nls_iso8859_1
> [  137.123639] CPU: 1 PID: 3606 Comm: qemu-system-x86 Tainted: P           OE     5.15.10-arch1-1 #1 bbe3990b16b2d76240a936ebf8dc5ba666258542
> [  137.123642] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X99 Extreme4, BIOS P3.80 04/06/2018
> [  137.123643] RIP: 0010:vmx_sync_pir_to_irr+0x3a/0x120 [kvm_intel]
> [  137.123648] Code: 04 25 28 00 00 00 48 89 44 24 08 31 c0 80 3d fc 4b 15 00 00 c7 44 24 04 00 00 00 00 75 47 48 8b 07 80 b8 04 c2 00 00 00 75 16 <0f> 0b 48 8b 3f be 04 03 00 00 c6 87 04 c2 00 00 01 e8 d0 c1 09 00
> [  137.123649] RSP: 0018:ffffbb63c3cbf978 EFLAGS: 00010246
> [  137.123650] RAX: ffffbb63c3d21000 RBX: ffff9597a7258000 RCX: 0000000000000000
> [  137.123651] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9597a7258000
> [  137.123652] RBP: ffff95970f04ec00 R08: 0000000000000000 R09: 0000000000000000
> [  137.123653] R10: 0000000000000000 R11: 0000000000000000 R12: ffffbb63c3cbfad8
> [  137.123654] R13: ffffbb63c3cbfb20 R14: 00007f4742c99120 R15: ffff9597a7258000
> [  137.123655] FS:  00007f4742c9a640(0000) GS:ffff95b61fa40000(0000) knlGS:0000000000000000
> [  137.123656] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  137.123657] CR2: 00007fd7827d0000 CR3: 0000000122638002 CR4: 00000000003726e0
> [  137.123658] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  137.123659] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  137.123659] Call Trace:
> [  137.123661]  <TASK>
> [  137.123663]  kvm_arch_vcpu_ioctl+0xcd6/0x1560 [kvm 97b295b32edb47f6953359c3801fec0571c9fadd]
> [  137.123712]  kvm_vcpu_ioctl+0x42e/0x6e0 [kvm 97b295b32edb47f6953359c3801fec0571c9fadd]
> [  137.123732]  ? syscall_exit_to_user_mode+0x23/0x50
> [  137.123736]  ? __fget_files+0x9c/0xd0
> [  137.123741]  __x64_sys_ioctl+0x8b/0xd0
> [  137.123743]  do_syscall_64+0x59/0x90
> [  137.123744]  ? syscall_exit_to_user_mode+0x23/0x50
> [  137.123746]  ? do_syscall_64+0x69/0x90
> [  137.123747]  ? syscall_exit_to_user_mode+0x23/0x50
> [  137.123749]  ? do_syscall_64+0x69/0x90
> [  137.123750]  ? syscall_exit_to_user_mode+0x23/0x50
> [  137.123751]  ? do_syscall_64+0x69/0x90
> [  137.123752]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  137.123755] RIP: 0033:0x7f474a17959b
> [  137.123757] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a5 a8 0c 00 f7 d8 64 89 01 48
> [  137.123758] RSP: 002b:00007f4742c99078 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  137.123759] RAX: ffffffffffffffda RBX: 000000008400ae8e RCX: 00007f474a17959b
> [  137.123760] RDX: 00007f4742c99120 RSI: ffffffff8400ae8e RDI: 0000000000000019
> [  137.123761] RBP: 0000561c10142b60 R08: 0000561c0dbe5ac4 R09: 0000561c0dbe5a24
> [  137.123762] R10: 0000561c0dbe58c0 R11: 0000000000000246 R12: 00007f4742c99120
> [  137.123762] R13: 000000aa00000000 R14: 0000005500000000 R15: 000fff0000000000
> [  137.123765]  </TASK>
> [  137.123765] ---[ end trace 356a4adaddf3d772 ]---
> 
> 
> I haven't had time to try to revert the change as these are both production systems and will require downtime. Maybe Sunday.

[TLDR: I'm adding this regression to regzbot, the Linux kernel
regression tracking bot; most text you find below is compiled from a few
templates paragraphs some of you might have seen already.]

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot introduced v5.15.6..v5.15.7
#regzbot title Kernel OOPS in vmx.c when starting a kvm VM
#regzbot ignore-activity

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail) using the kernel.org redirector,
as explained in 'Documentation/process/submitting-patches.rst'. Regzbot
then will automatically mark the regression as resolved once the fix
lands in the appropriate tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave thus might sent someone reading this down the wrong
rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c
