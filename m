Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED7B53E7D2
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbiFFOdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbiFFOdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:11 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687362AC5F;
        Mon,  6 Jun 2022 07:33:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p10so20118989wrg.12;
        Mon, 06 Jun 2022 07:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1QqcTEPtoODTXKz5bXn/012pkjfLEsGJrtDgaQa4Ijw=;
        b=Ib49PzdWGwEDkmiRo1kCrpEvD3rUNAHDiUAO9fAKNOejpqOXliEMniLhMv4BmSbMZ5
         0KJ11+QorM3i8WCBn1JwbBQaLbrP5qgQ9MnkVYxZ8CCn7YxR3DOkRpsuhJVog9AVeWNz
         Tt5f8347aQrIySRHQ0y6h0Xy5xy9jF8Mt8JWDvjtTa2+Ob1jK6LCf4FBXUJox6MGUHT/
         g194Y/utE9B8H+Q781LcyHdILTT89CxZd4ZiPxZ0j48Ak9C9M9BvPAHx0297qr4xWChw
         HClUHMHTHk7+xMrEbsMz/PUTeCo7+10wGDwbv9AHcJPteBN1cka05is9+C/osey+CORp
         bVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1QqcTEPtoODTXKz5bXn/012pkjfLEsGJrtDgaQa4Ijw=;
        b=3vwJjlirwh5sZD0jRNqkrbmaji7Ip7xN1a8oC3He8C1rJ+sv+7AwTbWPa1mnE+mGgx
         MQwlCs7mjv86hcbWbu5VAmIBqMgBmiX0gCkBFxFcxClW4TpV7dg9u2h/lpm6UyBxD0az
         YJ/HRsE68pN3G+yytfavTQhN9A04K80w/j3Vtrk25twcHmO0NY9VbNkbSIarOkzUdWHK
         A5QAPZeSBztS0qr7VqiN4idGZkUQikQTKw1FZcjRPfzNdmK2JdYlKKQ+JVLXlGT7CSUB
         6rcHvEhqnLTe2yM27EXryIU6O7qhZKv452yOJHQ7YiZSe3UsfX6Zh+dzUycpYpxhHM7H
         4fyw==
X-Gm-Message-State: AOAM530ypGga5UIwjoo06u0sQZXvzYmflL2ZP4ozF7Qz9teKjjnuApiL
        kboVFOR+citBtlpZSw7+skc=
X-Google-Smtp-Source: ABdhPJwZm7a+WVaiXpXkbBFEypjjggoNyMCYBaYFbMik0IO+NmcOo+VVAkNMpipktdyQt24TMjcoBg==
X-Received: by 2002:a05:6000:1542:b0:20f:f809:cf89 with SMTP id 2-20020a056000154200b0020ff809cf89mr21740382wry.361.1654525988797;
        Mon, 06 Jun 2022 07:33:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 5.10 v2 4/8] xfs: fix incorrect root dquot corruption error when switching group/project quota types
Date:   Mon,  6 Jun 2022 17:32:51 +0300
Message-Id: <20220606143255.685988-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 45068063efb7dd0a8d115c106aa05d9ab0946257 upstream.

While writing up a regression test for broken behavior when a chprojid
request fails, I noticed that we were logging corruption notices about
the root dquot of the group/project quota file at mount time when
testing V4 filesystems.

In commit afeda6000b0c, I was trying to improve ondisk dquot validation
by making sure that when we load an ondisk dquot into memory on behalf
of an incore dquot, the dquot id and type matches.  Unfortunately, I
forgot that V4 filesystems only have two quota files, and can switch
that file between group and project quota types at mount time.  When we
perform that switch, we'll try to load the default quota limits from the
root dquot prior to running quotacheck and log a corruption error when
the types don't match.

This is inconsequential because quotacheck will reset the second quota
file as part of doing the switch, but we shouldn't leave scary messages
in the kernel log.

Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_dquot.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1d95ed387d66..80c4579d6835 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -500,6 +500,42 @@ xfs_dquot_alloc(
 	return dqp;
 }
 
+/* Check the ondisk dquot's id and type match what the incore dquot expects. */
+static bool
+xfs_dquot_check_type(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	uint8_t			ddqp_type;
+	uint8_t			dqp_type;
+
+	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
+	dqp_type = xfs_dquot_type(dqp);
+
+	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
+		return false;
+
+	/*
+	 * V5 filesystems always expect an exact type match.  V4 filesystems
+	 * expect an exact match for user dquots and for non-root group and
+	 * project dquots.
+	 */
+	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
+	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
+		return ddqp_type == dqp_type;
+
+	/*
+	 * V4 filesystems support either group or project quotas, but not both
+	 * at the same time.  The non-user quota file can be switched between
+	 * group and project quota uses depending on the mount options, which
+	 * means that we can encounter the other type when we try to load quota
+	 * defaults.  Quotacheck will soon reset the the entire quota file
+	 * (including the root dquot) anyway, but don't log scary corruption
+	 * reports to dmesg.
+	 */
+	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
+}
+
 /* Copy the in-core quota fields in from the on-disk buffer. */
 STATIC int
 xfs_dquot_from_disk(
@@ -512,8 +548,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
-	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
+	if (!xfs_dquot_check_type(dqp, ddqp)) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);
-- 
2.25.1

