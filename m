Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599BC22EFD4
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgG0OTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731412AbgG0OTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD5B2075A;
        Mon, 27 Jul 2020 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859571;
        bh=+WYxyi+AOvztptYdGA3lxwywnVFETA0l0WA73vufv+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGn/OFKapdeSkhfLPYv0Tssubnb9NYF4lFYsXC3gG8GUR1MbQQgqrPeLunx42QoG5
         ltG2Ap3eEouOJ5COn9ORyV6/J9yuwsKtFt2/U55x3GEJCVlqSHPcgve2vVDAQT03Vq
         XzwXb414tC/bukYF9wvG99KtHkYoZaN3v8+GkdiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 009/179] xtensa: update *pos in cpuinfo_op.next
Date:   Mon, 27 Jul 2020 16:03:04 +0200
Message-Id: <20200727134933.128600498@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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
index 3880c765d4489..0271e2e47bcdf 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -725,7 +725,8 @@ c_start(struct seq_file *f, loff_t *pos)
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



