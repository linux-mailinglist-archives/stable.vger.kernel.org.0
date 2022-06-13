Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBF54930E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380921AbiFMOK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380850AbiFMOHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81768985A6;
        Mon, 13 Jun 2022 04:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 198516124E;
        Mon, 13 Jun 2022 11:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC30C3411C;
        Mon, 13 Jun 2022 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120485;
        bh=/lWHFpte0nQhGTo7XI8GUdlZRuC2Mn0hannG7wMM4LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkdZfkwT6KMg2EQ1awNSizNnfr8jfYYUa7levQrapJStFgg7rkJqCAm68DkXbYf3s
         0WeXkEMmzUXhUi1l9WV7nSTFbqWufhiyxUd/oMmVjJlFMybgVR0WzPUXsCschDayQ0
         sPTomRTe4TsmvAf1dlvEJyy3QCrs9JxpCSCJ6rV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 050/298] soc: rockchip: Fix refcount leak in rockchip_grf_init
Date:   Mon, 13 Jun 2022 12:09:04 +0200
Message-Id: <20220613094926.468096123@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9b59588d8be91c96bfb0371e912ceb4f16315dbf ]

of_find_matching_node_and_match returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 4c58063d4258 ("soc: rockchip: add driver handling grf setup")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220516072013.19731-1-linmq006@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 494cf2b5bf7b..343ff61ccccb 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -148,12 +148,14 @@ static int __init rockchip_grf_init(void)
 		return -ENODEV;
 	if (!match || !match->data) {
 		pr_err("%s: missing grf data\n", __func__);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
 	grf_info = match->data;
 
 	grf = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(grf)) {
 		pr_err("%s: could not get grf syscon\n", __func__);
 		return PTR_ERR(grf);
-- 
2.35.1



