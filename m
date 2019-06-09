Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91B43A96A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbfFIRJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388413AbfFIRDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6998204EC;
        Sun,  9 Jun 2019 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099805;
        bh=2GIXIYzyc2bRJV1VoIiHwA6B1C2BcKL3dkvr9OdC9Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIID524Wc3wfygNndNEIq6s+Y8wvG55piU7TIQC3nRFdtv7tX761M+6velq+PY/Xu
         nCBKOwcmtVS72/vVmPCUfzljxrVRqxFgZ3OI9c6P6pnNNxEnX0uKLepizvzTkSI/Lk
         Q3H93r8BobAHWDQRkgw5m6cyF1MwSJritWivh+s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 171/241] scsi: qla4xxx: avoid freeing unallocated dma memory
Date:   Sun,  9 Jun 2019 18:41:53 +0200
Message-Id: <20190609164152.724720064@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 608f729c31d4caf52216ea00d20092a80959256d ]

Clang -Wuninitialized notices that on is_qla40XX we never allocate any DMA
memory in get_fw_boot_info() but attempt to free it anyway:

drivers/scsi/qla4xxx/ql4_os.c:5915:7: error: variable 'buf_dma' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
                if (!(val & 0x07)) {
                    ^~~~~~~~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5985:47: note: uninitialized use occurs here
        dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
                                                     ^~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5915:3: note: remove the 'if' if its condition is always true
                if (!(val & 0x07)) {
                ^~~~~~~~~~~~~~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5885:20: note: initialize the variable 'buf_dma' to silence this warning
        dma_addr_t buf_dma;
                          ^
                           = 0

Skip the call to dma_free_coherent() here.

Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c158967b59d7b..d220b4f691c77 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5939,7 +5939,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		val = rd_nvram_byte(ha, sec_addr);
 		if (val & BIT_7)
 			ddb_index[1] = (val & 0x7f);
-
+		goto exit_boot_info;
 	} else if (is_qla80XX(ha)) {
 		buf = dma_alloc_coherent(&ha->pdev->dev, size,
 					 &buf_dma, GFP_KERNEL);
-- 
2.20.1



