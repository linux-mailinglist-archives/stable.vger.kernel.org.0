Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2787030C126
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhBBOOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhBBOMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4CB65043;
        Tue,  2 Feb 2021 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273954;
        bh=ag7Rln3xdz2wehpBX7M3kDZf5akHxKPQ0ORm6nQ4Rcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEcMZgmAzjsvR9ruhVu2n/R/stRm3wGnc+cuW4UhTF7qI3aIvxIqKZHAuNbXlfc8k
         SO7neT6tZhpeW0UsUabM3v/wjPebry5UqJKMgIrPaZq9smC24IkVhRMkOM8NPbioSk
         /+vKPPoKVoV5uJiUA0LVQExn6H4J+P3vK9MCma0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 29/30] team: protect features update by RCU to avoid deadlock
Date:   Tue,  2 Feb 2021 14:39:10 +0100
Message-Id: <20210202132943.331242091@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

commit f0947d0d21b219e03940b9be6628a43445c0de7a upstream.

Function __team_compute_features() is protected by team->lock
mutex when it is called from team_compute_features() used when
features of an underlying device is changed. This causes
a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
is fired due to change propagated from team driver (e.g. MTU
change). It's because callbacks like team_change_mtu() or
team_vlan_rx_{add,del}_vid() protect their port list traversal
by team->lock mutex.

Example (r8169 case where this driver disables TSO for certain MTU
values):
...
[ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
[ 6391.358602]  team_device_event+0x9d/0x160 [team]
[ 6391.363756]  notifier_call_chain+0x47/0x70
[ 6391.368329]  netdev_update_features+0x56/0x60
[ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
[ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
[ 6391.387022]  dev_set_mtu+0x52/0x90
[ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
[ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
[ 6391.399963]  do_setlink+0x231/0xf50
...

In fact team_compute_features() called from team_device_event()
does not need to be protected by team->lock mutex and rcu_read_lock()
is sufficient there for port list traversal.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Cc: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20210125074416.4056484-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/team/team.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1002,7 +1002,8 @@ static void __team_compute_features(stru
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 
-	list_for_each_entry(port, &team->port_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
 					port->dev->vlan_features,
 					TEAM_VLAN_FEATURES);
@@ -1016,6 +1017,7 @@ static void __team_compute_features(stru
 		if (port->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = port->dev->hard_header_len;
 	}
+	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
 	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
@@ -1030,9 +1032,7 @@ static void __team_compute_features(stru
 
 static void team_compute_features(struct team *team)
 {
-	mutex_lock(&team->lock);
 	__team_compute_features(team);
-	mutex_unlock(&team->lock);
 	netdev_change_features(team->dev);
 }
 


