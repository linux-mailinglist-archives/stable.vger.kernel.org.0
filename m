Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D5CDD027
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 22:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443467AbfJRU1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 16:27:01 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:26639 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443419AbfJRU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 16:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571430351;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=01rqe/WWWS1jdN6uwfrdHLE5RSg5tpvr2uQMZiCIpfI=;
        b=BzpIvMXDO3q4UlD9bnaPiJvHQvmgxmFLtcV3YgpUTkXnJLooEHGUSZvmz3N8aHO4Xz
        Xk+rFQq9w/f4Sev2w+0KLfUMyGNJ62R/eyIxN72+tvOKe9WJs6JmMIdsGIIRSmXzIgD0
        Y/H8fQtKwojNcBdnjFSO3KkVn43OHqpP44KBqOF9bdGjz0w8Yd+5QyWa6KAYiC5um/lY
        WDdj1xT6NiN/TN6N/p8fuBsXT9IgYP2QoIQE14ERKWPkM/Ea6hOy061f1mHsjHV9aQC4
        DSSUFk/A1syeRGxxUlEqI75mGeE+EJHpWBUXTQRji6GnnPQyQEDgrPAhGh3CjmzB5C6B
        IcFQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6F3CFF60="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9IKPaDUs
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 18 Oct 2019 22:25:36 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH 6/9] mmc: sdio: fix wl1251 vendor id
Date:   Fri, 18 Oct 2019 22:25:27 +0200
Message-Id: <de9806b944c1690d86ec0f4ef5ba43f87136d9aa.1571430329.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571430329.git.hns@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4.11-rc1 did introduce a patch series that rearranged the
sdio quirks into a header file. Unfortunately this did forget
to handle SDIO_VENDOR_ID_TI differently between wl1251 and
wl1271 with the result that although the wl1251 was found on
the sdio bus, the firmware did not load any more and there was
no interface registration.

This patch defines separate constants to be used by sdio quirks
and drivers.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.11.0
---
 include/linux/mmc/sdio_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index d1a5d5df02f5..08b25c02b5a1 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -71,6 +71,8 @@
 
 #define SDIO_VENDOR_ID_TI			0x0097
 #define SDIO_DEVICE_ID_TI_WL1271		0x4076
+#define SDIO_VENDOR_ID_TI_WL1251		0x104c
+#define SDIO_DEVICE_ID_TI_WL1251		0x9066
 
 #define SDIO_VENDOR_ID_STE			0x0020
 #define SDIO_DEVICE_ID_STE_CW1200		0x2280
-- 
2.19.1

