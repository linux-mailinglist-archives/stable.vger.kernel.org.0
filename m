Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99427D73A
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfHAIUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44928 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbfHAIUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so33575083pfe.11
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cd+CJgxpyw48wYexEQLN0Ryuy346dGX9j+MO3rZWGCA=;
        b=Z2hoeeYKddLvWgzkdCUEz+2ekNkZhKgcRMApcaKIJ7G2CIMAm1cubhuNLH0vwcT8P8
         DmxIMWPwhRX603RJVjktdRBeAM4BzKt+1c16yhRSV52OElcwQ2L6MNZDgJZKJ2XoR/Vr
         qgiyoHQNvVUb7Nc+j7L1Iqm1RRpCH+xuPcVYNz1OUQYngmWAZuAlPcPICZa557bjJoeQ
         30kRgnzcmBqKpvWjBhMv9oMvtu6dj7gKLZofh36CdRU9/n0nfWQvp2xA3iJPXLxub6cc
         3Db/fga6lj3CgKI85yaJQhvd5i4Z9vn/+aPJLHb392RWMyFDVdH5e/2+Gp5+p1LbBpvR
         4qMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cd+CJgxpyw48wYexEQLN0Ryuy346dGX9j+MO3rZWGCA=;
        b=qVx/5BJQRQYb7Sf50uvsvcHbLUtVOW6hCHU0eCARJyEAJsXDGGP0Rr7qKVl/AvVwGq
         40eRqRN9t4b5EyuOiZzzit+Uxn3KtVtYxXNTMsACVOZg+UTwnzBcBtUgTYwZt+Ty9yHO
         XR+Pf1kjb4o8fs+hs4dFjrXGDKI+SxdA9u0kWAA1nvUqcjeBDxtGaRQugmIGxhGT/uEr
         gr1SMrr4QENjF10ld9RskEZvcKjKD16coh3AEzpcz9TsZj96c85J+tJ7F6VdQ2FW7t3D
         n3NDqpCceTlQGfwx+sLY+SVZ/vvzE/cIEXGykC+Ex5o1HRWR88Ce0yz/Wsdv4IbMCHAR
         mUAQ==
X-Gm-Message-State: APjAAAWo3VEQcHyFpusZ1rvA1xitijJmmrGZNliok/rAZj9RADwPD4YN
        1dunn9UtZIEDzZM1xsSSbDxbMj7uN3I=
X-Google-Smtp-Source: APXvYqwtcDCmIxl5mkdh/47SacWqkNbX1MQ0IltsOO1s27+NiUNuJFRU7Slh4TpJoMf4kw0ZVjpeAw==
X-Received: by 2002:a63:1046:: with SMTP id 6mr120820447pgq.111.1564647638075;
        Thu, 01 Aug 2019 01:20:38 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id e189sm56924368pgc.15.2019.08.01.01.20.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:37 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 24/47] ARM: oabi-compat: copy semops using __copy_from_user()
Date:   Thu,  1 Aug 2019 13:46:08 +0530
Message-Id: <bb0db44ea44afc9defa2aefa3b1ecf6e4c81d988.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 8c8484a1c18e3231648f5ba7cc5ffb7fd70b3ca4 upstream.

__get_user_error() is used as a fast accessor to make copying structure
members as efficient as possible.  However, with software PAN and the
recent Spectre variant 1, the efficiency is reduced as these are no
longer fast accessors.

In the case of software PAN, it has to switch the domain register around
each access, and with Spectre variant 1, it would have to repeat the
access_ok() check for each access.

Rather than using __get_user_error() to copy each semops element member,
copy each semops element in full using __copy_from_user().

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/sys_oabi-compat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 5f221acd21ae..640748e27035 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -328,9 +328,11 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 		return -ENOMEM;
 	err = 0;
 	for (i = 0; i < nsops; i++) {
-		__get_user_error(sops[i].sem_num, &tsops->sem_num, err);
-		__get_user_error(sops[i].sem_op,  &tsops->sem_op,  err);
-		__get_user_error(sops[i].sem_flg, &tsops->sem_flg, err);
+		struct oabi_sembuf osb;
+		err |= __copy_from_user(&osb, tsops, sizeof(osb));
+		sops[i].sem_num = osb.sem_num;
+		sops[i].sem_op = osb.sem_op;
+		sops[i].sem_flg = osb.sem_flg;
 		tsops++;
 	}
 	if (timeout) {
-- 
2.21.0.rc0.269.g1a574e7a288b

