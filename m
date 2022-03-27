Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A9B4E86C8
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiC0IC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiC0IC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:02:58 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D554237A1C;
        Sun, 27 Mar 2022 01:01:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id b130so8458220pga.13;
        Sun, 27 Mar 2022 01:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ZnZllXXln8alDD0gXRFXPDmFsbfIdQAqTJP0jTsTACA=;
        b=geUAslRO0BtqDXhocnaMIbdCadsDyrG8ccZGO0Hr5PrjxML36r1IdKo5wDwvVxbRDP
         mG9TQ/cPj6yX4sBuCAlUPgLMe21Cm2BGrN61dEL5xw1WxW26ka9Sp5/97HIVSLMVJFGu
         1qzq7/Qg30OvKhbb/SceXje2tJKDV61vJHxqHp/OuB12kT1cqQwC1ufBtZY2JWXP4Jgg
         mteaB8DGleVPUxGtf4PS1/W2SW+PpU8lToiBwGpgF/rlu7DFY29641aeWyFkMJ+NCSuQ
         HAeN327L7B8MzZBjzrGmh1wDLpTPP6KWea6OGmav6CUbhHKlDSczB0qPqKWVylNqBw0w
         eFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZnZllXXln8alDD0gXRFXPDmFsbfIdQAqTJP0jTsTACA=;
        b=1ntrO4xqkNHDx55icE0SmApknpkoYFIoNvcbFHnLRk2S//m8GAHDyRsoPCDQHsXhUa
         v44/cBbKfxzdLOO0vwLY8/FnfOVOaR+6agJWEf6SFg2T6WUBfONGeqTGFsTxylh2yaqM
         8uS/AdLFMMosfUSolDxawTv6MKsNBFw5fPv4356Ar4spKkfcQwestzE08nrEzR8r3zhd
         22pawaU63W/NPUah4wS1kQIhUMNm/aRjjFpxD4/+rguk3Dy7vw5e8fhwk0YBA/ZoL2XE
         PYbpJr6VWbH/XC8vyGwx+qoVy4Z1v000h4YJNMmRTpT8ZVSMIQlGMB9FKOMDKcGzA/Yu
         JqsA==
X-Gm-Message-State: AOAM532TbjpU/3d28bdnLDZKUpwVN8jYdb8UPWawBoGS4ja2eJKPQlyM
        BRhtDxasxVdpKq0ccMTiSu0=
X-Google-Smtp-Source: ABdhPJzo9+5cGZaFGZrEkyN+iP/VR0lmUGxoh6a3CaaG8zNeL3g70vP72SiveDYhlHYyO4SN/UgJcQ==
X-Received: by 2002:a63:d13:0:b0:381:f043:c627 with SMTP id c19-20020a630d13000000b00381f043c627mr6074836pgl.168.1648368079326;
        Sun, 27 Mar 2022 01:01:19 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id t7-20020a056a0021c700b004f7916d44bcsm11747823pfj.220.2022.03.27.01.01.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:01:18 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org, rgoldwyn@suse.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] md: md2: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 16:01:11 +0800
Message-Id: <20220327080111.12028-1-xiam0nd.tong@gmail.com>
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
while use the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 70bcecdb1534 ("amd-cluster: Improve md_reload_sb to be less error prone")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
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

