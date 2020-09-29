Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0544127C5A8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgI2Lhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80C1523B3E;
        Tue, 29 Sep 2020 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379244;
        bh=/ScECHuMMx+Z6V1XFj2xOe3d/sxOd6b+cZM2xBTfqao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utfn1PvfuOHdVvjSGqgUqseQDHPb/0bWrYMEgXaadgXP2dlmsEAdzREMaUyoshIgU
         zasKYcJnttiJ2+02B3qbRmrjXS9NzHdujoIhkhi3cH/C1Exid0NBJ3QhAJv/3lu/Hp
         GSKZTtpq5xVqUQ0y9vEQWuRaG/S5Je3EDEA9Se40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/388] vcc_seq_next should increase position index
Date:   Tue, 29 Sep 2020 12:56:47 +0200
Message-Id: <20200929110014.166539944@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 8bf7092021f283944f0c5f4c364853201c45c611 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index d79221fd4dae2..c318967073139 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -134,8 +134,7 @@ static void vcc_seq_stop(struct seq_file *seq, void *v)
 static void *vcc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = vcc_walk(seq, 1);
-	if (v)
-		(*pos)++;
+	(*pos)++;
 	return v;
 }
 
-- 
2.25.1



