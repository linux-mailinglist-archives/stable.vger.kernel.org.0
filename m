Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF66AE9E4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCGR2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCGR2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA4E8F720
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45E93CE1C5B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395E8C433D2;
        Tue,  7 Mar 2023 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209808;
        bh=fDXQaiwd3L1K5OwugWn2eiInNuyj6M7dFn8Gu9ct/OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L76G0Bz8hdavidFKptsfUNXVhxUMitRKW4v5kwi2QEDB7RssuTbYa1LGM9HH7SDcl
         PQn4n47NB0h8qohZUkgnfqvlVhlC/4iyE8/5x7igAwlv6B3DJKDY/Q4ubFjNpD/paF
         mzMLCSg3yJT9Lzs9UK5l0bIvht45r+0t81PF1P7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0339/1001] gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
Date:   Tue,  7 Mar 2023 17:51:51 +0100
Message-Id: <20230307170036.190888121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 9afdf98cfdfa2ba8ec068cf08c5fcdc1ed8daf3f ]

In ipu_add_client_devices(), we need to call of_node_put() for
reference returned by of_graph_get_port_by_id() in fail path.

Fixes: 17e052175039 ("gpu: ipu-v3: Do not bail out on missing optional port nodes")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 118318513e2d2..c35eac1116f5f 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1165,6 +1165,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
-- 
2.39.2



