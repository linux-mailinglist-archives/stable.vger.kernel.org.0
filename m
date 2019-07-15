Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3047E69016
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389595AbfGOOS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:18:59 -0400
Received: from glenfiddich.mraw.org ([62.210.215.98]:51538 "EHLO
        glenfiddich.mraw.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389999AbfGOOS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 10:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mraw.org;
         s=mail; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k431XKcj+wPDXc52xbsrzSEpbCeOUVP+NVS9d75MGpg=; b=Cneas9+qQX3ItjiFuTxh4jijae
        t+GUTDGS0ozkEwDEJpSoueDT0COesuXOH/epV53zzF94r7LDv53SMz+gMp1oOXK4IOY+8DiObyuUl
        ZcxGYVNNc0zrXLe3F1jnsg6SadClvO6//sd7rQhKHGc/2ydZwQVYSkN3HLyZdnJsbRx4=;
Received: from localhost ([127.0.0.1] helo=armor.home)
        by glenfiddich.mraw.org with esmtp (Exim 4.89)
        (envelope-from <cyril@debamax.com>)
        id 1hn1Y4-00008C-6p; Mon, 15 Jul 2019 16:01:48 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     stable@vger.kernel.org
Cc:     charles.fendt@me.com, Cyril Brulebois <cyril@debamax.com>
Subject: [PATCH 0/3] arm/arm64: Backport DTB support for Raspberry Pi Compute Module 3 to 4.19.y
Date:   Mon, 15 Jul 2019 16:01:09 +0200
Message-Id: <20190715140112.6180-1-cyril@debamax.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Raspberry Pi Compute Module 3 gathers components that are already
supported in 4.19.y kernels except there's no DTB for it. This small
series of patches backports:
 1. the DTB addition on the arm platform
 2. the extension of this addition to the arm64 platform
 3. the correction of this extension.

I chose to backport patch 2 and 3 separately instead of squashing them
together but I can resubmit with patches 2 and 3 merged if that's
desirable.

This was successfully tested on bare metal, in 64-bit mode, with an
extra patch to the raspi3-firmware packages to get the DTB installed
in the right place, under the right name (bcm2710-rpi-cm3.dtb) so that
the bootloader finds it. The base kernel was 4.19.37-5 as packaged in
Debian.

The summary of changes follows.


Liviu Dudau (1):
  arm64: dts: broadcom: Use the .dtb name in the rule, rather than .dts

Stefan Wahren (2):
  ARM: dts: add Raspberry Pi Compute Module 3 and IO board
  arm64: dts: broadcom: Add reference to Compute Module IO Board V3

 arch/arm/boot/dts/Makefile                         |  1 +
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          | 87 ++++++++++++++++++++++
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi             | 52 +++++++++++++
 arch/arm64/boot/dts/broadcom/Makefile              |  3 +-
 .../boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts      |  2 +
 5 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
 create mode 100644 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
 create mode 100644 arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
