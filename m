Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7025922F1C8
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgG0OOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729945AbgG0OOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:14:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A09142073E;
        Mon, 27 Jul 2020 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859256;
        bh=07Y0K6B/jas/WfqhlgWNpkqqZf+TC6BP68ukDb77Of0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDZeuwFQfPPoJmd4OIvOVKhJVYs1zCZZI1+w12sYA8KKFAtdLOiaZBEQ1wMQLD3Lq
         kvYhg1abE2aJH+Xx2ygQS+cSHmoEEpBSukbConBsuL6GrON0XsSxWLHUmUWTr7tKYE
         zQRTKaH7o4CzrX68W1DsTvT5ynjruYX7CzvxWnFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/138] xtensa: update *pos in cpuinfo_op.next
Date:   Mon, 27 Jul 2020 16:03:23 +0200
Message-Id: <20200727134925.661395495@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 0d5ab144429e8bd80889b856a44d56ab4a5cd59b ]

Increment *pos in the cpuinfo_op.next to fix the following warning
triggered by cat /proc/cpuinfo:

  seq_file: buggy .next function c_next did not update position index

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index e0e1e1892b86b..d08172138369b 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -716,7 +716,8 @@ c_start(struct seq_file *f, loff_t *pos)
 static void *
 c_next(struct seq_file *f, void *v, loff_t *pos)
 {
-	return NULL;
+	++*pos;
+	return c_start(f, pos);
 }
 
 static void
-- 
2.25.1



