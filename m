Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8F65C855
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjACUpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 15:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbjACUpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 15:45:15 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35BDB3
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 12:45:13 -0800 (PST)
Date:   Tue, 03 Jan 2023 20:45:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1672778710; x=1673037910;
        bh=umGynh9e9UpNoXBJoi2+QI17h9TARCSecUXuM2g2Q94=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=O4LNH1vaYo/EpdeOFp/ua75A6FWnM5Yls9SjlORjIXviHP4mgmmVICG2tCheL1mpC
         sO4GOGGXmpjE6oFwqO+14dIj9XZ67G0djzn/RJAWVSeCZcuiDRX/DHoqLSDD9MFM3w
         KllEc9KSvhL493Z6AM7Bpf4MWleJPuy5Tn1Nvc29OEGlbYe8+7rvxDUPBxM/CpX8Pz
         qHGmgPLxZTra8scG+RqMGial98JIE3TSThwR/zUJOdpTZdXNXpWmnUSBldRwVz8UWs
         Jkk/NYVLtZnZ+nseJkibXnB1+1iBiI18g4l8XN6D7v0aGCYo0K6pmMESf1rfuaxcRH
         gjkIQhoj9d5xQ==
To:     stable@vger.kernel.org
From:   Waldek Andrukiewicz <waldek.social@pm.me>
Cc:     regressions@lists.linux.dev
Subject: i2c-CLSA0100:00-cs35l41-hda.1: System Suspend not supported
Message-ID: <e6751ac2-34f3-d13f-13db-8174fade8308@pm.me>
Feedback-ID: 6286898:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I am running Manjaro, after upgrading from kernel 6.0.15 to 6.1.1
(https://gitlab.manjaro.org/packages/core/linux61) I have noticed that
suspend stopped working, what I can see in the logs is the following
issue which IMO points to cs35l41

Machine:
 =C2=A0 Type: Laptop System: LENOVO product: 82N6 v: Legion 7 16ACHg6

journalctl output below:

Jan 02 21:52:54 legion16 systemd[1]: Starting System Suspend...
Jan 02 21:52:54 legion16 wpa_supplicant[1193]: wlp4s0:
CTRL-EVENT-DSCP-POLICY clear_all
Jan 02 21:52:54 legion16 systemd-sleep[2912]: Entering sleep state
'suspend'...
Jan 02 21:52:54 legion16 kernel: PM: suspend entry (deep)
Jan 02 21:52:54 legion16 kernel: Filesystems sync: 0.008 seconds
Jan 02 21:52:54 legion16 wpa_supplicant[1193]: wlp4s0:
CTRL-EVENT-DSCP-POLICY clear_all
Jan 02 21:52:54 legion16 wpa_supplicant[1193]: nl80211: deinit
ifname=3Dwlp4s0 disabled_11b_rates=3D0
Jan 02 21:52:54 legion16 plasmashell[1770]: qml: [DEBUG] - onNewData
Jan 02 21:52:54 legion16 kernel: Freezing user space processes ...
(elapsed 0.002 seconds) done.
Jan 02 21:52:54 legion16 kernel: OOM killer disabled.
Jan 02 21:52:54 legion16 kernel: Freezing remaining freezable tasks ...
(elapsed 0.001 seconds) done.
Jan 02 21:52:54 legion16 kernel: printk: Suspending console(s) (use
no_console_suspend to debug)
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: System Suspend not supported
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.0: System Suspend not supported
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: PM: dpm_run_callback():
cs35l41_system_suspend+0x0/0xd0 [snd_hda_scodec_cs35l41] returns -22
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.0: PM: dpm_run_callback():
cs35l41_system_suspend+0x0/0xd0 [snd_hda_scodec_cs35l41] returns -22
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: PM: failed to suspend async: error -22
Jan 02 21:52:54 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.0: PM: failed to suspend async: error -22
Jan 02 21:52:54 legion16 kernel: PM: Some devices failed to suspend, or
early wake event detected
Jan 02 21:52:54 legion16 kernel: OOM killer enabled.
Jan 02 21:52:54 legion16 kernel: Restarting tasks ... done.
Jan 02 21:52:54 legion16 kernel: random: crng reseeded on system resumption
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO: Relay listener
(dynamic+https://relays.syncthing.net/endpoint) shutting down
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO:
listenerSupervisor@dynamic+https://relays.syncthing.net/endpoint:
service dynamic+https://relays.syncthing.net/endpoint failed: could not
find a connectable relay
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO: Relay listener
(dynamic+https://relays.syncthing.net/endpoint) starting
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO: Relay listener
(dynamic+https://relays.syncthing.net/endpoint) shutting down
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO:
listenerSupervisor@dynamic+https://relays.syncthing.net/endpoint:
service dynamic+https://relays.syncthing.net/endpoint failed: Get
"https://relays.syncthing.net/endpoint": dial tcp: lookup
relays.syncthing.net on [::1]:53: read udp [::1]:58193->[::1]:53: read:
connection refused
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO: Relay listener
(dynamic+https://relays.syncthing.net/endpoint) starting
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO: Relay listener
(dynamic+https://relays.syncthing.net/endpoint) shutting down
Jan 02 21:52:54 legion16 syncthing[1588]: [RBC2R] INFO:
listenerSupervisor@dynamic+https://relays.syncthing.net/endpoint:
service dynamic+https://relays.syncthing.net/endpoint failed: Get
"https://relays.syncthing.net/endpoint": dial tcp: lookup
relays.syncthing.net on [::1]:53: read udp [::1]:35430->[::1]:53: read:
connection refused
Jan 02 21:52:55 legion16 bluetoothd[942]: Controller resume with wake
event 0x0
Jan 02 21:52:55 legion16 kernel: PM: suspend exit
Jan 02 21:52:55 legion16 kernel: PM: suspend entry (s2idle)
Jan 02 21:52:55 legion16 kernel: Filesystems sync: 0.004 seconds
Jan 02 21:52:55 legion16 kernel: Freezing user space processes ...
(elapsed 0.001 seconds) done.
Jan 02 21:52:55 legion16 kernel: OOM killer disabled.
Jan 02 21:52:55 legion16 kernel: Freezing remaining freezable tasks ...
(elapsed 0.216 seconds) done.
Jan 02 21:52:55 legion16 kernel: printk: Suspending console(s) (use
no_console_suspend to debug)
Jan 02 21:52:55 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: System Suspend not supported
Jan 02 21:52:55 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: PM: dpm_run_callback():
cs35l41_system_suspend+0x0/0xd0 [snd_hda_scodec_cs35l41] returns -22
Jan 02 21:52:55 legion16 kernel: cs35l41-hda
i2c-CLSA0100:00-cs35l41-hda.1: PM: failed to suspend async: error -22
Jan 02 21:52:55 legion16 kernel: PM: Some devices failed to suspend, or
early wake event detected
Jan 02 21:52:55 legion16 kernel: OOM killer enabled.
Jan 02 21:52:55 legion16 plasmashell[1770]: qml: [DEBUG] - onNewData
Jan 02 21:52:55 legion16 kernel: Restarting tasks ... done.
Jan 02 21:52:55 legion16 kernel: random: crng reseeded on system resumption
Jan 02 21:52:55 legion16 systemd-sleep[2912]: Failed to put system to
sleep. System resumed again: Invalid argument
Jan 02 21:52:55 legion16 kernel: PM: suspend exit
Jan 02 21:52:55 legion16 bluetoothd[942]: Controller resume with wake
event 0x0
Jan 02 21:52:55 legion16 systemd[1]: systemd-suspend.service: Main
process exited, code=3Dexited, status=3D1/FAILURE
Jan 02 21:52:55 legion16 systemd[1]: systemd-suspend.service: Failed
with result 'exit-code'.
Jan 02 21:52:55 legion16 systemd[1]: Failed to start System Suspend.
Jan 02 21:52:55 legion16 systemd[1]: Dependency failed for Suspend.

I have to admit I have not tried 6.1.2 yet but I could not find any
changes related to this module (opposite to 6.1 where there was quite a
few including suspend - commit dca45efbe3c870a4ad2107fe625109b3765c0fea).

I can provide any additional information or logs if necessary.

Best Regards,

Waldek




