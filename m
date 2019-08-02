Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8835E7F498
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404682AbfHBJbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404679AbfHBJbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F4721783;
        Fri,  2 Aug 2019 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738292;
        bh=erNs80+xO89ji3FxGHqrr4RJNC78SHV0qgHFA/oqA5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJUUxt8LdWfNOeZk0PUL0lC5D6Wk6i9vl5kvbhErQJRa5D5ZXEnoz1n/CO/496edz
         2my0wUexYCPY7c68gMCQfRCuU4qC5R3kfrIcVCJvr+ZjlDR2WG8bOP9p0WA+O1/5//
         fv9sZxzqVY0QlSCbMUwceaTvCil4bbKYITiLbPnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 047/158] rslib: Fix handling of of caller provided syndrome
Date:   Fri,  2 Aug 2019 11:27:48 +0200
Message-Id: <20190802092213.631567139@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 8eed0f9ac495..a5d313381539 100644
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



