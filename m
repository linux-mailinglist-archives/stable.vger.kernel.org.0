Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C11CAD95
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgEHMtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbgEHMtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2A421835;
        Fri,  8 May 2020 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942158;
        bh=OAivvKqlUtldmHTyEiX1khD9Ur7dtJEbj2YpaT//bIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z41ASxxV+eTmWTbTorV2Ws60iyJ6y53SZWOBoqYEzGXtSWXoGZQEMy/vMm2rk9ki6
         YVTQwFFvgnCbd7USHO8l6rmgFQPduv4FTldGocvxh0fVM7Qyp3MWZ0RptbRCFW1Zo9
         7PCjQnUxIKTghbJkPUy+p3JIoGz/6syJGx6QQHqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@nicira.com>,
        Jesse Gross <jesse@nicira.com>, Thomas Graf <tgraf@suug.ch>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 271/312] ovs/geneve: fix rtnl notifications on iface deletion
Date:   Fri,  8 May 2020 14:34:22 +0200
Message-Id: <20200508123143.493299935@linuxfoundation.org>
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

commit 41009481b690493c169ce85f591b9d32c6fd9422 upstream.

The function geneve_dev_create_fb() (only used by ovs) never calls
rtnl_configure_link(). The consequence is that dev->rtnl_link_state is
never set to RTNL_LINK_INITIALIZED.
During the deletion phase, the function rollback_registered_many() sends
a RTM_DELLINK only if dev->rtnl_link_state is set to RTNL_LINK_INITIALIZED.

Fixes: e305ac6cf5a1 ("geneve: Add support to collect tunnel metadata.")
CC: Pravin B Shelar <pshelar@nicira.com>
CC: Jesse Gross <jesse@nicira.com>
CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/geneve.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1363,6 +1363,10 @@ struct net_device *geneve_dev_create_fb(
 	if (err)
 		goto err;
 
+	err = rtnl_configure_link(dev, NULL);
+	if (err < 0)
+		goto err;
+
 	return dev;
 
  err:


