Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427BD3A0223
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbhFHTB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhFHS6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 696DF61623;
        Tue,  8 Jun 2021 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177757;
        bh=rsED8s3r44/lFHHL2PzzG5LOJomieDVl4CR1CyvZD0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeWSVFkR6twhmes8gRVYdyjSbyS2jFs2rlHu5nZyRFSDcJxietA0qfmMiQ/He+vtU
         ZYZE3Lz2wF36E2e0mmbGgXBKAt4Dng0umSUm5ztV4YOZiEGWjdU4K1tqPndASJGh1D
         cLCY9whUYx8uPYgL1qhFucCegX1ju97I9v7tqCJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 089/137] net: caif: added cfserl_release function
Date:   Tue,  8 Jun 2021 20:27:09 +0200
Message-Id: <20210608175945.385435036@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit bce130e7f392ddde8cfcb09927808ebd5f9c8669 upstream.

Added cfserl_release() function.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/caif/cfserl.h |    1 +
 net/caif/cfserl.c         |    5 +++++
 2 files changed, 6 insertions(+)

--- a/include/net/caif/cfserl.h
+++ b/include/net/caif/cfserl.h
@@ -9,4 +9,5 @@
 #include <net/caif/caif_layer.h>
 
 struct cflayer *cfserl_create(int instance, bool use_stx);
+void cfserl_release(struct cflayer *layer);
 #endif
--- a/net/caif/cfserl.c
+++ b/net/caif/cfserl.c
@@ -31,6 +31,11 @@ static int cfserl_transmit(struct cflaye
 static void cfserl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
 			   int phyid);
 
+void cfserl_release(struct cflayer *layer)
+{
+	kfree(layer);
+}
+
 struct cflayer *cfserl_create(int instance, bool use_stx)
 {
 	struct cfserl *this = kzalloc(sizeof(struct cfserl), GFP_ATOMIC);


