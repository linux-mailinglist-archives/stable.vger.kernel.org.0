Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9847E4BBAA5
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiBROdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:33:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiBROdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:33:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E45125AE66
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DE5AB82656
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32573C340E9;
        Fri, 18 Feb 2022 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194763;
        bh=oFRvxdgPk+K3HH/nbfQvfcTb83H14xfSN9WxWyRmQXM=;
        h=Subject:To:Cc:From:Date:From;
        b=CleBnv3zvddq8xdpfFC6PM8xpyH09Kz94Jk85D4Boo+8SRQ0ArnUG0Vz421Fz4oHo
         23aFCEy0mOANfqsgU1dYylBNa+fcTRwV9efiPgT2mtbLbBs62+aIFONW1I5KRq2psj
         bA+wYTUIGlMGrL4kG5xaNoPOR+8woC4Su90BLWQg=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before" failed to apply to 5.10-stable tree
To:     vladimir.oltean@nxp.com, davem@davemloft.net, rafael.richter@gin.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:32:40 +0100
Message-ID: <16451947603187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2614140dc0f467a83aa3bb4b6ee2d6480a76202 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 11 Feb 2022 19:45:06 +0200
Subject: [PATCH] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
 removing VLAN

mv88e6xxx is special among DSA drivers in that it requires the VTU to
contain the VID of the FDB entry it modifies in
mv88e6xxx_port_db_load_purge(), otherwise it will return -EOPNOTSUPP.

Sometimes due to races this is not always satisfied even if external
code does everything right (first deletes the FDB entries, then the
VLAN), because DSA commits to hardware FDB entries asynchronously since
commit c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification").

Therefore, the mv88e6xxx driver must close this race condition by
itself, by asking DSA to flush the switchdev workqueue of any FDB
deletions in progress, prior to exiting a VLAN.

Fixes: c9eb3e0f8701 ("net: dsa: Add support for learning FDB through notification")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8530dbe403f4..ab1676553714 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2284,6 +2284,13 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
+	/* The ATU removal procedure needs the FID to be mapped in the VTU,
+	 * but FDB deletion runs concurrently with VLAN deletion. Flush the DSA
+	 * switchdev workqueue to ensure that all FDB entries are deleted
+	 * before we remove the VLAN.
+	 */
+	dsa_flush_workqueue();
+
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_port_get_pvid(chip, port, &pvid);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b3e4e7413b..85a5ba3772f5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1187,6 +1187,7 @@ void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
+void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index d9d0d227092c..c43f7446a75d 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,6 +349,7 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
+EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 760306f0012f..23c79e91ac67 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -147,7 +147,6 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
-void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)

