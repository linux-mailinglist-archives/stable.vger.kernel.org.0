Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153CA657BDE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiL1P0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiL1P0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3584C13FB2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A456152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5F5C433EF;
        Wed, 28 Dec 2022 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241162;
        bh=7bq7Cia6DbB/3reaPZ4aU3ExO4A4f6EOSUFJEvJxb8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvGFUX++Uq+JkCpdgK7NnJEFtX9M0SvcZkKL765nKvhS2FTmgsn5DIirCpGEItLjO
         EWMWDyEwIad/aMj+qnj3AEqhO+1NQIpqBEgJdu3TJZt8zG/hOkwaV+KuM0J0nYycsy
         TnTQYWWrS7YL9AQPfbjq5J3BNbqHZOBlV3BG1ZXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/731] usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
Date:   Wed, 28 Dec 2022 15:39:15 +0100
Message-Id: <20221228144309.539959933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0384e87e3fec735e47f1c133c796f32ef7a72a9b ]

I got the following report while doing device(mt6370-tcpc) load
test with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@34/tcpc/connector

The 'fwnode' set in tcpci_parse_config() which is called
in tcpci_register_port(), its node refcount is increased
in device_get_named_child_node(). It needs be put while
exiting, so call fwnode_handle_put() in the error path of
tcpci_register_port() and in tcpci_unregister_port() to
avoid leak.

Fixes: 5e85a04c8c0d ("usb: typec: add fwnode to tcpc")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221121062416.1026192-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 64e248117c41..5340a3a3a81b 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -817,8 +817,10 @@ struct tcpci *tcpci_register_port(struct device *dev, struct tcpci_data *data)
 		return ERR_PTR(err);
 
 	tcpci->port = tcpm_register_port(tcpci->dev, &tcpci->tcpc);
-	if (IS_ERR(tcpci->port))
+	if (IS_ERR(tcpci->port)) {
+		fwnode_handle_put(tcpci->tcpc.fwnode);
 		return ERR_CAST(tcpci->port);
+	}
 
 	return tcpci;
 }
@@ -827,6 +829,7 @@ EXPORT_SYMBOL_GPL(tcpci_register_port);
 void tcpci_unregister_port(struct tcpci *tcpci)
 {
 	tcpm_unregister_port(tcpci->port);
+	fwnode_handle_put(tcpci->tcpc.fwnode);
 }
 EXPORT_SYMBOL_GPL(tcpci_unregister_port);
 
-- 
2.35.1



