Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5112130F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfLPR61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbfLPR6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:58:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE18205ED;
        Mon, 16 Dec 2019 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519102;
        bh=Tq1/5fPlzCnrmjEKJYkJ4HNVUR07SsD7RSrgauShTUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1ufLlsv7RhR2HgtLtjB6zlezgFCtsGdgm9ZHFYdV/Z8EP1VWZTMmKyOicXPxbOnH
         yURQL4AkyfCxWHlSqScGh4UF3899cvno8QYjlKSWIrBe7F2jC6yIW7lGw8qbeQLmID
         E9ARtUjygzi8Vhy3lnaiOG+aao77kN9Bm0QzChRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 197/267] md/raid0: Fix an error message in raid0_make_request()
Date:   Mon, 16 Dec 2019 18:48:43 +0100
Message-Id: <20191216174913.320713854@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e3fc3f3d0943b126f76b8533960e4168412d9e5a ]

The first argument to WARN() is supposed to be a condition.  The
original code will just print the mdname() instead of the full warning
message.

Fixes: c84a1372df92 ("md/raid0: avoid RAID0 data corruption due to layout confusion.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 449c4dd060fcd..204adde004a3c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -616,7 +616,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		tmp_dev = map_sector(mddev, zone, sector, &sector);
 		break;
 	default:
-		WARN("md/raid0:%s: Invalid layout\n", mdname(mddev));
+		WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
 		bio_io_error(bio);
 		return true;
 	}
-- 
2.20.1



