Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D3304A6A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbhAZFFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731356AbhAYSy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF4622482;
        Mon, 25 Jan 2021 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600859;
        bh=el9oVFD3tZTI6dimfe9pt2jEyd4nuY3pc4E45/1S3Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwHA4AuwnHRJn47bxqjZJrA6Ezz3VLYRYvAZd0Ewcu+YDaQAhM2QawEqIq/7kHAWU
         36LqCpPqcYEQgSp6rF0kydoy1X6w0no8KKeFAw53ZHQvDp/YsuIJA2pHFsoKZMF76R
         YsYgvDAkP10mLKl2UzPVsqkJlbJs7jJA9AlA8acc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 178/199] net: dsa: b53: fix an off by one in checking "vlan->vid"
Date:   Mon, 25 Jan 2021 19:40:00 +0100
Message-Id: <20210125183223.710242844@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8e4052c32d6b4b39c1e13c652c7e33748d447409 upstream.

The > comparison should be >= to prevent accessing one element beyond
the end of the dev->vlans[] array in the caller function, b53_vlan_add().
The "dev->vlans" array is allocated in the b53_switch_init() function
and it has "dev->num_vlans" elements.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/YAbxI97Dl/pmBy5V@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/b53/b53_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1404,7 +1404,7 @@ int b53_vlan_prepare(struct dsa_switch *
 	    !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return -EINVAL;
 
-	if (vlan->vid_end > dev->num_vlans)
+	if (vlan->vid_end >= dev->num_vlans)
 		return -ERANGE;
 
 	b53_enable_vlan(dev, true, ds->vlan_filtering);


