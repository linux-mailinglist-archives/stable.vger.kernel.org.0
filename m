Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EEC450CB1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbhKORmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237724AbhKORju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2BB863273;
        Mon, 15 Nov 2021 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997176;
        bh=OuNU0BIQcjXVF33JroRQGRc9Y8dONYP5OlQmmQ7ML9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIz9R3L3uUF7LqJgETPipkC7trvY5mAdJAbOS06FV8P0XuU6TvWZnRVUzf17EK8l9
         HzOFV//O6riFZsnUKjDgAvaKR9R5Vfdgar7xSvA79YptAkNNOL54B7Xis5Zv+JESfA
         2os2RhfVatHf7nzPlKGJT7Sq6NP3vGPu7Nxnngkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/575] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 15 Nov 2021 17:56:18 +0100
Message-Id: <20211115165345.472405633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 06634d5b6e923ed0d4772aba8def5a618f44c7fe ]

The driver probing function should return < 0 for failure, otherwise
kernel will treat value > 0 as success.

Link: https://lore.kernel.org/r/1634522181-31166-1-git-send-email-zheyuma97@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e075f855f298e..813abaf1b0872 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4079,7 +4079,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.33.0



