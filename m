Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE10A4D8376
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241051AbiCNMPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiCNMOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F2F38183;
        Mon, 14 Mar 2022 05:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93499B80DF6;
        Mon, 14 Mar 2022 12:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B49C340F4;
        Mon, 14 Mar 2022 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259884;
        bh=Yao7ToCNpFjtMRcuv6j2NxcYHhBNAshEJnMEhOi1Q88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsiA4CDMC5JC3433SPBNfD5c+zUi3g1mJFjmrQVx6oEaS6WQOx+Dn42NJQYhP6ukU
         Wnr9NVDvd6Vr7ZIW1VfqIpGDR3lDSo3XFU9XTGPdblPhdvKEVgmJLO//loxl7hjEQl
         8V+6SgX0HG+vSxEpRCXgBLtt2hO8pSM7DwRiQJ/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Suchy <danny@danysek.cz>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.15 110/110] Revert "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN"
Date:   Mon, 14 Mar 2022 12:54:52 +0100
Message-Id: <20220314112746.097346955@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 2566a89b9e163b2fcd104d6005e0149f197b8a48 which is
commit a2614140dc0f467a83aa3bb4b6ee2d6480a76202 upstream.

The above change depends on upstream commit 0faf890fc519 ("net: dsa:
drop rtnl_lock from dsa_slave_switchdev_event_work"), which is not
present in linux-5.15.y. Without that change, waiting for the switchdev
workqueue causes deadlocks on the rtnl_mutex.

Backporting the dependency commit isn't trivial/desirable, since it
requires that the following dependencies of the dependency are also
backported:

df405910ab9f net: dsa: sja1105: wait for dynamic config command completion on writes too
eb016afd83a9 net: dsa: sja1105: serialize access to the dynamic config interface
2468346c5677 net: mscc: ocelot: serialize access to the MAC table
f7eb4a1c0864 net: dsa: b53: serialize access to the ARL table
cf231b436f7c net: dsa: lantiq_gswip: serialize access to the PCE registers
338a3a4745aa net: dsa: introduce locking for the address lists on CPU and DSA ports

and then this bugfix on top:

8940e6b669ca ("net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held")

Reported-by: Daniel Suchy <danny@danysek.cz>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    7 -------
 include/net/dsa.h                |    1 -
 net/dsa/dsa.c                    |    1 -
 net/dsa/dsa_priv.h               |    1 +
 4 files changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2291,13 +2291,6 @@ static int mv88e6xxx_port_vlan_del(struc
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
-	/* The ATU removal procedure needs the FID to be mapped in the VTU,
-	 * but FDB deletion runs concurrently with VLAN deletion. Flush the DSA
-	 * switchdev workqueue to ensure that all FDB entries are deleted
-	 * before we remove the VLAN.
-	 */
-	dsa_flush_workqueue();
-
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_port_get_pvid(chip, port, &pvid);
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1056,7 +1056,6 @@ void dsa_unregister_switch(struct dsa_sw
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
-void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,7 +349,6 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
-EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,6 +170,7 @@ void dsa_tag_driver_put(const struct dsa
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
+void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)


