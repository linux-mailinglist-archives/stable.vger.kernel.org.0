Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0217822A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgCCSN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgCCRpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3101C208C3;
        Tue,  3 Mar 2020 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257500;
        bh=Qjyvv69TvJ2XwxB8JdC7/51eE9UYXSmJQHfW9d9906o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILMpViOVKF6movICu85TSEgEhPPib7xVCOy3bWtky0h+DXtKv1Vf53hM7FndDYlzk
         0yUvU6pl146XbddLTKd6bB42NEDuVjjengegPVq4TJud/QKA9nq964/ef2Xj96VxCx
         wCu/SB3F/7dv69t+qam32e8m/Kvv9PpVc+68ThKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 002/176] net: dsa: b53: Ensure the default VID is untagged
Date:   Tue,  3 Mar 2020 18:41:06 +0100
Message-Id: <20200303174304.875613458@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit d965a5432d4c3e6b9c3d2bc1d4a800013bbf76f6 ]

We need to ensure that the default VID is untagged otherwise the switch
will be sending tagged frames and the results can be problematic. This
is especially true with b53 switches that use VID 0 as their default
VLAN since VID 0 has a special meaning.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1353,6 +1353,9 @@ void b53_vlan_add(struct dsa_switch *ds,
 
 		b53_get_vlan_entry(dev, vid, vl);
 
+		if (vid == 0 && vid == b53_default_pvid(dev))
+			untagged = true;
+
 		vl->members |= BIT(port);
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag |= BIT(port);


