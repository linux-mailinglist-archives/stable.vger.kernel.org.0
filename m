Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E27CAAE0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbfJCQQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389106AbfJCQQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33CF020865;
        Thu,  3 Oct 2019 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119411;
        bh=g5n/f2orquoWGH33QaUBF3fe0GsS1SbY/85pMcYcF4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwM6At4Dn4bvuI5Hs8tr1ymbD/ICVXNiyr8XgmYJUpCBga7hiDWZWXqOYg0hh2Zgy
         vt52O0fh6gatthz+cCtUr+QbK4TQ2ThIR8QnFEp2IWLXtqi+JKY2Eh7qw2mjDouQbd
         sfLNqtQlH028kDr0RG9kU87lq7Lb1Q+PXhP560k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/211] md: dont call spare_active in md_reap_sync_thread if all member devices cant work
Date:   Thu,  3 Oct 2019 17:52:01 +0200
Message-Id: <20191003154500.825598265@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

[ Upstream commit 0d8ed0e9bf9643f27f4816dca61081784dedb38d ]

When add one disk to array, the md_reap_sync_thread is responsible
to activate the spare and set In_sync flag for the new member in
spare_active().

But if raid1 has one member disk A, and disk B is added to the array.
Then we offline A before all the datas are synchronized from A to B,
obviously B doesn't have the latest data as A, but B is still marked
with In_sync flag.

So let's not call spare_active under the condition, otherwise B is
still showed with 'U' state which is not correct.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fb5d702e43b5b..73758b3679a11 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8948,7 +8948,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
+	    mddev->degraded != mddev->raid_disks) {
 		/* success...*/
 		/* activate any spares */
 		if (mddev->pers->spare_active(mddev)) {
-- 
2.20.1



