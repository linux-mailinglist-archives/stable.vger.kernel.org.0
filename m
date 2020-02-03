Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA765150B74
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBCQ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgBCQ1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:43 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90ED12051A;
        Mon,  3 Feb 2020 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747263;
        bh=528ZcrQJZQ4TUfVFsu6KSmmCu84dPYeWmgxcuBYdxTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTNAUF/wu5h4f9s/xvKI5IHUKhATYLI5yoxiAVBwsz5Cl21LlrCOIcsVcN16cEiN/
         bVaxINiQl+fqCHrrfu/X0bz4XOofoF6Qw1qU4NHwuUsRloowhzNAn40X38kPeZ/Hlf
         CxcZS50rXFqOC/ZOobbm3O9IfQw0pYcTE7Zehn4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.14 11/89] staging: vt6656: Fix false Tx excessive retries reporting.
Date:   Mon,  3 Feb 2020 16:18:56 +0000
Message-Id: <20200203161918.372503759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 9dd631fa99dc0a0dfbd191173bf355ba30ea786a upstream.

The driver reporting  IEEE80211_TX_STAT_ACK is not being handled
correctly. The driver should only report on TSR_TMO flag is not
set indicating no transmission errors and when not IEEE80211_TX_CTL_NO_ACK
is being requested.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/340f1f7f-c310-dca5-476f-abc059b9cd97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/int.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -107,9 +107,11 @@ static int vnt_int_report_rate(struct vn
 
 	info->status.rates[0].count = tx_retry;
 
-	if (!(tsr & (TSR_TMO | TSR_RETRYTMO))) {
+	if (!(tsr & TSR_TMO)) {
 		info->status.rates[0].idx = idx;
-		info->flags |= IEEE80211_TX_STAT_ACK;
+
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+			info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
 	ieee80211_tx_status_irqsafe(priv->hw, context->skb);


