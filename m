Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2082A150D9B
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgBCQoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730061AbgBCQar (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:47 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62C32086A;
        Mon,  3 Feb 2020 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747447;
        bh=B0JIqMD29LvbOe+RxwvtK3buCFf3EOPoDEsuj7C77js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mye8JN0KpHbMjliSXEEq57M756R3y5+/8RIf8LkmVYJRExgi23C2IEtDHfvOMWube
         J4YnXnYn9OQHSYvCmRE+2pXYZk4s6Ysfp91adHdJvLfS551/fhYBb3kSBLaSPso1ZL
         a/8nVBYCneN17j65rfZr2j8cO1oUEhRAq6lT7cBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 87/89] seq_tab_next() should increase position index
Date:   Mon,  3 Feb 2020 16:20:12 +0000
Message-Id: <20200203161927.304835541@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 70a87287c821e9721b62463777f55ba588ac4623 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 9e5cd18e7358c..8bd90ad156073 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -66,8 +66,7 @@ static void *seq_tab_start(struct seq_file *seq, loff_t *pos)
 static void *seq_tab_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = seq_tab_get_idx(seq->private, *pos + 1);
-	if (v)
-		++*pos;
+	++(*pos);
 	return v;
 }
 
-- 
2.20.1



