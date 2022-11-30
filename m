Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD663DF22
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiK3SoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiK3SoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9E893A52
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30DAACE1AD2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD07C433D6;
        Wed, 30 Nov 2022 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833835;
        bh=4lX1t1cAeiLv1956HblOOtIbXsiwCn351BBNmASwhU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgWSDqTUXJoEy8Kcfg3fL9BcvyitDtj8weQ/pfQRLEleyNcD4dKW84u9WOWf7N3x0
         V7ikxbcmGFetlRQH4/pMzzysWWzyH2Lnp4/K7BKDuV2i1VlnIjodMxktTXT9XJbqM9
         maupXuesWTibxm7VIcnbiBaV/mzr5GQC5Lzs8VZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/289] nvmet: fix memory leak in nvmet_subsys_attr_model_store_locked
Date:   Wed, 30 Nov 2022 19:20:17 +0100
Message-Id: <20221130180544.861376240@linuxfoundation.org>
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

From: Aleksandr Miloserdov <a.miloserdov@yadro.com>

[ Upstream commit becc4cac309dc867571f0080fde4426a6c2222e0 ]

Since model_number is allocated before it needs to be freed before
kmemdump_nul.

Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 7f52d9dac443..a79eadb953de 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1215,6 +1215,7 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 		const char *page, size_t count)
 {
 	int pos = 0, len;
+	char *val;
 
 	if (subsys->subsys_discovered) {
 		pr_err("Can't set model number. %s is already assigned\n",
@@ -1237,9 +1238,11 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 			return -EINVAL;
 	}
 
-	subsys->model_number = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!subsys->model_number)
+	val = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!val)
 		return -ENOMEM;
+	kfree(subsys->model_number);
+	subsys->model_number = val;
 	return count;
 }
 
-- 
2.35.1



