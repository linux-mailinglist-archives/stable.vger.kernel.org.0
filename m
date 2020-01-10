Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC146137975
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgAJWId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbgAJWFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5ED220838;
        Fri, 10 Jan 2020 22:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693932;
        bh=9u/22Bx1CrQ7UmrvZK+V+GRgpaK/YkuZkq0sbndgZKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ncf+xUyYZ4icgqCMrAsC5mJ7mOqC1/n4J3fuqHFvip/qNOSWpcgxjIqS3F9NK+vTi
         +vo6sEOCwangQkm+Ajz8hwOPM2iQqeG41gxPtr+fFqlUAq/pke/CednBph1s1KLAdl
         ziy5gUxXnMcPXCB3HWp18pnHDjmQsl9ZfKXY4mAw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/26] s390/qeth: fix initialization on old HW
Date:   Fri, 10 Jan 2020 17:05:08 -0500
Message-Id: <20200110220519.28250-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 0b698c838e84149b690c7e979f78cccb6f8aa4b9 ]

I stumbled over an old OSA model that claims to support DIAG_ASSIST,
but then rejects the cmd to query its DIAG capabilities.

In the old code this was ok, as the returned raw error code was > 0.
Now that we translate the raw codes to errnos, the "rc < 0" causes us
to fail the initialization of the device.

The fix is trivial: don't bail out when the DIAG query fails. Such an
error is not critical, we can still use the device (with a slightly
reduced set of features).

Fixes: 742d4d40831d ("s390/qeth: convert remaining legacy cmd callbacks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7320a187d66a..b60e6b3046ef 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4963,10 +4963,8 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	}
 	if (qeth_adp_supported(card, IPA_SETADP_SET_DIAG_ASSIST)) {
 		rc = qeth_query_setdiagass(card);
-		if (rc < 0) {
+		if (rc)
 			QETH_CARD_TEXT_(card, 2, "8err%d", rc);
-			goto out;
-		}
 	}
 	return 0;
 out:
-- 
2.20.1

