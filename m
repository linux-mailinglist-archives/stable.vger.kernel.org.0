Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366FF2882AD
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 08:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbgJIGiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 02:38:46 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:38944 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731580AbgJIGio (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 02:38:44 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 0996cT7p002367; Fri, 9 Oct 2020 15:38:29 +0900
X-Iguazu-Qid: 2wHHmdN4iwh29ka0gz
X-Iguazu-QSIG: v=2; s=0; t=1602225509; q=2wHHmdN4iwh29ka0gz; m=evK5dxqX52Ngtg6mVPa/VLxnbcFrcUu9hW3j2B9Exyk=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 0996cSak006358;
        Fri, 9 Oct 2020 15:38:28 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0996cRG1019370;
        Fri, 9 Oct 2020 15:38:27 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0996cRoT032679;
        Fri, 9 Oct 2020 15:38:27 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?q?Volker=20R=C3=BCmelin?= <volker.ruemelin@googlemail.com>,
        Wolfram Sang <wsa@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.19 and 5.4] i2c: i801: Exclude device from suspend direct complete optimization
Date:   Fri,  9 Oct 2020 15:38:21 +0900
X-TSB-HOP: ON
Message-Id: <20201009063821.549298-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

commit 845b89127bc5458d0152a4d63f165c62a22fcb70 upstream.

By default, PCI drivers with runtime PM enabled will skip the calls
to suspend and resume on system PM. For this driver, we don't want
that, as we need to perform additional steps for system PM to work
properly on all systems. So instruct the PM core to not skip these
calls.

Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
Reported-by: Volker Rümelin <volker.ruemelin@googlemail.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>
[iwamatsu: Use DPM_FLAG_NEVER_SKIP instead of DPM_FLAG_NO_DIRECT_COMPLETE]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/i2c/busses/i2c-i801.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 9a80c3c7e8af27..c40eef4e7a9858 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1891,6 +1891,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)

 	pci_set_drvdata(dev, priv);

+	dev_pm_set_driver_flags(&dev->dev, DPM_FLAG_NEVER_SKIP);
 	pm_runtime_set_autosuspend_delay(&dev->dev, 1000);
 	pm_runtime_use_autosuspend(&dev->dev);
 	pm_runtime_put_autosuspend(&dev->dev);
--
2.28.0

