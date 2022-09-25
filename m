Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C285E96F5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiIYXn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiIYXn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 19:43:56 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54066275E4
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 16:43:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b23so5060470pfp.9
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 16:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date;
        bh=8l9SZEXeOGAHPaBYKpiKd2zRj1VQl6STNmYmUqvRW6o=;
        b=EyhErhjnZzbiLOtmYu3OzBfUaJ+feqdxAletymaonCXsf+pm1aB2w/8bIpcfolRMxH
         yl4MqdZEeWSJK5ecwsBqwQ1GSb+NJe3L1xK/y3A/+Gxe45ksPFkfOvjCfQJsg13cAX1l
         3dnDDAtXAkww1in6A5oXz3v+vizcKoIN5KyM8bDxf5Pk3sd/b2OQy+ZHyt5rc0O2iXDU
         JVyK8PfhGNlIHf4SPLVqQNk0lsm7qz8RMw+PrVY2iB05gKj+iu7y3i5/BR+XUc/DO9Ol
         yDmZA77oCNugezpHy+BoyOLqltTFYj9dfrD03uqaC+NczdzL7R9rAGgNWjYbF4HsR7z1
         zk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8l9SZEXeOGAHPaBYKpiKd2zRj1VQl6STNmYmUqvRW6o=;
        b=FiXT45JyWHhZcMV6ezq/mw1g+sIdRvRko95JgsB9TDwoYDrHJO64r3lM607zkwl5fF
         A0u26pTxL4WayaPWnl8TI4bcQigwDQJc97lnB+WTw9riLrqQordimhc8xoAGmcVAqPku
         tCEWk9Ze6XlRIrftx5kE94rG4wIGPYagJeOlwaJlrOXedxbn+P1ETT5MnDVWZXRG6vZG
         o3q6hdpPhKQ7VEL7uEX5tONJeZJmu4+wmVPtOEwNzsKECYZXVFPg9Lndbwxm160KmE/9
         66QAG5DzsYVnPHy6HiheU6Uq+QYRWudqm07h9Ucm72/G4K0J7/PIlrWk/52saaq3vOsn
         10oQ==
X-Gm-Message-State: ACrzQf0Qdf/G3Gyhaw5pccUPRYAX2nyGbVaLV7rasJRByhyad9EJpaIX
        IQmidRSQlmk0BUb8UHCOKY7m2XP62M0iww==
X-Google-Smtp-Source: AMsMyM6uzBRZ15WrJyfwa20zTjvFCI+XZgR3GbQDEivislkxCI8uEecVmp+gG/ojWfaydxhxOTL3Xw==
X-Received: by 2002:a63:8b42:0:b0:43c:ab46:7963 with SMTP id j63-20020a638b42000000b0043cab467963mr3360140pge.385.1664149434662;
        Sun, 25 Sep 2022 16:43:54 -0700 (PDT)
Received: from localhost.localdomain ([211.226.85.205])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902ce8300b00178650510f9sm9814238plg.160.2022.09.25.16.43.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Sep 2022 16:43:54 -0700 (PDT)
From:   Levi Yun <ppbuk5246@gmail.com>
To:     sj@kernel.org
Cc:     akpm@linux-foundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, Levi Yun <ppbuk5246@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
Date:   Mon, 26 Sep 2022 08:43:27 +0900
Message-Id: <20220925234327.26345-1-ppbuk5246@gmail.com>
X-Mailer: git-send-email 2.35.1
Reply-To: <20220925140257.23431-1-ppbuk5246@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When damon_sysfs_add_target couldn't find proper task,
New allocated damon_target structure isn't registered yet,
So, it's impossible to free new allocated one by
damon_sysfs_destroy_targets.

By calling daemon_add_target as soon as allocating new target, Fix this
possible memory leak.

Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Fixes:74bd8b7d2f8e7
Cc: <stable@vger.kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7488e27c87c3..bdef9682d0a0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2182,12 +2182,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 
 	if (!t)
 		return -ENOMEM;
+	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
 			goto destroy_targets_out;
 	}
-	damon_add_target(ctx, t);
 	err = damon_sysfs_set_regions(t, sys_target->regions);
 	if (err)
 		goto destroy_targets_out;
-- 
2.35.1

