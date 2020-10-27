Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A878929B176
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896821AbgJ0Oah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902112AbgJ0O34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69C120780;
        Tue, 27 Oct 2020 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808996;
        bh=ptos/kFt8+ZQBIpvrfHdAkl9k25O/e2wQYqrPNyGQ2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URmnQB/SYyFycNAgl7aFHGG01E4tF4j9jEMaQGWGiGKXCg32fomb+utsCeVMNck4e
         HhPUESX2M4Y4z6GnzwxA7YjbID08VgHVDQ061s3lk/qXNScqIFYHGJeQAFbnO1YLpq
         teXLDDu3kzRMziHPgq9EnP9r2qEcV20yyftlMQc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 037/408] selftests: forwarding: Add missing rp_filter configuration
Date:   Tue, 27 Oct 2020 14:49:35 +0100
Message-Id: <20201027135456.803232307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 71a0e29e99405d89b695882d52eec60844173697 ]

When 'rp_filter' is configured in strict mode (1) the tests fail because
packets received from the macvlan netdevs would not be forwarded through
them on the reverse path.

Fix this by disabling the 'rp_filter', meaning no source validation is
performed.

Fixes: 1538812e0880 ("selftests: forwarding: Add a test for VXLAN asymmetric routing")
Fixes: 438a4f5665b2 ("selftests: forwarding: Add a test for VXLAN symmetric routing")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20201015084525.135121-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh |   10 ++++++++++
 tools/testing/selftests/net/forwarding/vxlan_symmetric.sh  |   10 ++++++++++
 2 files changed, 20 insertions(+)

--- a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
@@ -215,10 +215,16 @@ switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 
 switch_destroy()
 {
+	sysctl_restore net.ipv4.conf.all.rp_filter
+
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
 
@@ -359,6 +365,10 @@ ns_switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 export -f ns_switch_create
 
--- a/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh
@@ -237,10 +237,16 @@ switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 
 switch_destroy()
 {
+	sysctl_restore net.ipv4.conf.all.rp_filter
+
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
 
@@ -402,6 +408,10 @@ ns_switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 export -f ns_switch_create
 


