Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B21FDFA2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgFRBmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732303AbgFRB33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2199E221E6;
        Thu, 18 Jun 2020 01:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443768;
        bh=rquLcWC4YtiKOb0ygjRmmWfIq8S43jtn/9IxyUHEXBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEKbw47jxJJkVA1FnavcAM+mpAGsWTkslKfEF3Zka8nzGxGZl+oo01X5ObyoOveIH
         Xjikd8ed69PaNQhBv4FC+3CyZ9HBcNXmHTAqc9b5WdCs3EVvJAyMEl/MbAXz9mnGFF
         6UVtlJ3hlGcFpytk0btnkvugplyS0iLQ+zqmI9hM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 53/80] tty: n_gsm: Fix bogus i++ in gsm_data_kick
Date:   Wed, 17 Jun 2020 21:27:52 -0400
Message-Id: <20200618012819.609778-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 4dd31f1ffec6c370c3c2e0c605628bf5e16d5c46 ]

When submitting the previous fix "tty: n_gsm: Fix waking up upper tty
layer when room available". It was suggested to switch from a while to
a for loop, but when doing it, there was a remaining bogus i++.

This patch removes this i++ and also reorganizes the code making it more
compact.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20200518084517.2173242-3-gregory.clement@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 56716f525030..1ab9bd433542 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -719,17 +719,9 @@ static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 		} else {
 			int i = 0;
 
-			for (i = 0; i < NUM_DLCI; i++) {
-				struct gsm_dlci *dlci;
-
-				dlci = gsm->dlci[i];
-				if (dlci == NULL) {
-					i++;
-					continue;
-				}
-
-				tty_port_tty_wakeup(&dlci->port);
-			}
+			for (i = 0; i < NUM_DLCI; i++)
+				if (gsm->dlci[i])
+					tty_port_tty_wakeup(&gsm->dlci[i]->port);
 		}
 	}
 }
-- 
2.25.1

