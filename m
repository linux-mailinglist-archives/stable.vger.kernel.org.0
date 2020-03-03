Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E300A178105
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbgCCSAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387708AbgCCSAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9E120870;
        Tue,  3 Mar 2020 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258406;
        bh=yBmJYcsax/aoSR9o0ZnIg9yKXHRZ8PCmpT6whJPQGTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuVXdExwOJhlVl8ml7H9vbqUqfoPduP/QJEWqDZajwMMqTtf/+5AuksnZlzqahYLw
         /l4rxGtgUOP54IIUPmvMSKb8nQGZRr49qOqSE+4tEJ+DV0D762ZIbAknNtx8X46o0h
         GnbWbhv36lQzMJDhljyMpscj19923k75rrcilNB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 38/87] net/tls: Fix to avoid gettig invalid tls record
Date:   Tue,  3 Mar 2020 18:43:29 +0100
Message-Id: <20200303174353.906416120@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

[ Upstream commit 06f5201c6392f998a49ca9c9173e2930c8eb51d8 ]

Current code doesn't check if tcp sequence number is starting from (/after)
1st record's start sequnce number. It only checks if seq number is before
1st record's end sequnce number. This problem will always be a possibility
in re-transmit case. If a record which belongs to a requested seq number is
already deleted, tls_get_record will start looking into list and as per the
check it will look if seq number is before the end seq of 1st record, which
will always be true and will return 1st record always, it should in fact
return NULL.
As part of the fix, start looking each record only if the sequence number
lies in the list else return NULL.
There is one more check added, driver look for the start marker record to
handle tcp packets which are before the tls offload start sequence number,
hence return 1st record if the record is tls start marker and seq number is
before the 1st record's starting sequence number.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -506,7 +506,7 @@ struct tls_record_info *tls_get_record(s
 				       u32 seq, u64 *p_record_sn)
 {
 	u64 record_sn = context->hint_record_sn;
-	struct tls_record_info *info;
+	struct tls_record_info *info, *last;
 
 	info = context->retransmit_hint;
 	if (!info ||
@@ -516,6 +516,25 @@ struct tls_record_info *tls_get_record(s
 		 */
 		info = list_first_entry(&context->records_list,
 					struct tls_record_info, list);
+
+		/* send the start_marker record if seq number is before the
+		 * tls offload start marker sequence number. This record is
+		 * required to handle TCP packets which are before TLS offload
+		 * started.
+		 *  And if it's not start marker, look if this seq number
+		 * belongs to the list.
+		 */
+		if (likely(!tls_record_is_start_marker(info))) {
+			/* we have the first record, get the last record to see
+			 * if this seq number belongs to the list.
+			 */
+			last = list_last_entry(&context->records_list,
+					       struct tls_record_info, list);
+
+			if (!between(seq, tls_record_start_seq(info),
+				     last->end_seq))
+				return NULL;
+		}
 		record_sn = context->unacked_record_sn;
 	}
 


