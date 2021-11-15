Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3206C45141B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348995AbhKOUBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344299AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E42D633D0;
        Mon, 15 Nov 2021 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002523;
        bh=lrvCwTvgb0K6n77Nfl71vDQ9ZbFIuy51zbtc6QMj+yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyM8b6zwCX36eJv0ORp7nVrvRnFBaDiAU1tAcwRGrk+d37803YfNLWp9XqexbXj72
         riCcN8g4QxSU1jJp9h01JXCJQhJtLn52h0Rpgs9clZhOWzmty/2qm7ngTDbCeJK/hc
         sXXvV8k85m7vstXT6A9MaBGfaHefQtxsL7kFs8T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Tong Zhang <ztong0001@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 592/917] scsi: dc395: Fix error case unwinding
Date:   Mon, 15 Nov 2021 18:01:27 +0100
Message-Id: <20211115165448.838294114@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit cbd9a3347c757383f3d2b50cf7cfd03eb479c481 ]

dc395x_init_one()->adapter_init() might fail. In this case, the acb is
already cleaned up by adapter_init(), no need to do that in
adapter_uninit(acb) again.

[    1.252251] dc395x: adapter init failed
[    1.254900] RIP: 0010:adapter_uninit+0x94/0x170 [dc395x]
[    1.260307] Call Trace:
[    1.260442]  dc395x_init_one.cold+0x72a/0x9bb [dc395x]

Link: https://lore.kernel.org/r/20210907040702.1846409-1-ztong0001@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 24c7cefb0b78a..1c79e6c271630 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4618,6 +4618,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
+		acb = NULL;
 		goto fail;
 	}
 
-- 
2.33.0



