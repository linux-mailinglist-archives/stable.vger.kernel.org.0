Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2C86C746
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390354AbfGRDHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389830AbfGRDHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:07:09 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6EAB2053B;
        Thu, 18 Jul 2019 03:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419229;
        bh=LyZ1n9E0H3QVsJ1XmRdofYE6LF/cEyXD7zYBG/sL34s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FO1ejG7lioNEwT2jOeoiK4zoI7eJ26mNygIdLqqJVlXjJVaKw5hwunL8t+mKGjZuh
         sFxXu9ZwOHXbX1Bt49JEX79IUiYyX2at6xvICL/g2tffMLkhLrUxh76ZDTxdnN6EVh
         e4xR9gs2kB+E+mBWb5+ferH8tnSkleoWXrr1RTHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/47] dm verity: use message limit for data block corruption message
Date:   Thu, 18 Jul 2019 12:01:35 +0900
Message-Id: <20190718030050.489111670@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2eba4e640b2c4161e31ae20090a53ee02a518657 ]

DM verity should also use DMERR_LIMIT to limit repeat data block
corruption messages.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index fc65f0dedf7f..e3599b43f9eb 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -236,8 +236,8 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 		BUG();
 	}
 
-	DMERR("%s: %s block %llu is corrupted", v->data_dev->name, type_str,
-		block);
+	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
+		    type_str, block);
 
 	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
 		DMERR("%s: reached maximum errors", v->data_dev->name);
-- 
2.20.1



