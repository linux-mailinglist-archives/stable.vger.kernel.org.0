Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A92121900
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfLPRyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfLPRyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CE02053B;
        Mon, 16 Dec 2019 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518888;
        bh=R/1Pe+51lnUrSYgci/VpK5jOdqWlvHLMMjNQ13mXhUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhmYuAQW/1O9jYLmRdxtV3FiePalMStISec0Xw0nU5XgQBycLJILvLrxXZhJDBGZT
         SsFE6/BpIVZ4NOYLeMNzHUjk8/XVvctOP40SFg/d4YlTRvR7vj6DVr792HVW0J00Bv
         eSEqDZaB+H/czP911if9vLxGsPkR+JOTRkVPl+jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/267] dlm: fix invalid cluster name warning
Date:   Mon, 16 Dec 2019 18:47:07 +0100
Message-Id: <20191216174902.249335047@linuxfoundation.org>
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

From: David Teigland <teigland@redhat.com>

[ Upstream commit 3595c559326d0b660bb088a88e22e0ca630a0e35 ]

The warning added in commit 3b0e761ba83
  "dlm: print log message when cluster name is not set"

did not account for the fact that lockspaces created
from userland do not supply a cluster name, so bogus
warnings are printed every time a userland lockspace
is created.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 1f0c071d4a861..02de11695d0ba 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -25,6 +25,7 @@
 #include "lvb_table.h"
 #include "user.h"
 #include "ast.h"
+#include "config.h"
 
 static const char name_prefix[] = "dlm";
 static const struct file_operations device_fops;
@@ -404,7 +405,7 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	error = dlm_new_lockspace(params->name, NULL, params->flags,
+	error = dlm_new_lockspace(params->name, dlm_config.ci_cluster_name, params->flags,
 				  DLM_USER_LVB_LEN, NULL, NULL, NULL,
 				  &lockspace);
 	if (error)
-- 
2.20.1



