Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0534E2A33
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349140AbiCUOOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349031AbiCUOG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:06:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A72B6E58;
        Mon, 21 Mar 2022 07:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78E94B816CE;
        Mon, 21 Mar 2022 14:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569C0C340ED;
        Mon, 21 Mar 2022 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871323;
        bh=o9+D1OdqKcCLXQsIocAVqpLGD93PUevkaqmZLJxtPsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=136uKGzP878bjPkpYB+Nym1fZeG1ukqojMyl+ntSbV+2DkA6J8kiVtXLxP80V3rTr
         tiiwlG9eirFKCn6w1WLkVmF6otlV/bSX9xxnxLDGctqa+NvyBBKLygyj3kYoiJ39hN
         vgoXHvdwDfXqefoyUEHztC2k8dqQNuTQzi91AUgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 21/37] net: dsa: Add missing of_node_put() in dsa_port_parse_of
Date:   Mon, 21 Mar 2022 14:53:03 +0100
Message-Id: <20220321133221.911185229@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
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

[ Upstream commit cb0b430b4e3acc88c85e0ad2e25f2a25a5765262 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 6d4e5c570c2d ("net: dsa: get port type at parse time")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220316082602.10785-1-linmq006@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7578b1350f18..e64ef196a984 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1327,6 +1327,7 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 		const char *user_protocol;
 
 		master = of_find_net_device_by_node(ethernet);
+		of_node_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
-- 
2.34.1



