Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF2EEF30
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388935AbfKDWBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388932AbfKDWBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:00 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 632DE2084D;
        Mon,  4 Nov 2019 22:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904859;
        bh=OxJUN0GrULCx4YrxlFaDCHBM54iQLptJdAzFRmA69q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5luihu3BtKeibnOp7ZUVuc+SgE+nvLIymsZ0rZH088P2jQVqELoLgsLQrzqcUM+8
         JQGiuqdIT9UocDC8AKvBLHC/RMtbQlPWrmtWvbGQgLb//VjJkqH6egXkLW4v3Y9HPg
         /acyUV00lvGztvyttVHc/C5v/yUG1H92NpTn27I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/149] virt: vbox: fix memory leak in hgcm_call_preprocess_linaddr
Date:   Mon,  4 Nov 2019 22:44:50 +0100
Message-Id: <20191104212143.328568824@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit e0b0cb9388642c104838fac100a4af32745621e2 ]

In hgcm_call_preprocess_linaddr memory is allocated for bounce_buf but
is not released if copy_form_user fails. In order to prevent memory leak
in case of failure, the assignment to bounce_buf_ret is moved before the
error check. This way the allocated bounce_buf will be released by the
caller.

Fixes: 579db9d45cb4 ("virt: Add vboxguest VMMDEV communication code")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20190930204223.3660-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/vboxguest/vboxguest_utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/vboxguest/vboxguest_utils.c b/drivers/virt/vboxguest/vboxguest_utils.c
index bf4474214b4d3..92091006589a9 100644
--- a/drivers/virt/vboxguest/vboxguest_utils.c
+++ b/drivers/virt/vboxguest/vboxguest_utils.c
@@ -217,6 +217,8 @@ static int hgcm_call_preprocess_linaddr(
 	if (!bounce_buf)
 		return -ENOMEM;
 
+	*bounce_buf_ret = bounce_buf;
+
 	if (copy_in) {
 		ret = copy_from_user(bounce_buf, (void __user *)buf, len);
 		if (ret)
@@ -225,7 +227,6 @@ static int hgcm_call_preprocess_linaddr(
 		memset(bounce_buf, 0, len);
 	}
 
-	*bounce_buf_ret = bounce_buf;
 	hgcm_call_add_pagelist_size(bounce_buf, len, extra);
 	return 0;
 }
-- 
2.20.1



