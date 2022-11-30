Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601D063DFAE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiK3Stk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiK3St1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572594B755
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E17AB81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4E0C433D6;
        Wed, 30 Nov 2022 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834163;
        bh=186T62hBf/ZzmUvMw6tQuHpVSIrKQT8Ok/vSo6ctr8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiTK4jZ/5pl9BPkFFeR1VNvinuoCpfgTSrUp/h8BeuAqljGPEkUTBWXUCCJPQ28Co
         EvJZrtX9uzozuwOyqr/d/Lo6k/BfG9wBU/CAklGINJkzPS6XpNVmnceQ7HOHvpzY8w
         4/IjB7NrNAoSRZUYjYQ/C1c0LxcT6CXzACwFPzfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 153/289] net: wwan: t7xx: Fix the ACPI memory leak
Date:   Wed, 30 Nov 2022 19:22:18 +0100
Message-Id: <20221130180547.603957560@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 08e8a949f684e1fbc4b1efd2337d72ec8f3613d9 ]

The ACPI buffer memory (buffer.pointer) should be freed as the
buffer is not used after acpi_evaluate_object(), free it to
prevent memory leak.

Fixes: 13e920d93e37 ("net: wwan: t7xx: Add core components")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1669119580-28977-1-git-send-email-guohanjun@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_modem_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index 3458af31e864..7d0f5e4f0a78 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -165,6 +165,8 @@ static int t7xx_acpi_reset(struct t7xx_pci_dev *t7xx_dev, char *fn_name)
 		return -EFAULT;
 	}
 
+	kfree(buffer.pointer);
+
 #endif
 	return 0;
 }
-- 
2.35.1



