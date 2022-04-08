Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1283C4F911B
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiDHIt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiDHIt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:49:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B29E32B716;
        Fri,  8 Apr 2022 01:47:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z16so7837704pfh.3;
        Fri, 08 Apr 2022 01:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=d9l5xKaN+YV177tsuKpxyr8ohblnrBNtN4kwgsorTCI=;
        b=hT6fWVZQ4QHrs/G5kzOK8ctjiy/SO6JVcyyDISqiXwG3ZJLp9VqE6ddmvOuDR/0wDU
         E5DmaI68tJW57R63aQmLxTG5MeRvYYhquibJ3GFXyWVp6dldmv/1Vlgeti2NY0FSYRQy
         Mfq3x+BZmWbnsy9aD3S7VVqXDweIryJz0xatVtAFpxRTeLC/GE1bn2D8cngtzuAoEfpJ
         +PN6tkcJ95S18VcOOPPV7LO+w3wNwcNAGDWv8nX4TFadXMrL77doA9OMgq3/Q1Yz7kPa
         /v3Fd3lLRUA5xCEoKfMk9oAZwebyT+OnvH6Ziwm83DozGQ0tN07RXD5poCMVbedbsxSc
         4XRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d9l5xKaN+YV177tsuKpxyr8ohblnrBNtN4kwgsorTCI=;
        b=wKD04DwsdbvfVznjR13OGZ0TVdWYRXb2/uuEmz9vteLSMXlUBpRNAfhXEFEtsLK8aZ
         fAn4XjeBQJUKwx59S91+1wcg12LisuxWJ6ALhf86q+xoghRv/nrE+BOeiNU2DfD/GD3w
         0QEl0Xdm6HEyeBB8i+Rt56WHpPH0siT5uJQyd+J0QzT7vu3h0wnl+kk8z7e5VwQyeiJ1
         W4bJxZaxvzOA76MrV14SPhVVy/Sjn7IZNAj3XyBcEj/ITrATZnfioU7sfmqWC0Fwa437
         xBgIriK0Se8aamPCkqRiKWMUNQzsSGqIFFmaqHabB0KKVTWH77q02zCT4JrggBf4zF+U
         B3mw==
X-Gm-Message-State: AOAM533yK6x2h9NFfx8h4Z3Axi4gHVXhyitTJkbzJ8HLsHMbxkhyVTt0
        fYAPA0x/hQwPb1xc4yR77tc=
X-Google-Smtp-Source: ABdhPJylB7FbYV53AoLAJpfIe+ZAg+aSaDxQaKBgF0H0ikVXkvCQXWwg8OikSUp8BUaGlQK7jvKZCQ==
X-Received: by 2002:a65:46c2:0:b0:385:fb1c:f0c4 with SMTP id n2-20020a6546c2000000b00385fb1cf0c4mr14464825pgr.405.1649407642733;
        Fri, 08 Apr 2022 01:47:22 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id f12-20020a056a001acc00b004fb37ecc6b2sm25002506pfv.29.2022.04.08.01.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:47:22 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     rgoldwyn@suse.com, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v3] md: fix an incorrect NULL check in md_reload_sb
Date:   Fri,  8 Apr 2022 16:47:15 +0800
Message-Id: <20220408084715.26097-1-xiam0nd.tong@gmail.com>
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
	if (!rdev || rdev->desc_nr != nr) {

The list iterator value 'rdev' will *always* be set and non-NULL
by rdev_for_each_rcu(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
and lead to invalid memory access passing the check.

To fix the bug, use a new variable 'iter' as the list iterator,
while using the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 70bcecdb1534 ("md-cluster: Improve md_reload_sb to be less error prone")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes from v2:
 - fix typo (Song Liu)

changes from v1:
 - rephrase the subject (Guoqing Jiang)

v2:https://lore.kernel.org/lkml/20220328080559.25984-1-xiam0nd.tong@gmail.com/
v1:https://lore.kernel.org/lkml/20220327080111.12028-1-xiam0nd.tong@gmail.com/

---
 drivers/md/md.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7476fc204172..f156678c08bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9794,16 +9794,18 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 
 void md_reload_sb(struct mddev *mddev, int nr)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	int err;
 
 	/* Find the rdev */
-	rdev_for_each_rcu(rdev, mddev) {
-		if (rdev->desc_nr == nr)
+	rdev_for_each_rcu(iter, mddev) {
+		if (iter->desc_nr == nr) {
+			rdev = iter;
 			break;
+		}
 	}
 
-	if (!rdev || rdev->desc_nr != nr) {
+	if (!rdev) {
 		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
 		return;
 	}
-- 
2.17.1

