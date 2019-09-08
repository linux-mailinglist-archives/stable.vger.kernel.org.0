Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18A2ACEC4
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfIHM6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbfIHMqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:46:43 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0852081B;
        Sun,  8 Sep 2019 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946803;
        bh=unn06WB5Q3arhJ/2MJCg37Gwfm61AYem3C57a8cNxxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoQ8i7KTZCwCHkam02E7VWL+7SVitkuS+cVAZQVj6nkAmkN4eUfaxFmA/5qWvVJGT
         WiqSL3JXKQP1emsvd5l3pkdsACR41kbOj5svh3iw25Olvr6nIvxe5xFF6FM+r9+FhK
         GhJeqX54wbxaJB0QXL2JPssu5yMNXaTykBog6Z5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/40] cxgb4: fix a memory leak bug
Date:   Sun,  8 Sep 2019 13:41:43 +0100
Message-Id: <20190908121119.873316497@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c554336efa9bbc28d6ec14efbee3c7d63c61a34f ]

In blocked_fl_write(), 't' is not deallocated if bitmap_parse_user() fails,
leading to a memory leak bug. To fix this issue, free t before returning
the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 76540b0e082d3..9e5cd18e7358c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2777,8 +2777,10 @@ static ssize_t blocked_fl_write(struct file *filp, const char __user *ubuf,
 		return -ENOMEM;
 
 	err = bitmap_parse_user(ubuf, count, t, adap->sge.egr_sz);
-	if (err)
+	if (err) {
+		kvfree(t);
 		return err;
+	}
 
 	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
 	kvfree(t);
-- 
2.20.1



