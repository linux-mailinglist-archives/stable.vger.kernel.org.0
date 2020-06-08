Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133341F23B4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgFHXPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgFHXPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2875120659;
        Mon,  8 Jun 2020 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658150;
        bh=7AjkuNnUHAomKFcixfNAvXlLVD+ewVcKV2HKY7ByS1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKMcNHBgsRCgtBG13ql40VV2fpy2+AM2TisUf/F7kjV6AzrWNi7EhA7CKvZCUqEuU
         7xC+mnHAbIsN6E9NYMAZZDwygU9UCeSxHpFbK+Zfr0G22cRBE/+mQ4PTAhveZVAPs1
         pmFk19N8CeBMxI5moXkYHENgoVY6IDIppkhHxgM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.6 183/606] ipack: tpci200: fix error return code in tpci200_register()
Date:   Mon,  8 Jun 2020 19:05:08 -0400
Message-Id: <20200608231211.3363633-183-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 133317479f0324f6faaf797c4f5f3e9b1b36ce35 upstream.

Fix to return negative error code -ENOMEM from the ioremap() error handling
case instead of 0, as done elsewhere in this function.

Fixes: 43986798fd50 ("ipack: add error handling for ioremap_nocache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Link: https://lore.kernel.org/r/20200507094237.13599-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/carriers/tpci200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 23445ebfda5c..ec71063fff76 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -306,6 +306,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to map driver user space!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
+		res = -ENOMEM;
 		goto out_release_mem8_space;
 	}
 
-- 
2.25.1

