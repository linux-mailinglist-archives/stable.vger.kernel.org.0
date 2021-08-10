Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A23E81B5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhHJSBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhHJR7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD2FE613A4;
        Tue, 10 Aug 2021 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617585;
        bh=BTEEXW6O5jYkijye2zWVLsXsrNnU0Sn38gQur0kljJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWHwkDT2MsQYSOVsyKOuriNA5OPhqLS4z+ik3qtt4r+BqK75X8o7Z9eq0AdO2AuhT
         9V/sRHb88olR7s0N/qdWsWEXxBB4OVtxes3Jpsj86a7klj3VR8HPNE4IZFGvRrERBS
         X0RodUbOi5yZXPV+KyPNwE2bAGjZOV3jhtn/wgRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Kellner <ckellner@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.13 123/175] Revert "thunderbolt: Hide authorized attribute if router does not support PCIe tunnels"
Date:   Tue, 10 Aug 2021 19:30:31 +0200
Message-Id: <20210810173005.004696881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 8e3341257e3b5774ec8cd3ef1ba0c0d3fada322b upstream.

This reverts commit 6f3badead6a078cf3c71f381f9d84ac922984a00.

It turns out bolt depends on having authorized attribute visible under
each device. Hiding it makes bolt crash as several people have reported
on various bug trackers. For this reason revert the commit.

Link: https://gitlab.freedesktop.org/bolt/bolt/-/issues/174
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1979765
Link: https://bugs.archlinux.org/task/71569
Cc: stable@vger.kernel.org
Cc: Christian Kellner <ckellner@redhat.com>
Fixes: 6f3badead6a0 ("thunderbolt: Hide authorized attribute if router does not support PCIe tunnels")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20210727142501.27476-1-mika.westerberg@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1740,18 +1740,6 @@ static struct attribute *switch_attrs[]
 	NULL,
 };
 
-static bool has_port(const struct tb_switch *sw, enum tb_port_type type)
-{
-	const struct tb_port *port;
-
-	tb_switch_for_each_port(sw, port) {
-		if (!port->disabled && port->config.type == type)
-			return true;
-	}
-
-	return false;
-}
-
 static umode_t switch_attr_is_visible(struct kobject *kobj,
 				      struct attribute *attr, int n)
 {
@@ -1760,8 +1748,7 @@ static umode_t switch_attr_is_visible(st
 
 	if (attr == &dev_attr_authorized.attr) {
 		if (sw->tb->security_level == TB_SECURITY_NOPCIE ||
-		    sw->tb->security_level == TB_SECURITY_DPONLY ||
-		    !has_port(sw, TB_TYPE_PCIE_UP))
+		    sw->tb->security_level == TB_SECURITY_DPONLY)
 			return 0;
 	} else if (attr == &dev_attr_device.attr) {
 		if (!sw->device)


