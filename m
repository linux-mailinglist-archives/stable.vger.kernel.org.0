Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2BDEF63
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfJUOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:25:09 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:10359 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfJUOZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:25:08 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 10:25:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1261; q=dns/txt; s=iport;
  t=1571667908; x=1572877508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9vOnQijfuh4PkGqMokOPjEptxBE+iZ+sQJhVFCOpACA=;
  b=FUqTOY9f6BKkyhxDyGZ2PdgXNguaAtH6k6VGL08U1cgbzu4k6QHbj/sw
   fo2Xl1Y8Al7iHQBx09T0QVIohlRchp+d5fle8G8xZH7583MgCq7ad7VbE
   lqR8N8w/K1My/PhTLapMCrB5bzV+R6q+Q8F/Fh50lFCYtzFAKv2vqeHzQ
   c=;
X-IronPort-AV: E=Sophos;i="5.67,323,1566864000"; 
   d="scan'208";a="18251344"
Received: from aer-iport-nat.cisco.com (HELO aer-core-3.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Oct 2019 14:18:00 +0000
Received: from onetland-linux.rd.cisco.com ([10.47.77.136])
        by aer-core-3.cisco.com (8.15.2/8.15.2) with ESMTP id x9LEHuNF027696;
        Mon, 21 Oct 2019 14:17:59 GMT
From:   =?UTF-8?q?=C3=98yvind=20Netland?= <onetland@cisco.com>
To:     lys-patches@cisco.com
Cc:     hansverk@cisco.com, hegtvedt@cisco.com,
        Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH 10/23] cec: forgot to cancel delayed work
Date:   Mon, 21 Oct 2019 16:17:43 +0200
Message-Id: <20191021141756.8816-10-onetland@cisco.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191021141756.8816-1-onetland@cisco.com>
References: <20191021141756.8816-1-onetland@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.47.77.136, [10.47.77.136]
X-Outbound-Node: aer-core-3.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

onetland: cherry-picked from cust/cisco/r28n-cisco: def9fd009919

If the wait for completion was interrupted, then make sure to cancel
any delayed work.

This can only happen if a transmit is waiting for a reply, and you press
Ctrl-C or reboot/poweroff or something like that which interrupts the
thread waiting for the reply and then proceeds to delete the CEC message.

Since the delayed work wasn't canceled, once it would trigger it referred
to stale data and resulted in a kernel oops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Fixes: 05f525b833e8 ("cec: add new tx/rx status bits to detect aborts/timeouts")
Cc: <stable@vger.kernel.org>      # for v4.18 and up

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 0ab3a2a73b23..c00ab539ab90 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -822,6 +822,8 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	 */
 	mutex_unlock(&adap->lock);
 	wait_for_completion_killable(&data->c);
+	if (!data->completed)
+		cancel_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
 	/* Cancel the transmit if it was interrupted */
-- 
2.20.1

