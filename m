Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F30351A8E8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355895AbiEDRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356906AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C75F47066;
        Wed,  4 May 2022 09:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95C6AB827A3;
        Wed,  4 May 2022 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC29C385AA;
        Wed,  4 May 2022 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683381;
        bh=3hl5Abyr5dqFZ/zVqmKDc6D8kC4kQ2wP/P9hBWlUJCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pscxf8jWR3/Ue76JBwcnW3uYbBYOz9YnxBLMkJyrx/xUJnOfCZYPQDODQDsfBT0Dp
         IdHFMkLIu6bmuDQ36JPItmcuaPysTcO6dyh/2snI5WoKJa7A8/Vr+YbcpmdACIY/L8
         DE3Sf7L/nRr53eoCEvX3ZRAoJBlu91fVOCy5qKcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 066/225] tee: optee: add missing mutext_destroy in optee_ffa_probe
Date:   Wed,  4 May 2022 18:45:04 +0200
Message-Id: <20220504153116.059763982@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit b5e22886839ae466fcf03295150094516c0fd8eb ]

The error handling code of optee_ffa_probe misses the mutex_destroy of
ffa.mutex when mutext_init succeeds.

Fix this by adding mutex_destory of ffa.mutex at the error handling part

Fixes: aceeafefff73 ("optee: use driver internal tee_context for some rpc")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index f744ab15bf2c..30a6119a2b16 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -894,6 +894,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	rhashtable_free_and_destroy(&optee->ffa.global_ids, rh_free_fn, NULL);
 	optee_supp_uninit(&optee->supp);
 	mutex_destroy(&optee->call_queue.mutex);
+	mutex_destroy(&optee->ffa.mutex);
 err_unreg_supp_teedev:
 	tee_device_unregister(optee->supp_teedev);
 err_unreg_teedev:
-- 
2.35.1



