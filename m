Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD321126A91
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfLSSsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729671AbfLSSsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A75A24682;
        Thu, 19 Dec 2019 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781323;
        bh=letbtSQP/YSdE1Oeu6VrrL5GA1YWFBCC4BEfr7ppU5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lhm7GvBetAkTCiIj0Ul2VaaT9b71pqTvj1mWcHMn4/KxwjUN82eeNVtFUe4XzlrP5
         hdTcJdYSRhHMbj9+WfHReAa/t469WJxvPa6Yr+GiGkusTSKT7YvKauhhVoooV9TBhx
         zVi7jLyWD3QYqWg//sLQdFbx/DYibSk0cG3ioy9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Bornyakov <brnkv.i1@gmail.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Keith Busch <keith.busch@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 175/199] nvme: host: core: fix precedence of ternary operator
Date:   Thu, 19 Dec 2019 19:34:17 +0100
Message-Id: <20191219183225.247358027@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Bornyakov <brnkv.i1@gmail.com>

commit e9a9853c23c13a37546397b61b270999fd0fb759 upstream.

Ternary operator have lower precedence then bitwise or, so 'cdw10' was
calculated wrong.

Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1043,7 +1043,7 @@ static int nvme_pr_reserve(struct block_
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | abort ? 2 : 1;
+	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
 
@@ -1055,7 +1055,7 @@ static int nvme_pr_clear(struct block_de
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | key ? 1 << 3 : 0;
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 


