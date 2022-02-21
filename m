Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23334BDE58
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347576AbiBUJHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:07:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347721AbiBUJGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CD030F50;
        Mon, 21 Feb 2022 00:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF2DCB80EAF;
        Mon, 21 Feb 2022 08:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B2FC36AE2;
        Mon, 21 Feb 2022 08:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433975;
        bh=FAgBnFMSrrN/3bKFuNbXbryXkImZhZnCtcmX/wA3NG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4BGBX7mEjM3youbEr3MImRD2nYt1IaOpm4R4OpHh1ieEBJXXX8h+ZyucLz4Zt3hf
         z2DaTExqk2W55KN0tj/rKMSh6HYM9S7H69XARiwQ+dT791IGzZkPDyx5cTujDTYQbN
         eclC5GtuRHR3zS/3JNcMTxEBZGLa/ia5OtSiJt9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/80] quota: make dquot_quota_sync return errors from ->sync_fs
Date:   Mon, 21 Feb 2022 09:48:57 +0100
Message-Id: <20220221084916.150145130@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit dd5532a4994bfda0386eb2286ec00758cee08444 ]

Strangely, dquot_quota_sync ignores the return code from the ->sync_fs
call, which means that quotacalls like Q_SYNC never see the error.  This
doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7abc3230c21a4..dc5f8654b277d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -693,9 +693,14 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	/* This is not very clever (and fast) but currently I don't know about
 	 * any other simple way of getting quota data to disk and we must get
 	 * them there for userspace to be visible... */
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
+	ret = sync_blockdev(sb->s_bdev);
+	if (ret)
+		return ret;
 
 	/*
 	 * Now when everything is written we can discard the pagecache so
-- 
2.34.1



