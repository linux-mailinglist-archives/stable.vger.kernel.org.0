Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F82EEE40
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389588AbfKDWJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389830AbfKDWJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:08 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67202084D;
        Mon,  4 Nov 2019 22:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905347;
        bh=5yHE+GyYRcaWxFCAaeV4qiDkp7QVDSIGHk1tz3OWcW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXgEaeT+ZovX13ZGzFKAKPYySD35uS8cY5QqKSYIEY5qAX9GEi42VCAHwOXLMwu6q
         OZ3U1xFYW4Bq3ANdHRTpQG9o7TvSr9Ufv0zvNwcLMhx6D3ChmZmUT5amAvvVLuhobU
         mXPxh3NpV86Q+tLf/tY4hMQnZwUaOngboW07WdxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 114/163] scsi: target: cxgbit: Fix cxgbit_fw4_ack()
Date:   Mon,  4 Nov 2019 22:45:04 +0100
Message-Id: <20191104212148.495684749@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit fc5b220b2dcf8b512d9bd46fd17f82257e49bf89 upstream.

Use the pointer 'p' after having tested that pointer instead of before.

Fixes: 5cadafb236df ("target/cxgbit: Fix endianness annotations")
Cc: Varun Prakash <varun@chelsio.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191023202150.22173-1-bvanassche@acm.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1831,7 +1831,7 @@ static void cxgbit_fw4_ack(struct cxgbit
 
 	while (credits) {
 		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
-		const u32 csum = (__force u32)p->csum;
+		u32 csum;
 
 		if (unlikely(!p)) {
 			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
@@ -1840,6 +1840,7 @@ static void cxgbit_fw4_ack(struct cxgbit
 			break;
 		}
 
+		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
 			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
 				csk,  csk->tid,


