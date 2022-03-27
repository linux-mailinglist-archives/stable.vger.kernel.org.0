Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D8A4E8603
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiC0Fl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiC0Fl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:41:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6671DAE7E;
        Sat, 26 Mar 2022 22:39:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b13so7952461pfv.0;
        Sat, 26 Mar 2022 22:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ob+OXwWZiaAT1wgeapdif7zoQZDfy6ZBFlhYNrodhMc=;
        b=RqEHSCfb+QbnfYZwAtmC/SDDUOSUi//6hbKzOUqk6lp2qzngOzpowTw5szGwJbOjQy
         BbGf7hoP3EJ7mw5l2AXRHleXB/xmy3d9fcdRE50DBQagSHtM8HOzeLFPVquJwHgSoYAQ
         b5mN+MjHZk69it9Cgju4t7rWOCmhWnDLj63tE1+0r9qd76xxnUV3j3uIH6V4joKwbR6m
         ZubyRn4oRxsqGAMEWhGkWxL5rw5+RwAIyiUDkd5YdDoLyx3t8GHQz38OmMtLsicl2H2l
         7JTND0Ng6bwS64SuhrM1UYAHBdSL3Tju39sE51GAnb1jY/UzPcbszmAOYwyRzkcjaZQi
         O4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ob+OXwWZiaAT1wgeapdif7zoQZDfy6ZBFlhYNrodhMc=;
        b=p7mhVCddlaClKMW7x1GgglyxqkDnTvjof/FHlmwolZbtnm4V1coDuQED9im38Sqahx
         5b3iAZewM81URJDcrwxvV7APveiy2O06/iRgH0DQx8dkzMv/J68hmW3cAEB4AWrNNulv
         EFzBlI0BhFeHft6a/IkHLCrngOujzkmipRgbLPhecbDFuMEGXcqS8MLAKs1BMVSqctGj
         bYEO7DVXBfXTS4+Ex6kqwkzzh+0c0l0TnEXme0fDbjQAY4xXvGig9NGX1iqKHg9ziDg8
         siGRV3uol96dMaNZhPq3vAAPGJ6CayWD+fm0Je5sGkcAPs0ZMnaZ5kkVi7avmYjH8ws9
         1Xig==
X-Gm-Message-State: AOAM533NTRovmK1F9Kf+NEIG0aP0of02mqhBdElDoaGI81rRd2Y/PHah
        AcUb+ii7YTp8nnp0hM+ZaNA=
X-Google-Smtp-Source: ABdhPJyla4FQM+mvX32PKfNOabBhqXJU/+BJs8D8vS5zHBvc+M4CoPCghwIMpX6zVtybbPp0xBskjA==
X-Received: by 2002:a65:5247:0:b0:382:9715:44fe with SMTP id q7-20020a655247000000b00382971544femr5701429pgp.577.1648359589005;
        Sat, 26 Mar 2022 22:39:49 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id d2-20020a056a0024c200b004f6b6817549sm12377988pfv.173.2022.03.26.22.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:39:48 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     vireshk@kernel.org
Cc:     nm@ti.com, sboyd@kernel.org, rafael.j.wysocki@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] opp: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 13:39:43 +0800
Message-Id: <20220327053943.3071-1-xiam0nd.tong@gmail.com>
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
    dev = new_dev->dev;

The list iterator 'new_dev' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, add an check. Use a new variable 'iter' as the
list iterator, while use the old variable 'new_dev' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: deaa51465105a ("PM / OPP: Add debugfs support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/opp/debugfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 596c185b5dda..a4476985e4ce 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -187,14 +187,19 @@ void opp_debug_register(struct opp_device *opp_dev, struct opp_table *opp_table)
 static void opp_migrate_dentry(struct opp_device *opp_dev,
 			       struct opp_table *opp_table)
 {
-	struct opp_device *new_dev;
+	struct opp_device *new_dev = NULL, *iter;
 	const struct device *dev;
 	struct dentry *dentry;
 
 	/* Look for next opp-dev */
-	list_for_each_entry(new_dev, &opp_table->dev_list, node)
-		if (new_dev != opp_dev)
+	list_for_each_entry(iter, &opp_table->dev_list, node)
+		if (iter != opp_dev) {
+			new_dev = iter;
 			break;
+		}
+
+	if (!new_dev)
+		return;
 
 	/* new_dev is guaranteed to be valid here */
 	dev = new_dev->dev;
-- 
2.17.1

