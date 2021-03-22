Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B888F344353
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhCVMth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232741AbhCVMsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9929B619E8;
        Mon, 22 Mar 2021 12:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417042;
        bh=NqauGuUlqs04aDiBlkjrkYv7CLIba4f1hYwFQt9WIHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ99/moge5mRdyIPIknnLO6j2xM6f2xxrOc6YCn/s5c4v+M7lFFGt+UEFpjfcL9GC
         dav8kLQcy+00JWH2yh6Yt+MZewx6ZLV9zVxcwNoQ8cwA5WfyHVqelMVe+bPjTc4Mqj
         V5rKHxxoZs32QqLpZPE9LNZg74K338Zbl74XrbsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 31/60] scsi: myrs: Fix a double free in myrs_cleanup()
Date:   Mon, 22 Mar 2021 13:28:19 +0100
Message-Id: <20210322121923.416983275@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit 2bb817712e2f77486d6ee17e7efaf91997a685f8 upstream.

In myrs_cleanup(), cs->mmio_base will be freed twice by iounmap().

Link: https://lore.kernel.org/r/20210311063005.9963-1-lyl2019@mail.ustc.edu.cn
Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/myrs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2274,12 +2274,12 @@ static void myrs_cleanup(struct myrs_hba
 	if (cs->mmio_base) {
 		cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
+		cs->mmio_base = NULL;
 	}
 	if (cs->irq)
 		free_irq(cs->irq, cs);
 	if (cs->io_addr)
 		release_region(cs->io_addr, 0x80);
-	iounmap(cs->mmio_base);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	scsi_host_put(cs->host);


