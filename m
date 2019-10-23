Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC0E2480
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 22:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfJWUV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 16:21:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39575 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731998AbfJWUV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 16:21:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id s17so10632962plp.6;
        Wed, 23 Oct 2019 13:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UdG4edqjssTCSConqbp18kQyfuAFBkmlrZkIsoc/cFg=;
        b=EtsMV/ZgECD/GaaEEZ/C1rQVGA5E+k1cw2jV7kw8FDJnqJLYULZxoZR6oeu/d7P9RN
         bw1swq4NIdAB5NbA2evmvaequHvbXgrzfxBwV09PIMtfr/J2YPzNOStbFksAZd/bsmoA
         GcOVPG+GFnId3sBlne9RcoV0M+JUGZcaqtwy/QfNuFl19oSlsAO4ymoG4N50CYHtdTAd
         kW5810g/zOUJAiOHt9ydqXndXahU/DXEck5e2VgcLq1O7c74X4AEK7Ek3bycjFNMW78B
         guYGbwu89pBXX6QKxNszLHhHWzu3F+XGlHfOlkkEfmMElHZjA9EEtpON/6PR2/2pKgUb
         BrrQ==
X-Gm-Message-State: APjAAAVGGHj7DeNRQz7oG3YwZ8syM7GUm+EJA6FCDO82EwAyo+BUo338
        eyNRpKnBZ9ERWpBXmmYKJWRRPcQp
X-Google-Smtp-Source: APXvYqyVaNh0dVyvQ3ICFG9R+lltNv+0S/lBpLOIYjl/hoT3Wr/rsq/yuTGkBmsG/JADmInSXUQkrA==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr11627505plp.223.1571862117387;
        Wed, 23 Oct 2019 13:21:57 -0700 (PDT)
Received: from localhost.net ([2601:647:4000:c3:e5ef:65f1:8f3f:3a78])
        by smtp.gmail.com with ESMTPSA id j10sm23656535pfn.128.2019.10.23.13.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:21:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Varun Prakash <varun@chelsio.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        stable@vger.kernel.org
Subject: [PATCH] target/cxgbit: Fix cxgbit_fw4_ack()
Date:   Wed, 23 Oct 2019 13:21:50 -0700
Message-Id: <20191023202150.22173-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the pointer 'p' after having tested that pointer instead of before.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Varun Prakash <varun@chelsio.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org>
Fixes: 5cadafb236df ("target/cxgbit: Fix endianness annotations")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index c70caf4ea490..a2b5c796bbc4 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1831,7 +1831,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	while (credits) {
 		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
-		const u32 csum = (__force u32)p->csum;
+		u32 csum;
 
 		if (unlikely(!p)) {
 			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
@@ -1840,6 +1840,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 			break;
 		}
 
+		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
 			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
 				csk,  csk->tid,
-- 
2.23.0

