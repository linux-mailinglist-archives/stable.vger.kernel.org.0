Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F002F513
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfE3DMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728799AbfE3DMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EDCF24481;
        Thu, 30 May 2019 03:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185921;
        bh=IhqzS5kn9D2++obbCuqop4TPzQXIpOqdjVY8mQvNTfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IG/VHiQ9+rXZmTveYnsP6kuGQMe8e812fQ5NEGJ25Y9EHLrQRTeUVtRvtCFXH7b22
         EK9uMGWV1NGebv19Dhj9A4dpYWTuNSgyw44Y9+n2qfQR84aPUyUlU3c9Bp3r7wvkhp
         xg55KOV/bcWhSV1b1N6Hulyu2m2G9cpXRNc0cJvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 309/405] rcu: Do a single rhp->func read in rcu_head_after_call_rcu()
Date:   Wed, 29 May 2019 20:05:07 -0700
Message-Id: <20190530030556.439992073@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b699cce1604e828f19c39845252626eb78cdf38a ]

The rcu_head_after_call_rcu() function reads the rhp->func pointer twice,
which can result in a false-positive WARN_ON_ONCE() if the callback
were passed to call_rcu() between the two reads.  Although racing
rcu_head_after_call_rcu() with call_rcu() is to be a dubious use case
(the return value is not reliable in that case), intermittent and
irreproducible warnings are also quite dubious.  This commit therefore
uses a single READ_ONCE() to pick up the value of rhp->func once, then
tests that value twice, thus guaranteeing consistent processing within
rcu_head_after_call_rcu()().

Neverthless, racing rcu_head_after_call_rcu() with call_rcu() is still
a dubious use case.

Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
[ paulmck: Add blank line after declaration per checkpatch.pl. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6cdb1db776cf9..922bb68488133 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -878,9 +878,11 @@ static inline void rcu_head_init(struct rcu_head *rhp)
 static inline bool
 rcu_head_after_call_rcu(struct rcu_head *rhp, rcu_callback_t f)
 {
-	if (READ_ONCE(rhp->func) == f)
+	rcu_callback_t func = READ_ONCE(rhp->func);
+
+	if (func == f)
 		return true;
-	WARN_ON_ONCE(READ_ONCE(rhp->func) != (rcu_callback_t)~0L);
+	WARN_ON_ONCE(func != (rcu_callback_t)~0L);
 	return false;
 }
 
-- 
2.20.1



