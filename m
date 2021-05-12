Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AEA37C9C5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhELQVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240109AbhELQRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A05F161D66;
        Wed, 12 May 2021 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834195;
        bh=qCpub1EBC4LxlrsnqNtuH2LE5sbD4F53BiE8+uFilXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzqJe6fi8YPsCi7NNDmjgdnAIejJRwlOm33wxriZzZmDe9d9pPAXK8ES6m5J7hkVa
         LzZ3bZ2Hbcib4Xic1Ae0Re9xkjgn6syhsRUAq54AYVWDtKW+af9fHw+A3m03y36tvH
         uSZllUxIR/YpiMSq16SdP+Mx9NwvlfcyP7AO1HmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 411/601] ima: Fix the error code for restoring the PCR value
Date:   Wed, 12 May 2021 16:48:08 +0200
Message-Id: <20210512144841.372646074@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index e22e510ae92d..4e081e650047 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -494,8 +494,8 @@ int ima_restore_measurement_list(loff_t size, void *buf)
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



