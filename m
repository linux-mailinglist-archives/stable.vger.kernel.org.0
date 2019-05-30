Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BF32F4E5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfE3DMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfE3DMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:06 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B91E24519;
        Thu, 30 May 2019 03:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185925;
        bh=Jan7DD9Uh0cQPM9Trrlwh8Yfj1EXn5QYmANOkL08xFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf/hFyIT5hXGqwGLCIb4SvwBdhPzfBQSH1z04YvT+Qon+PTWE59MRHHf1+WXmzsJf
         u/a7kLdH9JqRFco1s4/rDiG/9PGExy/ZORcy49BPWw734qE4odyadhcwZqUY+L8khE
         nnpsIJdqA59i5b4TFnkzj3Z1v/ANp76k3zoH8RnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 315/405] scsi: qla4xxx: avoid freeing unallocated dma memory
Date:   Wed, 29 May 2019 20:05:13 -0700
Message-Id: <20190530030556.725255091@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 6e4f4931ae175..8c674eca09f13 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5930,7 +5930,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
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



