Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C871E2B78
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391503AbgEZTFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391501AbgEZTFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA76420776;
        Tue, 26 May 2020 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519923;
        bh=BWfUhi6QYQqiecRQFU7Lv31BU1wSKaNQc+VwZW0cAFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmp1CtZlDF7+QEe249B8zECTycbyCx4/d+sqPghBTZUYwk9BJFreny7Kjchqw55uo
         DTg4hVKf2O3Lov7DOjalNtISByuqZIHssXbDeBc8keCjJ56I6hSb7KsZVK2uFqGt9c
         6pYmKy2EkJqF2yYTPeKSEbWfkao2kMsdQ6usphGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 4.19 71/81] ipack: tpci200: fix error return code in tpci200_register()
Date:   Tue, 26 May 2020 20:53:46 +0200
Message-Id: <20200526183934.932044758@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/ipack/carriers/tpci200.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -309,6 +309,7 @@ static int tpci200_register(struct tpci2
 			"(bn 0x%X, sn 0x%X) failed to map driver user space!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
+		res = -ENOMEM;
 		goto out_release_mem8_space;
 	}
 


