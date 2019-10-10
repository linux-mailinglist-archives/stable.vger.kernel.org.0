Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EB6D2734
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfJJKbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:31:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44608 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJJKbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 06:31:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id q15so2554906pll.11
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 03:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HkxBDeI13PS/unHL1Nr+Sh+9tXf4QbZkcMWKpQOyoZs=;
        b=A3Ccp5m0GI0vf9vINUCaNgrXVyXgcdJaG3xHrIHMVAavr6PGkGIk2Rnv8iPDi14niy
         DeIrUZ5K3Q1T7ubCWBcWkWX8JmKwbimhiuLo0lm4549GDL1CKjT06RlAALVfrRDR5u7n
         FJ+AGVq+D276MDy6CMC86mTU+GOmxPFdikGggsEMOufzYdp5kj2OID/tuyMnSKV8Iikj
         c4hhdJW6rUhKvSG89tn4nMcBIbT54aJbpI5/7GZeJCjtchMX7zI0INRAYVWCOtTBxQob
         ZScd8nGDewPTjXDz4bzQ9r8eT/lyHZ7WcKtDsJiRlvjMmq8NMc2aTO+NmaEbxMel79G1
         aycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HkxBDeI13PS/unHL1Nr+Sh+9tXf4QbZkcMWKpQOyoZs=;
        b=YgjihrrCPZaqzHKZT32uDGT+J/kI1hmOifxgcTBDv+nBvqSXsm1xS96ek9TN6KSduu
         or5hVgzBmysaeXlGU0KTQEjWNavVLF4weyNV6Ao2K8UYuDBF3dykxS1Kt6SOGxht5WAy
         6sOzGiistrH867WZHdIdYH/S6SzysG+hVK5Al7Gy78KiqKfVaHGo+V8mVL8Ej/w/SSsU
         x9Zhz5I4lmCpJShVD+4vBgpc71Q0M/WHRlYJXDgjaElSe3ufcL98BG4qNtc3LLQFlefj
         kgXdd7jSJQh4bLWOCCNkKMwad+cFqjIs2cRqrU3kHaZWRhkhYQh9V6Tnvq4Tl9yMt9aX
         4RgQ==
X-Gm-Message-State: APjAAAVf0RmErkGIxB/YD+62tJHzTN3RsXQ41vZBRjnD7lenBQdaFL+C
        E0f5GRxdvu3vvQr2WcP0V/25kA==
X-Google-Smtp-Source: APXvYqzGw7DVSkGCo0+oVtm1TNRkmmIhKzdkzTs6guJGLgP3WTdjGG4hUW7yUT6AdCBxVIDYb7hllQ==
X-Received: by 2002:a17:902:9a01:: with SMTP id v1mr8899294plp.132.1570703461455;
        Thu, 10 Oct 2019 03:31:01 -0700 (PDT)
Received: from localhost ([122.172.151.112])
        by smtp.gmail.com with ESMTPSA id q13sm10056498pjq.0.2019.10.10.03.30.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 03:31:00 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "v5 . 0+" <stable@vger.kernel.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] opp: of: drop incorrect lockdep_assert_held()
Date:   Thu, 10 Oct 2019 16:00:52 +0530
Message-Id: <6306e18beab9deff6ee6b32f489390908495fe14.1570703431.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

_find_opp_of_np() doesn't traverse the list of OPP tables but instead
just the entries within an OPP table and so only requires to lock the
OPP table itself.

The lockdep_assert_held() was added there by mistake and isn't really
required.

Fixes: 5d6d106fa455 ("OPP: Populate required opp tables from "required-opps" property")
Cc: v5.0+ <stable@vger.kernel.org> # v5.0+
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/opp/of.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 1813f5ad5fa2..6dc41faf74b5 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -77,8 +77,6 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
 {
 	struct dev_pm_opp *opp;
 
-	lockdep_assert_held(&opp_table_lock);
-
 	mutex_lock(&opp_table->lock);
 
 	list_for_each_entry(opp, &opp_table->opp_list, node) {
-- 
2.21.0.rc0.269.g1a574e7a288b

