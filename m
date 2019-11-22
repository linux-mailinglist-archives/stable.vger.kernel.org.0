Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76160106E38
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfKVLGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbfKVLGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B9A2075E;
        Fri, 22 Nov 2019 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420779;
        bh=b1zZCWHgviqi7cGaVJbe44nWhVRzGNjrthtf+9iCCxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzcAH0zrzb9bs+OSAEqkzSZChitboIKXfwrT4OH7oA1a6GRYi5zRMiRPtkCLgxst7
         SP/FtkJ5L9be4MrW3zb9NOWKI53bZGqIYlo7ADUHCryqOOrXOAi1tVEBwNp2nHAyYl
         sJCpGILMZKu8Us3c8n0CKM1L4+J58xDWocZFM82s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/220] PM / devfreq: Fix static checker warning in try_then_request_governor
Date:   Fri, 22 Nov 2019 11:29:41 +0100
Message-Id: <20191122100929.173069944@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit b53b0128052ffd687797d5f4deeb76327e7b5711 ]

The patch 23c7b54ca1cd: "PM / devfreq: Fix devfreq_add_device() when
drivers are built as modules." leads to the following static checker
warning:

    drivers/devfreq/devfreq.c:1043 governor_store()
    warn: 'governor' can also be NULL

The reason is that the try_then_request_governor() function returns both
error pointers and NULL. It should just return error pointers, so fix
this by returning a ERR_PTR to the error intead of returning NULL.

Fixes: 23c7b54ca1cd ("PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index bcd2279106760..e2ab46bfa666e 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -231,7 +231,7 @@ static struct devfreq_governor *find_devfreq_governor(const char *name)
  * if is not found. This can happen when both drivers (the governor driver
  * and the driver that call devfreq_add_device) are built as modules.
  * devfreq_list_lock should be held by the caller. Returns the matched
- * governor's pointer.
+ * governor's pointer or an error pointer.
  */
 static struct devfreq_governor *try_then_request_governor(const char *name)
 {
@@ -257,7 +257,7 @@ static struct devfreq_governor *try_then_request_governor(const char *name)
 		/* Restore previous state before return */
 		mutex_lock(&devfreq_list_lock);
 		if (err)
-			return NULL;
+			return ERR_PTR(err);
 
 		governor = find_devfreq_governor(name);
 	}
-- 
2.20.1



