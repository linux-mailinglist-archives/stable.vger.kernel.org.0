Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C96150C81
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbgBCQhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbgBCQhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:10 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78CB20721;
        Mon,  3 Feb 2020 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747830;
        bh=ATu7mnQ7kjwkEutz/nZqrsLZmfziIVGeD0WmcPB723g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/wajTEcE36aVR9kGe2cTvIo1RLNgR9pTx5heyADEHBKZP3bDTpWftSEpLQP5w6e3
         JRDYIKLEfXP95gx+E40WoohP8RQIDNaLU1wHGPRt+iO3rE/V2nocKZHi2FVZKisZPE
         71/pnqzPPAVpRA7RJqiYqPJH0ZeOEvFvBHkLLkvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 87/90] l2t_seq_next should increase position index
Date:   Mon,  3 Feb 2020 16:20:30 +0000
Message-Id: <20200203161927.644506604@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
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
index 1a407d3c1d67c..e6fe2870137b0 100644
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



