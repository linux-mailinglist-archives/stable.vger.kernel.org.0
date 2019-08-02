Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FD7F42A
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391683AbfHBJmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391886AbfHBJme (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8695420679;
        Fri,  2 Aug 2019 09:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738954;
        bh=erNs80+xO89ji3FxGHqrr4RJNC78SHV0qgHFA/oqA5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY4LMujY1+2vJ0EEnrg2jn89pGz4F/Jl0oGDUjvrXW2FyCWV29fAorJBb2ocjdFCD
         A8tlMfeM1GYuzr0n+JYhRS9MRfA22rof8ph4tLNLauDTn/tbZF60K+lrca7GoOcS6w
         KfFuRUlbcZsHtAulBQolq8mFhFAd+m7MSt4njO04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/223] rslib: Fix handling of of caller provided syndrome
Date:   Fri,  2 Aug 2019 11:34:45 +0200
Message-Id: <20190802092242.745107649@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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



