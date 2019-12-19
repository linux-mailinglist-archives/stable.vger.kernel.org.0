Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F6126A1C
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfLSSoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbfLSSoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6F224672;
        Thu, 19 Dec 2019 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781051;
        bh=Y502lsPMB5qgMHI4OhlUNf8KmzIbMdwOn7jSQLvZNAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2LL6gub0vSkT48DnbY1gl9vfnY6dT5dXf57Zd1UomtodaLFc2757lu3onKiFi2M6
         q8mr3Fmtl+6Ghh1DgFdx1nLF5Stgu20XTKS1KJ1SKNvp3xqn0Lugm39+5cMYd/BGkS
         WaJ0bGq2RSiEC1j66xNyDgPkcg6Bswhs04hZ2PPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 062/199] dlm: fix invalid cluster name warning
Date:   Thu, 19 Dec 2019 19:32:24 +0100
Message-Id: <20191219183218.437070869@linuxfoundation.org>
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
index 57f2aacec97f5..bb0d307deadd3 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -25,6 +25,7 @@
 #include "lvb_table.h"
 #include "user.h"
 #include "ast.h"
+#include "config.h"
 
 static const char name_prefix[] = "dlm";
 static const struct file_operations device_fops;
@@ -402,7 +403,7 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	error = dlm_new_lockspace(params->name, NULL, params->flags,
+	error = dlm_new_lockspace(params->name, dlm_config.ci_cluster_name, params->flags,
 				  DLM_USER_LVB_LEN, NULL, NULL, NULL,
 				  &lockspace);
 	if (error)
-- 
2.20.1



