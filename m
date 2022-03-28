Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7264E8FD1
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiC1INR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiC1INR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:13:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F91532F1;
        Mon, 28 Mar 2022 01:11:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i11so14172181plr.1;
        Mon, 28 Mar 2022 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ZMgx06IZ/vTQmKn4Nct70SDi9iZjPOBIYBwUSYQ4YmU=;
        b=lBMkt0MvMliAbMYT/2V+UsPfvTyN7QOaqdRD/zHSYxFwxgJ8bEoQVtBENzIZxl0LRm
         PZdfJ0ysFLmN7QXnCUr5qubbJF3HewyoDy7pauM9JnZLIbfoUrRDSjSJvTSSGghzJA3Z
         ZhX9DEoRZtE/pe19uxxqiQJ/7aY59UVm8T2yL+/HrkCWXxmVvePPWTX48xbFyVkDh1hK
         151vnexDRIzdtMpspfQCYGS5KkV8fILxskGkUcO2gN98X877fU1x4QOIHrOPQQYi9/M9
         2SD952WDuja8CNu82JZbxo3s+1ULNBdVXSlV+usg3GDJEISpeFt1dk5x3U8QCik6uerI
         OSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZMgx06IZ/vTQmKn4Nct70SDi9iZjPOBIYBwUSYQ4YmU=;
        b=zQOEnNJofwRTPUQe1ydGDtfyVBXaK8vHpRtOCtXnPkySCB8+EyPH2tL/SvH6BvjJUy
         BusyUUyaRtKkVavxiA/4FWKtQ1QAzzywn2JkRpu+CFAwC3LzBgwOVEh4771apjXQD1E5
         CfqdR6l0a/hRAcWQiqg5ovuGqfEImNWXrz8kp6wAptT/XRfr1MojhXDn75cX6G/Rdoye
         2o97kYiKRe3pkJL781NsMo54pAmeKzNatBRcZz78qkDUwOtc+R6nbD2xm7uRuCjX8F9q
         o/VgzZAlIgiPeb/RgBznXS3JTycgpDmRW09ycDd9r87qBJua7cIE0Otu3lsn4/hKjguh
         +YVg==
X-Gm-Message-State: AOAM5326EYs54AyYR4/KRkqXoK/quW4GrhKlkzpI/aEBWwC87CPIlzcW
        vwq7Z/Qo/v9PdjAZA0CWrPC244lKaiOAzg==
X-Google-Smtp-Source: ABdhPJz1x0tEhHgEVjrXUxGt7w6IyxiYhg3FJ2bqwwNKhSEYs0f82CLytV/jgiMUz7PsgeVvjZvV8A==
X-Received: by 2002:a17:90b:1d04:b0:1c7:1174:56ae with SMTP id on4-20020a17090b1d0400b001c7117456aemr39442247pjb.153.1648455096789;
        Mon, 28 Mar 2022 01:11:36 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm14723754pjo.0.2022.03.28.01.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 01:11:36 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     rgoldwyn@suse.com, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] md: fix an incorrect NULL check in sync_sbs
Date:   Mon, 28 Mar 2022 16:11:27 +0800
Message-Id: <20220328081127.26148-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!rdev)

The list iterator value 'rdev' will *always* be set and non-NULL
by rdev_for_each(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element found.
Otherwise it will bypass the NULL check and lead to invalid memory
access passing the check.

To fix the bug, use a new variable 'iter' as the list iterator,
while using the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 2aa82191ac36c ("md-cluster: Perform a lazy update")
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - rephrase the subject (Guoqing Jiang)
 - add Acked-by: for Guoqing Jiang
v1:https://lore.kernel.org/lkml/20220327080002.11923-1-xiam0nd.tong@gmail.com/

---
 drivers/md/md.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4d38bd7dadd6..7476fc204172 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2629,14 +2629,16 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 
 static bool does_sb_need_changing(struct mddev *mddev)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	struct mdp_superblock_1 *sb;
 	int role;
 
 	/* Find a good rdev */
-	rdev_for_each(rdev, mddev)
-		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
+	rdev_for_each(iter, mddev)
+		if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
+			rdev = iter;
 			break;
+		}
 
 	/* No good device found. */
 	if (!rdev)
-- 
2.17.1

