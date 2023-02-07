Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE968D77B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjBGNAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjBGNAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:00:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0BA39CD2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ACDCB8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A77C433D2;
        Tue,  7 Feb 2023 12:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774793;
        bh=qT1yM+3TmoqA5/2spy6kedzotbF5GyyeRRwRP0z1LsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+lmkV+ZQ0inhCUcsHS4apdUJ+CcU4dGAkCE5+mDldgf/HuuffKSKTfmJ1Tof/EUA
         lw3knsBa/KtShjyxZNM005K+yvPX8qfxcdhZg955O8LeyXxCGoZHLFC4z66A3ebxHZ
         zM+Ry/XcLzLcVhOQhDTgLQSxZixPiT1bpwZ/7QHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/208] fix direction argument of iov_iter_{init,bvec}()
Date:   Tue,  7 Feb 2023 13:54:50 +0100
Message-Id: <20230207125635.956241309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e3bf3df824675ea9cadc3cd2c75d08ee83a6ae26 ]

READ means "data destination", WRITE - "data source".

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c  | 6 +++---
 drivers/vhost/vringh.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 547f89a6940f..c234869d6727 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -833,7 +833,7 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 				     VHOST_ACCESS_WO);
 		if (ret < 0)
 			goto out;
-		iov_iter_init(&t, WRITE, vq->iotlb_iov, ret, size);
+		iov_iter_init(&t, READ, vq->iotlb_iov, ret, size);
 		ret = copy_to_iter(from, size, &t);
 		if (ret == size)
 			ret = 0;
@@ -872,7 +872,7 @@ static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 			       (unsigned long long) size);
 			goto out;
 		}
-		iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
+		iov_iter_init(&f, WRITE, vq->iotlb_iov, ret, size);
 		ret = copy_from_iter(to, size, &f);
 		if (ret == size)
 			ret = 0;
@@ -2136,7 +2136,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
 			vq_err(vq, "Translation failure %d in indirect.\n", ret);
 		return ret;
 	}
-	iov_iter_init(&from, READ, vq->indirect, ret, len);
+	iov_iter_init(&from, WRITE, vq->indirect, ret, len);
 	count = len / sizeof desc;
 	/* Buffers are chained via a 16 bit next field, so
 	 * we can have at most 2^16 of these. */
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 828c29306565..139c782848c6 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1161,7 +1161,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, READ, iov, ret, translated);
+		iov_iter_bvec(&iter, WRITE, iov, ret, translated);
 
 		ret = copy_from_iter(dst, translated, &iter);
 		if (ret < 0)
@@ -1194,7 +1194,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, WRITE, iov, ret, translated);
+		iov_iter_bvec(&iter, READ, iov, ret, translated);
 
 		ret = copy_to_iter(src, translated, &iter);
 		if (ret < 0)
-- 
2.39.0



