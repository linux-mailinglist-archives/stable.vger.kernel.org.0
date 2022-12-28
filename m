Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7559658196
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiL1Q3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiL1Q3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF641F0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814AFB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB390C433D2;
        Wed, 28 Dec 2022 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244740;
        bh=inN9e4ytR+NXrAHnhQ1/s4gFHfne7lWj4TQ3jrvLG2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFkp5n+SecQIVtCFo9UvXwxHX9WBUR3k3gkGjYd3ybCO5Qf5t2HCVJB3HxZC3kfKC
         FNvnprhPla6+zeJh9nQqYFjVSlys+2cCYgDWn0OuJ0ctti7xQbSxyPkzHoSK7aPGB/
         TNsPDsAijDTMyXsmUeGiOKb8EehwxXVb1mkU81Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0728/1146] usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
Date:   Wed, 28 Dec 2022 15:37:47 +0100
Message-Id: <20221228144349.919257800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 1ab30c610630da5391a373cddb8a065bf4c4bc01 ]

I got the following report while doing device(mt6370-tcpc) load
test with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@34

The 'parent' returned by fwnode_get_parent() with refcount incremented.
it needs be put after using.

Fixes: 6fadd72943b8 ("usb: roles: get usb-role-switch from parent")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221122111226.251588-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/roles/class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index dfaed7eee94f..32e6d19f7011 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -106,10 +106,13 @@ usb_role_switch_is_parent(struct fwnode_handle *fwnode)
 	struct fwnode_handle *parent = fwnode_get_parent(fwnode);
 	struct device *dev;
 
-	if (!parent || !fwnode_property_present(parent, "usb-role-switch"))
+	if (!fwnode_property_present(parent, "usb-role-switch")) {
+		fwnode_handle_put(parent);
 		return NULL;
+	}
 
 	dev = class_find_device_by_fwnode(role_class, parent);
+	fwnode_handle_put(parent);
 	return dev ? to_role_switch(dev) : ERR_PTR(-EPROBE_DEFER);
 }
 
-- 
2.35.1



