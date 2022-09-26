Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A48F5EA361
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiIZLYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbiIZLXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A00DBD1;
        Mon, 26 Sep 2022 03:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 694EC609FB;
        Mon, 26 Sep 2022 10:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DEFC433D6;
        Mon, 26 Sep 2022 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188756;
        bh=BS1XGg5eMSFHVP5RgKDbzwAQjNDtngFPTpm/L+RCOTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSENpP22clXf9vbGGf0jT7O2Z0WOlHzWYEzq111Yn5CEE1kEJn/mvSYWdUUetzH0D
         PjQty0qseDveFH2Xaiea0NsE8oeCKfT5UPKt2w9W5egxPzxdK72+/UxCbChAn3PoKj
         Vkhh5E25WuAsB9KqjGe8OA7FmqjH7+m5Zg2mjj28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/148] net/smc: Stop the CLC flow if no link to map buffers on
Date:   Mon, 26 Sep 2022 12:12:25 +0200
Message-Id: <20220926100800.284942764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit e738455b2c6dcdab03e45d97de36476f93f557d2 ]

There might be a potential race between SMC-R buffer map and
link group termination.

smc_smcr_terminate_all()     | smc_connect_rdma()
--------------------------------------------------------------
                             | smc_conn_create()
for links in smcibdev        |
        schedule links down  |
                             | smc_buf_create()
                             |  \- smcr_buf_map_usable_links()
                             |      \- no usable links found,
                             |         (rmb->mr = NULL)
                             |
                             | smc_clc_send_confirm()
                             |  \- access conn->rmb_desc->mr[]->rkey
                             |     (panic)

During reboot and IB device module remove, all links will be set
down and no usable links remain in link groups. In such situation
smcr_buf_map_usable_links() should return an error and stop the
CLC flow accessing to uninitialized mr.

Fixes: b9247544c1bc ("net/smc: convert static link ID instances to support multiple links")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Link: https://lore.kernel.org/r/1663656189-32090-1-git-send-email-guwen@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 7401ec67ebcf..2eafefa15a1a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1980,7 +1980,7 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 				     struct smc_buf_desc *buf_desc, bool is_rmb)
 {
-	int i, rc = 0;
+	int i, rc = 0, cnt = 0;
 
 	/* protect against parallel link reconfiguration */
 	mutex_lock(&lgr->llc_conf_mutex);
@@ -1993,9 +1993,12 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 			rc = -ENOMEM;
 			goto out;
 		}
+		cnt++;
 	}
 out:
 	mutex_unlock(&lgr->llc_conf_mutex);
+	if (!rc && !cnt)
+		rc = -EINVAL;
 	return rc;
 }
 
-- 
2.35.1



