Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9357DEF65
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfJUOZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:25:13 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:41558 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfJUOZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1590; q=dns/txt; s=iport;
  t=1571667912; x=1572877512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SqTIMSLhR7lXn1Jsa4WitcpbMgcvoQ8jCWciutis1gM=;
  b=kfoj/4cmrm5GrTQjG/GPhHltLS+BHXbzuSQnYIyCX21EY5r9j+5CUKWv
   XA62A7B98+fjp9vU8k2JmLEOyKxNOJRYMCyPUiI8F4uXVjDPnq8yDDRhn
   EhQ/lDmSAYMMD4LyO/2dJYH08ky1iUnuGy/kEQUwk6eCSgzb1sIHlz+Gy
   s=;
X-IronPort-AV: E=Sophos;i="5.67,323,1566864000"; 
   d="scan'208";a="18194352"
Received: from aer-iport-nat.cisco.com (HELO aer-core-3.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Oct 2019 14:18:02 +0000
Received: from onetland-linux.rd.cisco.com ([10.47.77.136])
        by aer-core-3.cisco.com (8.15.2/8.15.2) with ESMTP id x9LEHuNN027696;
        Mon, 21 Oct 2019 14:18:02 GMT
From:   =?UTF-8?q?=C3=98yvind=20Netland?= <onetland@cisco.com>
To:     lys-patches@cisco.com
Cc:     hansverk@cisco.com, hegtvedt@cisco.com,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: [PATCH 18/23] media: cec: integrate cec_validate_phys_addr() in cec-api.c
Date:   Mon, 21 Oct 2019 16:17:51 +0200
Message-Id: <20191021141756.8816-18-onetland@cisco.com>
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

From: Hans Verkuil <hans.verkuil@cisco.com>

onetland: cherry-picked from mainline: e81bff39489a

The cec_phys_addr_validate() function will be moved to V4L2,
so use a simplified variant of that function in cec-api.c.
cec now no longer calls cec_phys_addr_validate() and it can
be safely moved to V4L2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.17 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 4ba82938fecf..8436775991d6 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -112,6 +112,23 @@ static long cec_adap_g_phys_addr(struct cec_adapter *adap,
 	return 0;
 }
 
+static int cec_validate_phys_addr(u16 phys_addr)
+{
+	int i;
+
+	if (phys_addr == CEC_PHYS_ADDR_INVALID)
+		return 0;
+	for (i = 0; i < 16; i += 4)
+		if (phys_addr & (0xf << i))
+			break;
+	if (i == 16)
+		return 0;
+	for (i += 4; i < 16; i += 4)
+		if ((phys_addr & (0xf << i)) == 0)
+			return -EINVAL;
+	return 0;
+}
+
 static long cec_adap_s_phys_addr(struct cec_adapter *adap, struct cec_fh *fh,
 				 bool block, __u16 __user *parg)
 {
@@ -123,7 +140,7 @@ static long cec_adap_s_phys_addr(struct cec_adapter *adap, struct cec_fh *fh,
 	if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
 		return -EFAULT;
 
-	err = cec_phys_addr_validate(phys_addr, NULL, NULL);
+	err = cec_validate_phys_addr(phys_addr);
 	if (err)
 		return err;
 	mutex_lock(&adap->lock);
-- 
2.20.1

