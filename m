Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C543C549093
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353310AbiFMMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354894AbiFMMXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:23:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE043150C;
        Mon, 13 Jun 2022 04:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3300CB80E92;
        Mon, 13 Jun 2022 11:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2D0C34114;
        Mon, 13 Jun 2022 11:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118239;
        bh=zE4buU9Rak3E8B5T5HsD+nJsRxnOIs/mXRe++VDPmJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP4x4Vd4rZRaPciW+2ig0v1HqBUqtQ/xn7ZgYGDKujdPM8e47o+qhoyqFX/jeN+aT
         MwVvPxjlaMLJjjsnqJDfo/Qd8NJlmiG6uqMvZb+UcglKBx6q3eWb2GC090geomjcFI
         O3Mzfqwsr2Gr6fIj6P9vY6+m9uCCUMf51N81jGPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/172] lkdtm/bugs: Check for the NULL pointer after calling kmalloc
Date:   Mon, 13 Jun 2022 12:09:24 +0200
Message-Id: <20220613094851.365027910@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 4a9800c81d2f34afb66b4b42e0330ae8298019a2 ]

As the possible failure of the kmalloc(), the not_checked and checked
could be NULL pointer.
Therefore, it should be better to check it in order to avoid the
dereference of the NULL pointer.
Also, we need to kfree the 'not_checked' and 'checked' to avoid
the memory leak if fails.
And since it is just a test, it may directly return without error
number.

Fixes: ae2e1aad3e48 ("drivers/misc/lkdtm/bugs.c: add arithmetic overflow and array bounds checks")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220120092936.1874264-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/bugs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index a337f97b30e2..d39b8139b096 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -231,6 +231,11 @@ void lkdtm_ARRAY_BOUNDS(void)
 
 	not_checked = kmalloc(sizeof(*not_checked) * 2, GFP_KERNEL);
 	checked = kmalloc(sizeof(*checked) * 2, GFP_KERNEL);
+	if (!not_checked || !checked) {
+		kfree(not_checked);
+		kfree(checked);
+		return;
+	}
 
 	pr_info("Array access within bounds ...\n");
 	/* For both, touch all bytes in the actual member size. */
-- 
2.35.1



