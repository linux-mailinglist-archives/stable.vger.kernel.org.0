Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747F01F6218
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgFKHUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgFKHUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:20:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE112074B;
        Thu, 11 Jun 2020 07:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591860024;
        bh=29Tkz0CNTkzq46UrJIfYtMlWpvqwhfnFzsUd/4lIHKE=;
        h=From:To:Cc:Subject:Date:From;
        b=1UR5xZYGowjJhKWuJAWCpW/SB+9wkj03TxiTCuffVoiLWEGL//ag3A7UQj+MfUVA3
         lLbfjGa1NrDg0ccTkaoRX/DLANJf9oulbs1LR13FyRLPvSqH9LxqTq7JAZGxrUng3F
         XLtwRnzd/cslNDm30LoL8pcrrdxIDcQqvC49VAHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.2
Date:   Thu, 11 Jun 2020 09:20:16 +0200
Message-Id: <1591860016121129@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.2 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu                          |    1 
 Documentation/admin-guide/hw-vuln/index.rst                                 |    1 
 Documentation/admin-guide/hw-vuln/special-register-buffer-data-sampling.rst |  149 ++++++++++
 Documentation/admin-guide/kernel-parameters.txt                             |   20 +
 Makefile                                                                    |    2 
 arch/x86/include/asm/cpu_device_id.h                                        |   27 +
 arch/x86/include/asm/cpufeatures.h                                          |    2 
 arch/x86/include/asm/msr-index.h                                            |    4 
 arch/x86/kernel/cpu/bugs.c                                                  |  106 +++++++
 arch/x86/kernel/cpu/common.c                                                |   56 +++
 arch/x86/kernel/cpu/cpu.h                                                   |    1 
 arch/x86/kernel/cpu/match.c                                                 |    7 
 drivers/base/cpu.c                                                          |    8 
 drivers/iio/adc/stm32-adc-core.c                                            |   34 --
 drivers/iio/chemical/pms7003.c                                              |   17 -
 drivers/iio/chemical/sps30.c                                                |    9 
 drivers/iio/light/vcnl4000.c                                                |    6 
 drivers/nvmem/qfprom.c                                                      |   14 
 drivers/staging/rtl8712/wifi.h                                              |    9 
 drivers/tty/hvc/hvc_console.c                                               |   23 -
 drivers/tty/serial/8250/Kconfig                                             |    1 
 drivers/tty/vt/keyboard.c                                                   |   26 +
 drivers/usb/class/cdc-acm.c                                                 |    2 
 drivers/usb/musb/jz4740.c                                                   |    4 
 drivers/usb/musb/musb_core.c                                                |    7 
 drivers/usb/musb/musb_debugfs.c                                             |   10 
 drivers/usb/serial/ch341.c                                                  |   68 ++++
 drivers/usb/serial/option.c                                                 |    4 
 drivers/usb/serial/qcserial.c                                               |    1 
 drivers/usb/serial/usb_wwan.c                                               |    4 
 include/linux/mod_devicetable.h                                             |    2 
 kernel/events/uprobes.c                                                     |   16 -
 32 files changed, 531 insertions(+), 110 deletions(-)

Bin Liu (2):
      USB: serial: usb_wwan: do not resubmit rx urb on fatal errors
      usb: musb: start session in resume for host port

Daniele Palmas (1):
      USB: serial: option: add Telit LE910C1-EUX compositions

Dinghao Liu (1):
      usb: musb: Fix runtime PM imbalance on error

Dmitry Torokhov (1):
      vt: keyboard: avoid signed integer overflow in k_ascii

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix a wrong error message when probing interrupts

Greg Kroah-Hartman (1):
      Linux 5.7.2

Jiri Slaby (1):
      tty: hvc_console, fix crashes on parallel open/close

Johan Hovold (1):
      USB: serial: ch341: fix lockup of devices with limited prescaler

Jonathan Cameron (2):
      iio:chemical:sps30: Fix timestamp alignment
      iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list

Josh Triplett (1):
      serial: 8250: Enable 16550A variants by default on non-x86

Mark Gross (4):
      x86/cpu: Add a steppings field to struct x86_cpu_id
      x86/cpu: Add 'table' argument to cpu_matches()
      x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
      x86/speculation: Add SRBDS vulnerability and mitigation documentation

Mathieu Othacehe (1):
      iio: vcnl4000: Fix i2c swapped word reading.

Matt Jolly (1):
      USB: serial: qcserial: add DW5816e QDL support

Michael Hanselmann (1):
      USB: serial: ch341: add basis for quirk detection

Oleg Nesterov (1):
      uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned

Oliver Neukum (1):
      CDC-ACM: heed quirk also in error handling

Pascal Terjan (1):
      staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Paul Cercueil (1):
      usb: musb: jz4740: Prevent lockup when CONFIG_SMP is set

Srinivas Kandagatla (1):
      nvmem: qfprom: remove incorrect write support

