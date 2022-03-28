Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744914E8FBA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiC1IHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiC1IHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:07:48 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D5852E58;
        Mon, 28 Mar 2022 01:06:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y10so8549422pfa.7;
        Mon, 28 Mar 2022 01:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=CTu5Ckkhnxr3a4Bdessxh982+g7W1LXJx6RoEy52ElQ=;
        b=fRhAkGn6eq8e9jJGRgqMzcIePzE3ErVy/ps/BdX/QZVWA2+9hgjm2fLRJEzMKvRJZP
         l8KjfVUSxfq5ifGWAUHGK0UYYtqXluuAtxfLZa+1JaTdNToJx0b6+IbhlwMa3G+UjQxX
         a3j+sCMAlPCZ7Ml5tAK5jHjl0ANQC7Q2wltz2LD3Eg+ACrryArMJGMZuovzfu39nzDxj
         T0XBwUJKWj0DbcK0WD00kLb1QFO/VvKqxEyUzlYNrrrc2QZCPLbxgw+M+erJcJ85bBa4
         EzxRkfuW9iqBv0EoAm1trzFn7QYF2K4QFnbW3J50ZJZhNki+66ivxsLNSDXpX/0xWtgb
         oc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CTu5Ckkhnxr3a4Bdessxh982+g7W1LXJx6RoEy52ElQ=;
        b=Pf0MjjwzJfBaUkzx+1JhbSEo1BBP16Lpoq8BLA5wH+AvAvEBU1DCS4omIthHKVC7iA
         R+9o1KYIX/mN2WpdtK3SB9vHKJ0Z8hEefaxW0NnJoAPj7VVxYR3DaxKow2xYDbuThqrD
         +huXAd+dOjMUT7Bot7Yl466Difwj26gRdhx7RLG2LB97RoI4RKkhJyAQkcC1J3DSWUnK
         DR9lmkRRV68OipoDMfH38dRDiQIgxxsFCSEywpzoJQx/ORDjkxDvnlfffCpXnXy+FN2W
         UyHuSCyBy+m4lAVXfslijmrC5GYk+wSmP2JSASVg5gLC3Fgv9jv7eJcuhOnZieDbjM23
         lO1A==
X-Gm-Message-State: AOAM532LRpqugl3YleS9dlfoY6tGIoaDHW5SSe3k/QRTZEnQFn/oKT+y
        rMVPGRLNZOSZoffulncNN7s=
X-Google-Smtp-Source: ABdhPJz5wghyBWWMgvNVmm6L8kq6se/D4jpssaNA6P0qIsB0sUnGzEi4cKQu7LGKnjpzssfaUaqv8Q==
X-Received: by 2002:a63:2004:0:b0:375:ed63:ab4c with SMTP id g4-20020a632004000000b00375ed63ab4cmr9405531pgg.255.1648454768060;
        Mon, 28 Mar 2022 01:06:08 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id j14-20020a056a00174e00b004f66ce6367bsm16752080pfc.147.2022.03.28.01.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 01:06:07 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     rgoldwyn@suse.com, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] md: fix an incorrect NULL check in md_reload_sb
Date:   Mon, 28 Mar 2022 16:05:59 +0800
Message-Id: <20220328080559.25984-1-xiam0nd.tong@gmail.com>
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
Fixes: 70bcecdb1534 ("amd-cluster: Improve md_reload_sb to be less error prone")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes from v1:
 - rephrase the subject (Guoqing Jiang)

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

