Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765AD150D87
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgBCQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbgBCQau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:50 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E492080C;
        Mon,  3 Feb 2020 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747449;
        bh=FokpwCo7yq9QcNvC9K+1UdYma9BMD+zI5H/clmdOOyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYQ9rWWTnFalH3MUS+eU+XG3LynLMN2DADDhMVOaYeC+dFab8K/tHU9hOzKOfoejQ
         Pb+ISopidrvbASYxwva85FstKHjreiqH2BLrN16Nf3DKE+cWeFoCeWf9VTRIXGlLMj
         fihAwcp4/QBcVX8HsuEcBi1xUt6ZFZ6UycuaGmbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 88/89] l2t_seq_next should increase position index
Date:   Mon,  3 Feb 2020 16:20:13 +0000
Message-Id: <20200203161927.408284554@linuxfoundation.org>
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

[ Upstream commit 66018a102f7756cf72db4d2704e1b93969d9d332 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index f7ef8871dd0b0..67aa3c9974173 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -682,8 +682,7 @@ static void *l2t_seq_start(struct seq_file *seq, loff_t *pos)
 static void *l2t_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = l2t_get_idx(seq, *pos);
-	if (v)
-		++*pos;
+	++(*pos);
 	return v;
 }
 
-- 
2.20.1



