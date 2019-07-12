Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6B66ED0
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfGLMXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbfGLMXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:23:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFACB2166E;
        Fri, 12 Jul 2019 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934228;
        bh=0ahWQ9AhpV31pXGOghdJciw1LpUI/KQKn1do30aGqjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06pQny0vAIA2MOnvj+6lOApGvWyIca7DF2Fhs5n9gjJCK8TKK8WVPSLD4T0PB0Uso
         SovtxYRDXS5l9H+ReqCIC3/mo3g8kwFU7G/LFhR3MQ7N487QmXPYIdTa6R6KZV6C9T
         MINeb4VE4epiuxkmbwoDyCBem/KAAQkePujRXB10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.19 77/91] drivers/usb/typec/tps6598x.c: fix 4CC cmd write
Date:   Fri, 12 Jul 2019 14:19:20 +0200
Message-Id: <20190712121625.937102695@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>

commit 2681795b5e7a5bf336537661010072f4c22cea31 upstream.

Writing 4CC commands with tps6598x_write_4cc() already has
a pointer arg, don't reference it when using as arg to
tps6598x_block_write(). Correcting this enforces the constness
of the pointer to propagate to tps6598x_block_write(), so add
the const qualifier there to avoid the warning.

Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Signed-off-by: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tps6598x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -111,7 +111,7 @@ tps6598x_block_read(struct tps6598x *tps
 }
 
 static int tps6598x_block_write(struct tps6598x *tps, u8 reg,
-				void *val, size_t len)
+				const void *val, size_t len)
 {
 	u8 data[TPS_MAX_LEN + 1];
 
@@ -157,7 +157,7 @@ static inline int tps6598x_write64(struc
 static inline int
 tps6598x_write_4cc(struct tps6598x *tps, u8 reg, const char *val)
 {
-	return tps6598x_block_write(tps, reg, &val, sizeof(u32));
+	return tps6598x_block_write(tps, reg, val, 4);
 }
 
 static int tps6598x_read_partner_identity(struct tps6598x *tps)


