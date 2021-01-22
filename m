Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2337D3005E5
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbhAVOrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbhAVOY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECFAA23BAD;
        Fri, 22 Jan 2021 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325147;
        bh=MGRImWCa37Xlup1zSYHj2aC6xi2m8z+FnyF8KGvaLEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FboWpXpMbcf9aeXuXghKCRJyYkCJoB/fQ0ux+7/w9zdnPf0RPWwvaq7vX1qg3nxdl
         hVKg00zWE8qYHLWLum/DwvXXRUH4O12Deaq7iVfd5Qclpm61M1KxEq1pjfVwOZLIoh
         UJRLSH/VIy69JljSuZYNgVAu1krixg6jgWj3EbIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 33/43] net: dsa: clear devlink port type before unregistering slave netdevs
Date:   Fri, 22 Jan 2021 15:12:49 +0100
Message-Id: <20210122135737.002440864@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 91158e1680b164c8d101144ca916a3dca10c3e17 ]

Florian reported a use-after-free bug in devlink_nl_port_fill found with
KASAN:

(devlink_nl_port_fill)
(devlink_port_notify)
(devlink_port_unregister)
(dsa_switch_teardown.part.3)
(dsa_tree_teardown_switches)
(dsa_unregister_switch)
(bcm_sf2_sw_remove)
(platform_remove)
(device_release_driver_internal)
(device_links_unbind_consumers)
(device_release_driver_internal)
(device_driver_detach)
(unbind_store)

Allocated by task 31:
 alloc_netdev_mqs+0x5c/0x50c
 dsa_slave_create+0x110/0x9c8
 dsa_register_switch+0xdb0/0x13a4
 b53_switch_register+0x47c/0x6dc
 bcm_sf2_sw_probe+0xaa4/0xc98
 platform_probe+0x90/0xf4
 really_probe+0x184/0x728
 driver_probe_device+0xa4/0x278
 __device_attach_driver+0xe8/0x148
 bus_for_each_drv+0x108/0x158

Freed by task 249:
 free_netdev+0x170/0x194
 dsa_slave_destroy+0xac/0xb0
 dsa_port_teardown.part.2+0xa0/0xb4
 dsa_tree_teardown_switches+0x50/0xc4
 dsa_unregister_switch+0x124/0x250
 bcm_sf2_sw_remove+0x98/0x13c
 platform_remove+0x44/0x5c
 device_release_driver_internal+0x150/0x254
 device_links_unbind_consumers+0xf8/0x12c
 device_release_driver_internal+0x84/0x254
 device_driver_detach+0x30/0x34
 unbind_store+0x90/0x134

What happens is that devlink_port_unregister emits a netlink
DEVLINK_CMD_PORT_DEL message which associates the devlink port that is
getting unregistered with the ifindex of its corresponding net_device.
Only trouble is, the net_device has already been unregistered.

It looks like we can stub out the search for a corresponding net_device
if we clear the devlink_port's type. This looks like a bit of a hack,
but also seems to be the reason why the devlink_port_type_clear function
exists in the first place.

Fixes: 3122433eb533 ("net: dsa: Register devlink ports before calling DSA driver setup()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian fainelli <f.fainelli@gmail.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210112004831.3778323-1-olteanv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -353,9 +353,13 @@ static int dsa_port_devlink_setup(struct
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
+	struct devlink_port *dlp = &dp->devlink_port;
+
 	if (!dp->setup)
 		return;
 
+	devlink_port_type_clear(dlp);
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;


