Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE328B6F8
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgJLNjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731247AbgJLNio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D812222C;
        Mon, 12 Oct 2020 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509917;
        bh=6d2A1CF4f0xvg4GXQgVD9qYb2Sp7zjGQKdlXbCOoAE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPFcSs/ScjWECzpZWiEXbSan5oqvq5ePDYmDOwR+HNQkiPBVRHVcwEw8qc1xUK5CU
         u1dXBimJy2JNn/jgVQSpiYVzybTTP8+j1t/y05NzE/xI2bN0ZQ/wodKthRyn20+M+J
         jIMDebfBlas7MpdLx/Nalg5pBTDHlgrAY80Bapzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Volker=20R=C3=BCmelin?= <volker.ruemelin@googlemail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 14/49] i2c: i801: Exclude device from suspend direct complete optimization
Date:   Mon, 12 Oct 2020 15:27:00 +0200
Message-Id: <20201012132630.104038482@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1698,6 +1698,7 @@ static int i801_probe(struct pci_dev *de
 
 	pci_set_drvdata(dev, priv);
 
+	dev_pm_set_driver_flags(&dev->dev, DPM_FLAG_NEVER_SKIP);
 	pm_runtime_set_autosuspend_delay(&dev->dev, 1000);
 	pm_runtime_use_autosuspend(&dev->dev);
 	pm_runtime_put_autosuspend(&dev->dev);


