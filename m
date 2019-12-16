Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72361213DC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfLPSFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfLPSFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3202166E;
        Mon, 16 Dec 2019 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519536;
        bh=UOc/FJlJ+vBa71ybe5UqQhEaD33njVr12Vobl8SZBx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7G2aWN92uHE3nc3Mja17MYMPPhnCijFoXC8ocjWcZXd2Cmmh0J06CxuEaTcn/5Ho
         OB2Kqw5NnUmp7pTVELCD+peAO7lSBIlwyiZ6X3ubdq3Iq/jWGIYRhEmwGyHerOB9HH
         8NnB7BdzWUB15MzKuJLC9UJNqXwCCCGp+t8APK1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        linux-usb@vger.kernel.org,
        =?UTF-8?q?Heikki=20Krogerus=C2=A0?= 
        <heikki.krogerus@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/140] usb: typec: fix use after free in typec_register_port()
Date:   Mon, 16 Dec 2019 18:49:35 +0100
Message-Id: <20191216174815.842184472@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 5c388abefda0d92355714010c0199055c57ab6c7 ]

We can't use "port->sw" and/or "port->mux" after it has been freed.

Fixes: 23481121c81d ("usb: typec: class: Don't use port parent for getting mux handles")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: stable <stable@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191126140452.14048-1-wenyang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/class.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 00141e05bc724..1916ee1600b47 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1589,14 +1589,16 @@ struct typec_port *typec_register_port(struct device *parent,
 
 	port->sw = typec_switch_get(&port->dev);
 	if (IS_ERR(port->sw)) {
+		ret = PTR_ERR(port->sw);
 		put_device(&port->dev);
-		return ERR_CAST(port->sw);
+		return ERR_PTR(ret);
 	}
 
 	port->mux = typec_mux_get(&port->dev, "typec-mux");
 	if (IS_ERR(port->mux)) {
+		ret = PTR_ERR(port->mux);
 		put_device(&port->dev);
-		return ERR_CAST(port->mux);
+		return ERR_PTR(ret);
 	}
 
 	ret = device_add(&port->dev);
-- 
2.20.1



