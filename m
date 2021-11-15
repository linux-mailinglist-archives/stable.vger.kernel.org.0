Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A0450BF5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhKORck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236669AbhKORaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7648563293;
        Mon, 15 Nov 2021 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996779;
        bh=IUJ1Ekv/7waKmFFIq4JLOrVohAhbdrb69YMBx4fYNoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWktHOBpoDnEmtitYhUVEw6jopdR6F8Lx81KO/pXCAsLvvcXZCIqxWOO9bJ/TWdD4
         se6VoH0Z05Weya/ut+FrSgOllCzV6ITYt2IEw+S1buTXhEXgWCwN5jL4nKcITm8uaZ
         jg/CNNMUb6KQvXW6Fdha6R70bj6/S7IgeZ8LD1xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Tong Zhang <ztong0001@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/355] scsi: dc395: Fix error case unwinding
Date:   Mon, 15 Nov 2021 18:03:08 +0100
Message-Id: <20211115165322.276143669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 13fbb2eab842e..5fb06930912a0 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4698,6 +4698,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
+		acb = NULL;
 		goto fail;
 	}
 
-- 
2.33.0



