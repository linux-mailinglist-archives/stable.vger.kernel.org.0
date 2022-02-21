Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5EB4BE90C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiBUJuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352951AbiBUJsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B96C12ADB;
        Mon, 21 Feb 2022 01:21:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED5FB608C4;
        Mon, 21 Feb 2022 09:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE41AC340E9;
        Mon, 21 Feb 2022 09:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435306;
        bh=cNKbHEAwNRiOzp4mcFCpsdlbV3sVT1yjGvzETBBzb9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCT40HzufNtAs9H7ZNi9zBzkzvPS79AYOHFQreSlXhSvmy29AGhCogJFlPsEXk77b
         Z1GfcvBanyQpcgPeQcGAM8jyIorX6Xa4MkPxcEjUeMe5qWY6uZTitAsI2//D0NIXvg
         wzxM0lGVG0tcCI1PCQLXsa45gVQ2+cLYITNg2t0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Richter <rafael.richter@gin.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 110/227] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN
Date:   Mon, 21 Feb 2022 09:48:49 +0100
Message-Id: <20220221084938.519965985@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit a2614140dc0f467a83aa3bb4b6ee2d6480a76202 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    7 +++++++
 include/net/dsa.h                |    1 +
 net/dsa/dsa.c                    |    1 +
 net/dsa/dsa_priv.h               |    1 -
 4 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2290,6 +2290,13 @@ static int mv88e6xxx_port_vlan_del(struc
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
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1094,6 +1094,7 @@ void dsa_unregister_switch(struct dsa_sw
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
+void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,6 +349,7 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
+EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,7 +170,6 @@ void dsa_tag_driver_put(const struct dsa
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
-void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)


