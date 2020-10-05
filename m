Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C0C283B10
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgJEPjf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 5 Oct 2020 11:39:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:35072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbgJEPje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:39:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0CC3DB127;
        Mon,  5 Oct 2020 15:39:33 +0000 (UTC)
Date:   Mon, 5 Oct 2020 17:39:31 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        volker.ruemelin@googlemail.com, wsa@kernel.org
Subject: [PATCH] i2c: i801: Exclude device from suspend direct complete
 optimization
Message-ID: <20201005173931.3c40f15d@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
This is the backported version for kernel trees 5.4 and 4.19. The
difference with the upstream commit is that DPM_FLAG_NEVER_SKIP is used
instead of DPM_FLAG_NO_DIRECT_COMPLETE, which did not exist back then.

 drivers/i2c/busses/i2c-i801.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-5.4.orig/drivers/i2c/busses/i2c-i801.c	2020-10-05 14:59:14.454238658 +0200
+++ linux-5.4/drivers/i2c/busses/i2c-i801.c	2020-10-05 15:54:31.399988586 +0200
@@ -1891,6 +1891,7 @@ static int i801_probe(struct pci_dev *de
 
 	pci_set_drvdata(dev, priv);
 
+	dev_pm_set_driver_flags(&dev->dev, DPM_FLAG_NEVER_SKIP);
 	pm_runtime_set_autosuspend_delay(&dev->dev, 1000);
 	pm_runtime_use_autosuspend(&dev->dev);
 	pm_runtime_put_autosuspend(&dev->dev);


-- 
Jean Delvare
SUSE L3 Support
