Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F324CF5BB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiCGJai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238494AbiCGJ3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7D1DFEB;
        Mon,  7 Mar 2022 01:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FCC5B810C2;
        Mon,  7 Mar 2022 09:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFEBC340F3;
        Mon,  7 Mar 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645225;
        bh=i/rdGyW6fSrYnsb71QPxSkriOn3JnYMA/1oexnxwVhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9Cv2ANwMo7w55ziBV0moK00X8L+n5nAOWXUVBVJ+wh9slEZEb9nMTr50J59j6e7A
         beh5sVf1MqEAcItUEX+9qvrb+CRDkLxczEbBsEqnVOdbwKpoiPtk5gIfFlKs/3Unzd
         XrQDtyZZjCZqx4kltSZhmOXzO0K69FSj1GA3yPrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 26/64] net: dcb: flush lingering app table entries for unregistered devices
Date:   Mon,  7 Mar 2022 10:18:59 +0100
Message-Id: <20220307091639.887992052@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 91b0383fef06f20b847fa9e4f0e3054ead0b1a1b upstream.

If I'm not mistaken (and I don't think I am), the way in which the
dcbnl_ops work is that drivers call dcb_ieee_setapp() and this populates
the application table with dynamically allocated struct dcb_app_type
entries that are kept in the module-global dcb_app_list.

However, nobody keeps exact track of these entries, and although
dcb_ieee_delapp() is supposed to remove them, nobody does so when the
interface goes away (example: driver unbinds from device). So the
dcb_app_list will contain lingering entries with an ifindex that no
longer matches any device in dcb_app_lookup().

Reclaim the lost memory by listening for the NETDEV_UNREGISTER event and
flushing the app table entries of interfaces that are now gone.

In fact something like this used to be done as part of the initial
commit (blamed below), but it was done in dcbnl_exit() -> dcb_flushapp(),
essentially at module_exit time. That became dead code after commit
7a6b6f515f77 ("DCB: fix kconfig option") which essentially merged
"tristate config DCB" and "bool config DCBNL" into a single "bool config
DCB", so net/dcb/dcbnl.c could not be built as a module anymore.

Commit 36b9ad8084bd ("net/dcb: make dcbnl.c explicitly non-modular")
recognized this and deleted dcbnl_exit() and dcb_flushapp() altogether,
leaving us with the version we have today.

Since flushing application table entries can and should be done as soon
as the netdevice disappears, fundamentally the commit that is to blame
is the one that introduced the design of this API.

Fixes: 9ab933ab2cc8 ("dcbnl: add appliction tlv handlers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2063,10 +2063,54 @@ u8 dcb_ieee_getapp_default_prio_mask(con
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_default_prio_mask);
 
+static void dcbnl_flush_dev(struct net_device *dev)
+{
+	struct dcb_app_type *itr, *tmp;
+
+	spin_lock(&dcb_lock);
+
+	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
+		if (itr->ifindex == dev->ifindex) {
+			list_del(&itr->list);
+			kfree(itr);
+		}
+	}
+
+	spin_unlock(&dcb_lock);
+}
+
+static int dcbnl_netdevice_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		if (!dev->dcbnl_ops)
+			return NOTIFY_DONE;
+
+		dcbnl_flush_dev(dev);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block dcbnl_nb __read_mostly = {
+	.notifier_call  = dcbnl_netdevice_event,
+};
+
 static int __init dcbnl_init(void)
 {
+	int err;
+
 	INIT_LIST_HEAD(&dcb_app_list);
 
+	err = register_netdevice_notifier(&dcbnl_nb);
+	if (err)
+		return err;
+
 	rtnl_register(PF_UNSPEC, RTM_GETDCB, dcb_doit, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_SETDCB, dcb_doit, NULL, 0);
 


