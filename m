Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37542E3E5B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503397AbgL1O1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503938AbgL1O1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3649D22B30;
        Mon, 28 Dec 2020 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165582;
        bh=17gpuMzdRdIp80yZBSkpR/pLwS1pXPEGafk/bB3lR0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/D4ruxkls5oKmwf7cKayUVuYEtE/Ah+UebbFSQKttOcUufDqqa5uYWkX7HrcVFVb
         VCffIUpXj7+xw/s62GcEznKYt65Q08T9EMLj29ge41ggKxo4eRTVqHtsFgukUFKVe+
         x/K58oz5Q4wVAfkDnhp7jqEFMx6iNUCmauh3qKpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.10 575/717] EDAC/i10nm: Use readl() to access MMIO registers
Date:   Mon, 28 Dec 2020 13:49:33 +0100
Message-Id: <20201228125048.471127861@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 83ff51c4e3fecf6b8587ce4d46f6eac59f5d7c5a upstream.

Instead of raw access, use readl() to access MMIO registers of
memory controller to avoid possible compiler re-ordering.

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i10nm_base.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/io.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/mce.h>
@@ -19,14 +20,16 @@
 #define i10nm_printk(level, fmt, arg...)	\
 	edac_printk(level, "i10nm", fmt, ##arg)
 
-#define I10NM_GET_SCK_BAR(d, reg)		\
+#define I10NM_GET_SCK_BAR(d, reg)	\
 	pci_read_config_dword((d)->uracu, 0xd0, &(reg))
 #define I10NM_GET_IMC_BAR(d, i, reg)	\
 	pci_read_config_dword((d)->uracu, 0xd8 + (i) * 4, &(reg))
 #define I10NM_GET_DIMMMTR(m, i, j)	\
-	(*(u32 *)((m)->mbase + 0x2080c + (i) * 0x4000 + (j) * 4))
+	readl((m)->mbase + 0x2080c + (i) * 0x4000 + (j) * 4)
 #define I10NM_GET_MCDDRTCFG(m, i, j)	\
-	(*(u32 *)((m)->mbase + 0x20970 + (i) * 0x4000 + (j) * 4))
+	readl((m)->mbase + 0x20970 + (i) * 0x4000 + (j) * 4)
+#define I10NM_GET_MCMTR(m, i)		\
+	readl((m)->mbase + 0x20ef8 + (i) * 0x4000)
 
 #define I10NM_GET_SCK_MMIO_BASE(reg)	(GET_BITFIELD(reg, 0, 28) << 23)
 #define I10NM_GET_IMC_MMIO_OFFSET(reg)	(GET_BITFIELD(reg, 0, 10) << 12)
@@ -148,7 +151,7 @@ static bool i10nm_check_ecc(struct skx_i
 {
 	u32 mcmtr;
 
-	mcmtr = *(u32 *)(imc->mbase + 0x20ef8 + chan * 0x4000);
+	mcmtr = I10NM_GET_MCMTR(imc, chan);
 	edac_dbg(1, "ch%d mcmtr reg %x\n", chan, mcmtr);
 
 	return !!GET_BITFIELD(mcmtr, 2, 2);


