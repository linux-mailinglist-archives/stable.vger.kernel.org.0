Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F9C14BA3A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgA1OTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728299AbgA1OTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EA32071E;
        Tue, 28 Jan 2020 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221178;
        bh=Xw9YztzTE2/FOpzeBm47CYzucRq34DUyKjvMFYOZgkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ps6wWQ5tDuJzwMGtlVOFu7nQnw8MlnRYdm4pLvnSfjQEwFm6RmxuPYLL2TJ5wnsq
         ClkgIdHPdwZnRkjUKChounIBDZ5iprgcWPpcd2NlORg+pRxuM9KiHN4qMTZg+/ZA2f
         DIZaaLyUlnSeXg+0wseVtO1QiLV2njhWJld6gi10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Alexander Aring <aring@mojatatu.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/271] 6lowpan: Off by one handling ->nexthdr
Date:   Tue, 28 Jan 2020 15:04:30 +0100
Message-Id: <20200128135901.598707621@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f57c4bbf34439531adccd7d3a4ecc14f409c1399 ]

NEXTHDR_MAX is 255.  What happens here is that we take a u8 value
"hdr->nexthdr" from the network and then look it up in
lowpan_nexthdr_nhcs[].  The problem is that if hdr->nexthdr is 0xff then
we read one element beyond the end of the array so the array needs to
be one element larger.

Fixes: 92aa7c65d295 ("6lowpan: add generic nhc layer interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Acked-by: Alexander Aring <aring@mojatatu.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/6lowpan/nhc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/6lowpan/nhc.c b/net/6lowpan/nhc.c
index 7008d53e455c5..e61679bf09085 100644
--- a/net/6lowpan/nhc.c
+++ b/net/6lowpan/nhc.c
@@ -18,7 +18,7 @@
 #include "nhc.h"
 
 static struct rb_root rb_root = RB_ROOT;
-static struct lowpan_nhc *lowpan_nexthdr_nhcs[NEXTHDR_MAX];
+static struct lowpan_nhc *lowpan_nexthdr_nhcs[NEXTHDR_MAX + 1];
 static DEFINE_SPINLOCK(lowpan_nhc_lock);
 
 static int lowpan_nhc_insert(struct lowpan_nhc *nhc)
-- 
2.20.1



