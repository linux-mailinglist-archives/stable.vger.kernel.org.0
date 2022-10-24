Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4960B3BE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiJXRPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbiJXROW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A8B8980A;
        Mon, 24 Oct 2022 08:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4DE2612A8;
        Mon, 24 Oct 2022 12:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60E2C433C1;
        Mon, 24 Oct 2022 12:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615777;
        bh=v+oCTLz2zmuXexYouYDiAiS/23A0xwl+4ZB8X2F/vFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxWCcVFThbgLCjbeQtzzYHg/0AV5JbGcsVaFRhKvMCA2c3uju10C1wmZzC6Fb0YBG
         I3+wjbNYtoGCALr7uxInq24iS6PdwMMoGiPkhpqI/UlVmTsGmZaHwIsCFBil8ejrZK
         mwy0NCGdy2st0MqMto3hh5sr+5C1gjoivYTmsTbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/530] crypto: hisilicon/qm - fix missing put dfx access
Date:   Mon, 24 Oct 2022 13:32:03 +0200
Message-Id: <20221024113102.200479518@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 5afc904f443de2afd31c4e0686ba178beede86fe ]

In function qm_cmd_write(), if function returns from
branch 'atomic_read(&qm->status.flags) == QM_STOP',
the got dfx access is forgotten to put.

Fixes: 607c191b371d ("crypto: hisilicon - support runtime PM for accelerator device")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b616d2d8e773..b8900a5dbf6e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1888,8 +1888,10 @@ static ssize_t qm_cmd_write(struct file *filp, const char __user *buffer,
 		return ret;
 
 	/* Judge if the instance is being reset. */
-	if (unlikely(atomic_read(&qm->status.flags) == QM_STOP))
-		return 0;
+	if (unlikely(atomic_read(&qm->status.flags) == QM_STOP)) {
+		ret = 0;
+		goto put_dfx_access;
+	}
 
 	if (count > QM_DBG_WRITE_LEN) {
 		ret = -ENOSPC;
-- 
2.35.1



