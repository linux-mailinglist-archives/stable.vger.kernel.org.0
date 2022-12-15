Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49F664E079
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiLOSOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiLOSNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:13:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34C24A072;
        Thu, 15 Dec 2022 10:13:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E696B81C1F;
        Thu, 15 Dec 2022 18:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21118C433D2;
        Thu, 15 Dec 2022 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671128017;
        bh=9W342Kl4VtwfnHP8+I3JU6jwryu0vA3RGMyNsEmoCjc=;
        h=From:To:Cc:Subject:Date:From;
        b=LOZOEsYXiWyHjEnrB0idKS7ot1ZR3nUjvahPOzTk3FjvDKkZ3xmIko+EZwXSOKPb2
         A0Wsoi8Jwnw/W2fOrWND/T9ETw7ZvkV2V+uScV9Doub3dosRsmuiKZouk/pc+Ui9Rp
         wjAX59KP+Gq2FO1IbSX7VoTCYpvRXgHwpWZBXkUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 00/16] 6.0.14-rc1 review
Date:   Thu, 15 Dec 2022 19:10:44 +0100
Message-Id: <20221215172908.162858817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.14-rc1
X-KernelTest-Deadline: 2022-12-17T17:29+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.14 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.14-rc1

Lei Rao <lei.rao@intel.com>
    nvme-pci: clear the prp2 field when not used

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf_pending_task() UaF

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l51: Correct PGA Volume minimum value

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: fec: don't reset irq coalesce settings to defaults on "ip link up"

Yasushi SHOJI <yasushi.shoji@gmail.com>
    can: mcba_usb: Fix termination command argument

Heiko Schocher <hs@denx.de>
    can: sja1000: fix size of OCR_MODE_MASK define

Ricardo Ribalda <ribalda@chromium.org>
    pinctrl: meditatek: Startup with the IRQs disabled

Hou Tao <houtao1@huawei.com>
    libbpf: Use page size as max_entries when probing ring buffer map

Mark Brown <broonie@kernel.org>
    ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: explicitly clear CHnF flags

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: explicitly clear software reset bit

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

David Michael <fedora.dm0@gmail.com>
    libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Nathan Chancellor <nathan@kernel.org>
    x86/vdso: Conditionally export __vdso_sgx_enter_enclave()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix wake alarm breakage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix event handler registration ordering issue


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/x86/entry/vdso/vdso.lds.S            |  2 ++
 drivers/net/can/usb/mcba_usb.c            | 10 ++++++---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++-------------
 drivers/nvme/host/pci.c                   |  2 ++
 drivers/pinctrl/mediatek/mtk-eint.c       |  9 +++++---
 drivers/rtc/rtc-cmos.c                    | 35 +++++++++++++++++++++++--------
 include/linux/can/platform/sja1000.h      |  2 +-
 kernel/events/core.c                      | 17 +++++++++++----
 sound/soc/codecs/cs42l51.c                |  2 +-
 sound/soc/fsl/fsl_micfil.c                | 19 +++++++++++++++++
 sound/soc/soc-ops.c                       |  6 ++++++
 tools/lib/bpf/btf_dump.c                  |  2 +-
 tools/lib/bpf/libbpf_probes.c             |  2 +-
 14 files changed, 93 insertions(+), 41 deletions(-)


