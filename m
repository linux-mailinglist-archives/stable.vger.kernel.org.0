Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C17369514
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390325AbfGOOZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389685AbfGOOZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:25:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869F020896;
        Mon, 15 Jul 2019 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200716;
        bh=9oPmWzZADG9KBbFCDoRtLvhV03Hq67ZJeep/W6VUocU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V74mhfoxCGbr6aygqxmDJg0WL2OOcsOLymudRLavZyESACLsJ3ybv/cZQ964BqVYU
         J97wSeX8eiqXnkf3i/8JEPrXkpt3MW2jMhw1guGScahnh0mIyQQ474fLxZD6k2cFHu
         MbI2mg/CkuVo/aUioK+nxtm/UZ5VQDhOmSIz1DOg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 116/158] rslib: Fix handling of of caller provided syndrome
Date:   Mon, 15 Jul 2019 10:17:27 -0400
Message-Id: <20190715141809.8445-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>

[ Upstream commit ef4d6a8556b637ad27c8c2a2cff1dda3da38e9a9 ]

Check if the syndrome provided by the caller is zero, and act
accordingly.

Signed-off-by: Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190620141039.9874-6-ferdinand.blomqvist@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/reed_solomon/decode_rs.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/reed_solomon/decode_rs.c b/lib/reed_solomon/decode_rs.c
index 3313bf944ff1..121beb2f0930 100644
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -42,8 +42,18 @@
 	BUG_ON(pad < 0 || pad >= nn);
 
 	/* Does the caller provide the syndrome ? */
-	if (s != NULL)
-		goto decode;
+	if (s != NULL) {
+		for (i = 0; i < nroots; i++) {
+			/* The syndrome is in index form,
+			 * so nn represents zero
+			 */
+			if (s[i] != nn)
+				goto decode;
+		}
+
+		/* syndrome is zero, no errors to correct  */
+		return 0;
+	}
 
 	/* form the syndromes; i.e., evaluate data(x) at roots of
 	 * g(x) */
-- 
2.20.1

