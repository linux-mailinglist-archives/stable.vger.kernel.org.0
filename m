Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F5564A1CD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiLLNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiLLNpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:45:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81115717
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A43B80D56
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC723C433D2;
        Mon, 12 Dec 2022 13:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852687;
        bh=gEOZf6HzlEc+GWmzQssPv9wI9yL8b73d91pPhj5iF5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWlkWU7qIf2dD2jF8AX6001qRQ2RCM7Wy6CpLIR3OCw3ar9B1QAHKEsxIXk2b9ql7
         Q4oLHahjYFu4HD/yH5NN8WGy/PrLH0ORomvbs9f46/lJfcQNz2Mh8n5k8oFKCkWdPw
         vKzmLlefv/o9J29HAuDuNc9T/u30Rf9akkgoQsWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 132/157] net: wwan: iosm: fix memory leak in ipc_mux_init()
Date:   Mon, 12 Dec 2022 14:18:00 +0100
Message-Id: <20221212130940.238414334@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 23353efc26e98b61b925274ecbb8f0610f69a8aa ]

When failed to alloc ipc_mux->ul_adb.pp_qlt in ipc_mux_init(), ipc_mux
is not released.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
Link: https://lore.kernel.org/r/20221203020903.383235-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.c b/drivers/net/wwan/iosm/iosm_ipc_mux.c
index 9c7a9a2a1f25..fc928b298a98 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.c
@@ -332,6 +332,7 @@ struct iosm_mux *ipc_mux_init(struct ipc_mux_config *mux_cfg,
 			if (!ipc_mux->ul_adb.pp_qlt[i]) {
 				for (j = i - 1; j >= 0; j--)
 					kfree(ipc_mux->ul_adb.pp_qlt[j]);
+				kfree(ipc_mux);
 				return NULL;
 			}
 		}
-- 
2.35.1



