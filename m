Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E291C131B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgEAN1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbgEAN1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD37208D6;
        Fri,  1 May 2020 13:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339625;
        bh=6ztxaQqiGIA1m1sIcnvYH1NX9Mz0deoFS5BI/XcdXkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnemTW6dVImfZ+WDfFb+iZR264K/4CMfNpohGbUD5S6n0vJEPYn2oW0wTEj49Qm1O
         IKuZAtZewe4iU+bTmN8gYuPwddNG38LyxPtXnfThjvMSnrebgvBHNEicKWqdRefS0z
         4Tk/08rvJNmuNkX0IU0XLNm876UePZR2z/hzRZCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 65/70] of: unittest: kmemleak on changeset destroy
Date:   Fri,  1 May 2020 15:21:53 +0200
Message-Id: <20200501131532.508180734@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit b3fb36ed694b05738d45218ea72cf7feb10ce2b1 ]

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 1 of 5.

of_unittest_changeset() reaches deeply into the dynamic devicetree
functions.  Several nodes were left with an elevated reference
count and thus were not properly cleaned up.  Fix the reference
counts so that the memory will be freed.

Fixes: 201c910bd689 ("of: Transactional DT support.")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 91e6891b777b6..109497dbfba08 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -544,6 +544,10 @@ static void __init of_unittest_changeset(void)
 	mutex_unlock(&of_mutex);
 
 	of_changeset_destroy(&chgset);
+
+	of_node_put(n1);
+	of_node_put(n2);
+	of_node_put(n21);
 #endif
 }
 
-- 
2.20.1



