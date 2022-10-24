Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5709660A557
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiJXMXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiJXMWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047AB2E6B5;
        Mon, 24 Oct 2022 04:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92041612E8;
        Mon, 24 Oct 2022 11:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E5BC433D6;
        Mon, 24 Oct 2022 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612717;
        bh=dwYvbXJVWzetlCsNi7yucSsFrcK5alNlEyvytNaqAD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWL0S/ZgBBo/tA55e9BPZlevVRiEY0gA/UTbJegviHhwB0p0HXERwx4Wvw63N0DmR
         bUiMnrTo/KAOIBt4X3G/06SLpAcdx3yEP1S02CE3vq3B6l+qniZugpxeLUpn+4QD2T
         TBB6aG23COuSw1svp3VTF+pqeGQe+TXkG8xxOP00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/229] net: mvpp2: fix mvpp2 debugfs leak
Date:   Mon, 24 Oct 2022 13:30:12 +0200
Message-Id: <20221024113002.058382203@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 0152dfee235e87660f52a117fc9f70dc55956bb4 ]

When mvpp2 is unloaded, the driver specific debugfs directory is not
removed, which technically leads to a memory leak. However, this
directory is only created when the first device is probed, so the
hardware is present. Removing the module is only something a developer
would to when e.g. testing out changes, so the module would be
reloaded. So this memory leak is minor.

The original attempt in commit fe2c9c61f668 ("net: mvpp2: debugfs: fix
memory leak when using debugfs_lookup()") that was labelled as a memory
leak fix was not, it fixed a refcount leak, but in doing so created a
problem when the module is reloaded - the directory already exists, but
mvpp2_root is NULL, so we lose all debugfs entries. This fix has been
reverted.

This is the alternative fix, where we remove the offending directory
whenever the driver is unloaded.

Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Link: https://lore.kernel.org/r/E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 10 ++++++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 13 ++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 46911b67b039..23f60bc5d48f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1107,5 +1107,6 @@ void mvpp2_percpu_write_relaxed(struct mvpp2 *priv, int cpu, u32 offset,
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name);
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
+void mvpp2_dbgfs_exit(void);
 
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 87d9cbe10cec..004e0fac5455 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -648,6 +648,13 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	return 0;
 }
 
+static struct dentry *mvpp2_root;
+
+void mvpp2_dbgfs_exit(void)
+{
+	debugfs_remove(mvpp2_root);
+}
+
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 {
 	debugfs_remove_recursive(priv->dbgfs_dir);
@@ -655,10 +662,9 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	struct dentry *mvpp2_dir, *mvpp2_root;
+	struct dentry *mvpp2_dir;
 	int ret, i;
 
-	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 52fdb200a0c7..788fe627e78a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5417,7 +5417,18 @@ static struct platform_driver mvpp2_driver = {
 	},
 };
 
-module_platform_driver(mvpp2_driver);
+static int __init mvpp2_driver_init(void)
+{
+	return platform_driver_register(&mvpp2_driver);
+}
+module_init(mvpp2_driver_init);
+
+static void __exit mvpp2_driver_exit(void)
+{
+	platform_driver_unregister(&mvpp2_driver);
+	mvpp2_dbgfs_exit();
+}
+module_exit(mvpp2_driver_exit);
 
 MODULE_DESCRIPTION("Marvell PPv2 Ethernet Driver - www.marvell.com");
 MODULE_AUTHOR("Marcin Wojtas <mw@semihalf.com>");
-- 
2.35.1



