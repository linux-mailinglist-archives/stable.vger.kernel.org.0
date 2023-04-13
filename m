Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C55A6E1556
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 21:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDMTmi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 13 Apr 2023 15:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMTmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 15:42:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 12:42:34 PDT
Received: from tilde.cafe (tilde.cafe [51.222.161.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D04B6A48;
        Thu, 13 Apr 2023 12:42:34 -0700 (PDT)
Received: from localhost (124.250.94.80.dyn.idknet.com [80.94.250.124])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by tilde.cafe (Postfix) with ESMTPSA id 016EA20703;
        Thu, 13 Apr 2023 15:35:51 -0400 (EDT)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 13 Apr 2023 22:35:50 +0300
Cc:     <stable@vger.kernel.org>, <linux-acpi@vger.kernel.org>
From:   "Acid Bong" <acidbong@tilde.cafe>
To:     <regressions@lists.linux.dev>
Subject: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
Message-Id: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
X-Mailer: aerc 0.14.0-126-g6d59ad3f02bc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there, hello,

Sometimes when I suspend (by closing the lid, less often - by pressing
Fn+F1 (sleep key combo)) or poweroff my laptop (both by pressing powerit
button and running "loginctl poweroff"), it goes in such a state when it
doesn't respond to opening/closing the lid, power button nor
Ctrl+Alt+Del, but, unlike in sleep mode, the fan is rotating and the
"awake status" LED is on. I checked /var/log/kern.log, but it didn't
report suspend at that moment at all: went straight from [UFW BLOCK] to
"Microcode updated" on force reboot (marked with an arrow):

	Apr 13 10:40:32 bong kernel: asus_wmi: Unknown key code 0xcf
	Apr 13 10:44:05 bong kernel: [UFW BLOCK] IN=wlan0 OUT= MAC=/*confidential*/
	Apr 13 10:47:45 bong kernel: [UFW BLOCK] IN=wlan0 OUT= MAC=/*confidential*/
	Apr 13 10:47:46 bong kernel: ICMPv6: NA: /*router*/ advertised our address /*ipv6*/ on wlan0!
	Apr 13 10:47:48 bong last message buffered 2 times
->	Apr 13 10:49:11 bong kernel: [UFW BLOCK] IN=wlan0 OUT= MAC=/*confidential*/
	Apr 13 10:52:34 bong kernel: microcode: microcode updated early to revision 0xf0, date = 2021-11-12
	Apr 13 10:52:34 bong kernel: Linux version 6.1.23-bong+ (acid@bong) (gcc (Gentoo Hardened 12.2.1_p20230121-r1 p10) 12.2.1 20230121, GNU ld (Gentoo 2.39 p5) 2.39.0) #1 SMP PREEMPT_DYNAMIC Tue Apr 11 15:21:57 EEST 2023
	Apr 13 10:52:34 bong kernel: Command line: root=/dev/genston/root ro loglevel=4 rd.lvm.vg=genston rd.luks.uuid=97d10669-2da1-452d-a372-887e420b2ad4 rd.luks.allow-discards pci=nomsi initrd=\x5cinitramfs-6.1.23-bong+.img
	Apr 13 10:52:34 bong kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
	Apr 13 10:52:34 bong kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
	Apr 13 10:52:34 bong kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'

Normally it starts like this (taken from dmesg to sync with elogind messages)

	[ 7835.869228] elogind-daemon[2033]: Lid closed.
	[ 7835.872875] elogind-daemon[2033]: Suspending...
	[ 7835.873955] elogind-daemon[2033]: Suspending system...
	[ 7835.873970] PM: suspend entry (deep)
	[ 7835.902814] Filesystems sync: 0.028 seconds
	[ 7835.920362] Freezing user space processes
	[ 7835.923030] Freezing user space processes completed (elapsed 0.002 seconds)
	[ 7835.923046] OOM killer disabled.
	[ 7835.923049] Freezing remaining freezable tasks
	[ 7835.924445] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
	[ 7835.924624] printk: Suspending console(s) (use no_console_suspend to debug)

The issue appeared when I was using pf-kernel with genpatches and
updated from 6.1-pf2 to 6.1-pf3 (corresponding to vanilla versions 6.1.3
-> 6.1.6). I used that fork until 6.2-pf2, but since then (early March)
moved to vanilla sources and started following the 6.1.y branch when it
was declared LTS. And the issue was present on all of them.

The hang was last detected 3 days ago on 6.1.22 and today on 6.1.23.

I'd like to bisect it, but it could take ages for a couple of reasons:

1) I don't know exact patterns it follows. One of the scenarios I've
noticed was this one (sorry if too ridiculous):
	- put the laptop on the nearby couch and simultaneously close
	  the lid; the loose charger jack might disconnect;
	- lay the mouse upside down (so it doesn't wake up when I
	  reconnect the charger),
but it's not a 100% guarantee of the bug and, as I said earlier, the
laptop also misbehaves on shutdown.

2) The issue happens rarely, once in a few days (sometimes up to a week;
I haven't measured it precisely back then).

Hardware: https://tilde.cafe/u/acidbong/kernel/lspci (`lspci -vvnn`)
Config (latest vanilla): https://git.sr.ht/~acid-bong/kernel/tree/806e6639da610952798e1b5d8c0d700062f915de/item/.config
Built with KCFLAGS="-march=native"
Isolated cmdline: root=/dev/genston/root ro loglevel=4 rd.lvm.vg=genston rd.luks.uuid=97d10669-2da1-452d-a372-887e420b2ad4 rd.luks.allow-discards pci=nomsi initrd=\initramfs-6.1.23-bong+.img

# regzbot introduced v6.1.3..v6.1.6

---
Regards,
~acidbong
