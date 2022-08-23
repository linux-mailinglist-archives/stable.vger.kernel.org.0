Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532F659D354
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242077AbiHWIMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242404AbiHWILP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177DC3D590;
        Tue, 23 Aug 2022 01:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5CF8B81C22;
        Tue, 23 Aug 2022 08:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25838C433C1;
        Tue, 23 Aug 2022 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242108;
        bh=facbOoCrP315Ov+dCDx6pIKj0Bnsu110lcnOM1sX4Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iH7nQZZ3j8ILmuTqDBLgjydf9QCjR6sFXPx4jleREy61gvV1GtJqp62Zv0CT93Kc
         mXE2HARDqKThBOmNAzA1UN/ognOA/FIzrfwoovkmkqxLAs0gtyTECl4QSUAdV44Ims
         sf5vyJuE7TXXsNswT8SRdKN9u9xNIxCFbpLLxtnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Theodore Tso" <tytso@mit.edu>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nick Kralevich <nnk@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.9 020/101] init/main.c: extract early boot entropy from the passed cmdline
Date:   Tue, 23 Aug 2022 10:02:53 +0200
Message-Id: <20220823080035.337391991@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Micay <danielmicay@gmail.com>

commit 33d72f3822d7ff8a9e45bd7413c811085cb87aa5 upstream.

Feed the boot command-line as to the /dev/random entropy pool

Existing Android bootloaders usually pass data which may not be known by
an external attacker on the kernel command-line.  It may also be the
case on other embedded systems.  Sample command-line from a Google Pixel
running CopperheadOS....

    console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0
    androidboot.hardware=sailfish user_debug=31 ehci-hcd.park=3
    lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff buildvariant=user
    veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab
    androidboot.bootdevice=624000.ufshc androidboot.verifiedbootstate=yellow
    androidboot.veritymode=enforcing androidboot.keymaster=1
    androidboot.serialno=FA6CE0305299 androidboot.baseband=msm
    mdss_mdp.panel=1:dsi:0:qcom,mdss_dsi_samsung_ea8064tg_1080p_cmd:1:none:cfg:single_dsi
    androidboot.slot_suffix=_b fpsimd.fpsimd_settings=0
    app_setting.use_app_setting=0 kernelflag=0x00000000 debugflag=0x00000000
    androidboot.hardware.revision=PVT radioflag=0x00000000
    radioflagex1=0x00000000 radioflagex2=0x00000000 cpumask=0x00000000
    androidboot.hardware.ddr=4096MB,Hynix,LPDDR4 androidboot.ddrinfo=00000006
    androidboot.ddrsize=4GB androidboot.hardware.color=GRA00
    androidboot.hardware.ufs=32GB,Samsung androidboot.msm.hw_ver_id=268824801
    androidboot.qf.st=2 androidboot.cid=11111111 androidboot.mid=G-2PW4100
    androidboot.bootloader=8996-012001-1704121145
    androidboot.oem_unlock_support=1 androidboot.fp_src=1
    androidboot.htc.hrdump=detected androidboot.ramdump.opt=mem@2g:2g,mem@4g:2g
    androidboot.bootreason=reboot androidboot.ramdump_enable=0 ro
    root=/dev/dm-0 dm="system none ro,0 1 android-verity /dev/sda34"
    rootwait skip_initramfs init=/init androidboot.wificountrycode=US
    androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136

Among other things, it contains a value unique to the device
(androidboot.serialno=FA6CE0305299), unique to the OS builds for the
device variant (veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab)
and timings from the bootloader stages in milliseconds
(androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136).

[tytso@mit.edu: changelog tweak]
[labbott@redhat.com: line-wrapped command line]
Link: http://lkml.kernel.org/r/20170816231458.2299-3-labbott@redhat.com
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Nick Kralevich <nnk@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/init/main.c
+++ b/init/main.c
@@ -502,8 +502,10 @@ asmlinkage __visible void __init start_k
 	setup_arch(&command_line);
 	/*
 	 * Set up the the initial canary and entropy after arch
+	 * and after adding latent and command line entropy.
 	 */
 	add_latent_entropy();
+	add_device_randomness(command_line, strlen(command_line));
 	boot_init_stack_canary();
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);


