Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C784E86C2
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiC0IBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiC0IBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:01:48 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245B5101;
        Sun, 27 Mar 2022 01:00:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so12626773pjq.2;
        Sun, 27 Mar 2022 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=lSV2zkJT4vTOb08gOwZPa0NvOrdi/khmoY6zgOHN1IU=;
        b=I4nZDPWhZYZeLJb8asDUzGUv2Tkq/AVxOmNPKYmN9FI0pvI/7zGJXrbkl0VUcgRz9S
         qVNgOlh7kqa6TikZU+hQWrUKMRIypgi56wUPg4Lvasa5kFUh6GMucI67ATIHhsEqtNAk
         vvltX73/l6VI9k1LRcDz38w5fUsO6jxDH28tmuwgIOWuhFXSeoL6CW9T5d4xOmB0tm5Y
         jbdDiloJY/Dje0WtN7v8C4W4IJ167RRFu0QBTPFzsCbMcSEKvYuplodWsZe8J0YduxCe
         NyLfl5Nqrblqjwi1umQaqn4kQBto/Bzx66ch8L/7wm9mUYhTa9FohT1q0yHpHaOBVXRN
         99kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lSV2zkJT4vTOb08gOwZPa0NvOrdi/khmoY6zgOHN1IU=;
        b=7qMRjYHfPjzwlBZLvH6YYsWzgpK3opqo/P85E5immnSWlf6WW/ogblJO63ywvGIuCb
         OwTPmlg6qg3E9o12ikrNRBsxMugdVuHADoqqINjmuUfiEurcb5KtNnWMvJia5feY+tMO
         U26si8UtimIXL3d7hiGLaRZUnv+R4MXtR4orLNMVl3HqIh/dV/sm9DCQKguPXRlEV6Sk
         R/ph++nPAk0KAOCMVG5yKzbBgPJqWHLgn9LSB0/bWvAGFmw6MQJRq43YgW83Tw0hOur8
         2c0yHUPiYYu1PyipWyFu4k7W/QfXllAcKpZxPZivc3+u/SlYJQjPavoAYBkF90tbqA6H
         KE3Q==
X-Gm-Message-State: AOAM533f3E/tEZoLNk+PpXEL5W9WUKo9lo0yP+wgGMthY5kR8xYPOq9E
        uE0ypYx4s2sPTHi5vvMRHDA=
X-Google-Smtp-Source: ABdhPJwgAWZdlT1LPliJa/D7j61uWppjASH38drcCgQlfMobPBwJ0/dg/LsNxh1vNVV4xNg7Lm3zRw==
X-Received: by 2002:a17:902:bb92:b0:153:4eae:c77e with SMTP id m18-20020a170902bb9200b001534eaec77emr20266086pls.93.1648368009676;
        Sun, 27 Mar 2022 01:00:09 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id d11-20020aa7868b000000b004f768dfe93asm11934637pfo.176.2022.03.27.01.00.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:00:09 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org, rgoldwyn@suse.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] md: md1: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 16:00:02 +0800
Message-Id: <20220327080002.11923-1-xiam0nd.tong@gmail.com>
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
while use the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 2aa82191ac36c ("md-cluster: Perform a lazy update")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
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

