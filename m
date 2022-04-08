Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F614F90F9
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiDHIjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiDHIji (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:39:38 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFBC3893;
        Fri,  8 Apr 2022 01:37:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b15so7814493pfm.5;
        Fri, 08 Apr 2022 01:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=7K4+/b0R86ZT+hQk0J4XIxe35bIEDncPDFhNjSyqDJY=;
        b=XasWnOzW95Uoedl03mI5VkKE+3O31vTqRQo+tSBRguQ4DlFo7RuUJ8gLEIO34tt8Ds
         nBiXnGz2pAuDccybkVEA2PqtNcQh9ob6En+KywungX8WBKR6I3B/MSIOpTMV0eUjKn/L
         DxlKMqzw4VAq6dRBS66Mz4sYJjMr1BKdR+J18YcnCKsHNtGLh1Nex7HC3zzT410EYNbQ
         bTgCaiLpmTmyr85wiOSoL5RiG8j5EmxYhJNJVF3BGKW3Fw1Tjqq8cGkb7wyqPtFkPCIg
         fUhTndUI8RxS9bycgTpPpu+VpKuCNIjzxsZsVg3/tWlNFSUPBEec113/b1pcHi0p5n2r
         m/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7K4+/b0R86ZT+hQk0J4XIxe35bIEDncPDFhNjSyqDJY=;
        b=CiLCTJqo6rCp3X7wYjnQ4wxPdhFFymffn130Ze+SIv4Q4qoBQP51SYHZv6k4PyWDvp
         nZcyN1K5Rng8osvkuMZa9ZBGNLvTMeZirAGrxq1fGhqojom3YorokbiKfJ2Wdnp8pE2N
         F8NtCTMFWKSfzPE29T0KKPOsOswp2AnbVeVjC30o5eqX9BHHCQr3aDveB4ZWcZ0KLMdi
         zjPNpBVLtc4mh0+wM7XUeFKpYUlj3+3MHLYuNv0DT7cDsvHt582B04hEt+ZUBD+Kjgjt
         qe5x45bEyvdepCwEgZmdC/Wcw6QRpBCwwa/dTOqTjl+EGnKpTAG3H1h1Qaa5CHnJU5le
         V79Q==
X-Gm-Message-State: AOAM533o3wB4Mje2+crFX4ODN13uQ43R9zk0zqbXvO9ApOZX/crBJO/g
        q0SLzemH8R4zPVbwbCvTGzs=
X-Google-Smtp-Source: ABdhPJzPAAyCnfAkfDv0rkDk+TbHmnQVzxsOJFmo8rTcUWhL1aND4BHD874EYoaan+uMuo291m2vZg==
X-Received: by 2002:a05:6a00:810:b0:4fa:e71f:7e40 with SMTP id m16-20020a056a00081000b004fae71f7e40mr18181684pfk.15.1649407055080;
        Fri, 08 Apr 2022 01:37:35 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id m7-20020a625807000000b004fe0a89f24fsm16536345pfb.112.2022.04.08.01.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:37:34 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     rgoldwyn@suse.com, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v3] md: fix an incorrect NULL check in does_sb_need_changing
Date:   Fri,  8 Apr 2022 16:37:28 +0800
Message-Id: <20220408083728.25701-1-xiam0nd.tong@gmail.com>
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
while using the original variable 'rdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 2aa82191ac36 ("md-cluster: Perform a lazy update")
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v2:
 - fix typo (Song Liu)

changes since v1:
 - rephrase the subject (Guoqing Jiang)
 - add Acked-by: for Guoqing Jiang

v2:https://lore.kernel.org/lkml/20220328081127.26148-1-xiam0nd.tong@gmail.com/
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

