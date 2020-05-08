Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9953F1CABBD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgEHMqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgEHMqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4904208D6;
        Fri,  8 May 2020 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941991;
        bh=jZI7BxO1atDLgaBvV6tlBctdL7A+TIXVYuXOMePXN7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZynecrDBQc+7q3sXzYSzyJTicAwZz2O0MqQ1g8lIjWvLgM2eP+9FJAQpm1O9PHjz
         NiupwCuj4lOF6KcUOrYcc1cAmLgIS8LcMvM9rDw0kT6lYXYsyEx6CGkiUcWaYh9r8M
         eF51HiZlq9enfO1Gt5Pkro66Zs4dNzunTsjx3zXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 253/312] ovs/gre: fix rtnl notifications on iface deletion
Date:   Fri,  8 May 2020 14:34:04 +0200
Message-Id: <20200508123142.202807026@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit da6f1da819d4b9c081a477dec74dc468a0b44290 upstream.

The function gretap_fb_dev_create() (only used by ovs) never calls
rtnl_configure_link(). The consequence is that dev->rtnl_link_state is
never set to RTNL_LINK_INITIALIZED.
During the deletion phase, the function rollback_registered_many() sends
a RTM_DELLINK only if dev->rtnl_link_state is set to RTNL_LINK_INITIALIZED.

Fixes: b2acd1dc3949 ("openvswitch: Use regular GRE net_device instead of vport")
CC: Thomas Graf <tgraf@suug.ch>
CC: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_gre.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1265,6 +1265,10 @@ struct net_device *gretap_fb_dev_create(
 	if (err)
 		goto out;
 
+	err = rtnl_configure_link(dev, NULL);
+	if (err < 0)
+		goto out;
+
 	return dev;
 out:
 	ip_tunnel_dellink(dev, &list_kill);


