Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854E66088D1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJVIXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiJVIVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49722E042B;
        Sat, 22 Oct 2022 00:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BDAFB82DF2;
        Sat, 22 Oct 2022 07:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1976C433C1;
        Sat, 22 Oct 2022 07:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425479;
        bh=pgwEOrNfjoygXqCf/s4qyI7U4E29PrLsa3xhHvAaEdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTDgSmyGdZcz0Hz4NA904MrYm73HeE5Vfygeans9ATElps33WNIbSf8guTE+poGIW
         tKOK+YRdIMR0syCJSRuK6Pjh8OVyZMkYZ4DrW1EMUEIFM+rF4gkhi2AewQgw5G23cu
         +B7OAXagwWlQEfUONzUllumM+eGiqsHyAwD5Bryg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 514/717] crypto: hisilicon/qm - fix missing put dfx access
Date:   Sat, 22 Oct 2022 09:26:33 +0200
Message-Id: <20221022072521.012296213@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b4ca2eb034d7..eb82e9864d14 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2229,8 +2229,10 @@ static ssize_t qm_cmd_write(struct file *filp, const char __user *buffer,
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



