Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F189C12172B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfLPSJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfLPSJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A09882072B;
        Mon, 16 Dec 2019 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519750;
        bh=zJJttVOwLrFq9aZgonSL2Bb1IaAF8YNWFphhjZylzC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HT1EImWob1Q8ywOwB17CTCmpGCoQkvtBLqM9fYTKwOEFL6bcx4jTm0Drf4xnNzhL
         ILcius4OGcmDBO+MlaI6HvM/7egpTBBBAAE4z3JGhwOpjLCKSnlnO2tD+S41Uk8Ylt
         qygSyQykJ7dyB9eLAGAZo+x3RfHnUHSnu1lUlLvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        linux-usb@vger.kernel.org,
        =?UTF-8?q?Heikki=20Krogerus=C2=A0?= 
        <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.3 053/180] usb: typec: fix use after free in typec_register_port()
Date:   Mon, 16 Dec 2019 18:48:13 +0100
Message-Id: <20191216174824.725793396@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

commit 5c388abefda0d92355714010c0199055c57ab6c7 upstream.

We can't use "port->sw" and/or "port->mux" after it has been freed.

Fixes: 23481121c81d ("usb: typec: class: Don't use port parent for getting mux handles")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: stable <stable@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191126140452.14048-1-wenyang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/class.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1604,14 +1604,16 @@ struct typec_port *typec_register_port(s
 
 	port->sw = typec_switch_get(&port->dev);
 	if (IS_ERR(port->sw)) {
+		ret = PTR_ERR(port->sw);
 		put_device(&port->dev);
-		return ERR_CAST(port->sw);
+		return ERR_PTR(ret);
 	}
 
 	port->mux = typec_mux_get(&port->dev, NULL);
 	if (IS_ERR(port->mux)) {
+		ret = PTR_ERR(port->mux);
 		put_device(&port->dev);
-		return ERR_CAST(port->mux);
+		return ERR_PTR(ret);
 	}
 
 	ret = device_add(&port->dev);


