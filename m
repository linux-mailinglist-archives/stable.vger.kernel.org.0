Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0F4450AB6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhKOROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236635AbhKORMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9331761BE5;
        Mon, 15 Nov 2021 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996157;
        bh=pQb1psDP2g/e0zAvNWY0zjFnqwUsYoFMyKBpBLNkKQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6JPawlYyHdUuQvowAYszWEYMVGg5vGbtj/J0bpq1Ta3EQJMZCV3dHb2pfR11VdgM
         vFmQ3NSj3dDV//OcTfCYgnIWhqEf8ElTc1O9Vl/zkzZefHerPb+gbLYLtFuPA9gdnu
         Mce8HEkgsKn3H/EZRb28oci9ETygN9ol5FjMCL1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/355] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 15 Nov 2021 17:59:21 +0100
Message-Id: <20211115165314.745579930@linuxfoundation.org>
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
index 8b68879058132..049a68c59c137 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4066,7 +4066,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.33.0



