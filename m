Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C225D37C5A8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhELPmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236335AbhELPho (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B91B61418;
        Wed, 12 May 2021 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832756;
        bh=dsNNgavrktCZFFwGDrO2hZ2DwjhGRSmOigrFpMRTxPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCt6EpST3UXWH1M0Othjpgv1mNIJYfnCNKykqm5eh55oIfTFGSyuNclwk50VivO/D
         6EcR+tYqQjRqn8GHiGzQE8y0TpjVVJWk+HkrGjWqbBUh2jbqNKHhoZuvFcoM3aikRS
         ATcvX8NI9d+zVuK0fGgqbAcd8C84plQfTTYglJrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/530] ima: Fix the error code for restoring the PCR value
Date:   Wed, 12 May 2021 16:47:56 +0200
Message-Id: <20210512144831.814041840@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 7990ccafaa37dc6d8bb095d4d7cd997e8903fd10 ]

In ima_restore_measurement_list(), hdr[HDR_PCR].data is pointing to a
buffer of type u8, which contains the dumped 32-bit pcr value.
Currently, only the least significant byte is used to restore the pcr
value. We should convert hdr[HDR_PCR].data to a pointer of type u32
before fetching the value to restore the correct pcr value.

Fixes: 47fdee60b47f ("ima: use ima_parse_buf() to parse measurements headers")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_template.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 1e89e2d3851f..f83255a39e65 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -468,8 +468,8 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 			}
 		}
 
-		entry->pcr = !ima_canonical_fmt ? *(hdr[HDR_PCR].data) :
-			     le32_to_cpu(*(hdr[HDR_PCR].data));
+		entry->pcr = !ima_canonical_fmt ? *(u32 *)(hdr[HDR_PCR].data) :
+			     le32_to_cpu(*(u32 *)(hdr[HDR_PCR].data));
 		ret = ima_restore_measurement_entry(entry);
 		if (ret < 0)
 			break;
-- 
2.30.2



