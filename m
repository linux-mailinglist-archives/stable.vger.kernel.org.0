Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD1111DED
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfLCW6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfLCW6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E3A20863;
        Tue,  3 Dec 2019 22:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413896;
        bh=JCoY7mZHq3opaU1WkN9zdL3pS8mGjJQ4hMf3eU8txPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vpWpd45ZrqTYsYFQGK/NehKGZHzI8X20XeVqh9QpGROgR4u+zVldIozD+C4enam1
         RX94ppPaUXx0jXL/llydvyoPg/9ulKqQMv45ANpSdXkUg3577QryP40tMEbZS3h7sM
         Z2cLdt/OvsP1hPdJ6sMbBQHedehX3FGK7mx9dEVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Thomas <pthomas8589@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 297/321] net: macb driver, check for SKBTX_HW_TSTAMP
Date:   Tue,  3 Dec 2019 23:36:03 +0100
Message-Id: <20191203223442.602846662@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Thomas <pthomas8589@gmail.com>

commit a62520473f15750cd1432d36b377a06cd7cff8d2 upstream.

Make sure SKBTX_HW_TSTAMP (i.e. SOF_TIMESTAMPING_TX_HARDWARE) has been
enabled for this skb. It does fix the issue where normal socks that
aren't expecting a timestamp will not wake up on select, but when a
user does want a SOF_TIMESTAMPING_TX_HARDWARE it does work.

Signed-off-by: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cadence/macb_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -860,7 +860,9 @@ static void macb_tx_interrupt(struct mac
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (gem_ptp_do_txstamp(queue, skb, desc) == 0) {
+				if (unlikely(skb_shinfo(skb)->tx_flags &
+					     SKBTX_HW_TSTAMP) &&
+				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
 					/* skb now belongs to timestamp buffer
 					 * and will be removed later
 					 */


