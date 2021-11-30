Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C0463899
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbhK3PFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243800AbhK3O6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC201C0613B6;
        Tue, 30 Nov 2021 06:51:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73EEBB81A22;
        Tue, 30 Nov 2021 14:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8BAC53FD0;
        Tue, 30 Nov 2021 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283906;
        bh=XAjwUAiM/j8BKJZ3MPSJmE9O/lcstYIzLJvobanl0m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ewx6RN0gxrmQeqNLVGyYJLC0hrzXkdHRUE37iBemJboFNwbadRv7YVr+ipy+IwVAB
         PE0XVRVAIDmySM4q//8c46X8dO36NntjUptjl9oltYz8UoqVkdxrhQYY92WelHjyiS
         qyZmZBJvcka0P4/ZXeV9kc/w/uZka5gKUl2DajcLD5Wpl2nuGXxy3JKTxSYfS4jyd2
         Il0LfBV7F/lZJ6ejwOWKIkRBcsEiIUVXLNyPRdhjs8cLnGokRNod2Lqi7L+OLeIoqP
         SLWH/7kFcjh7lzqwF1oWSQvuJE8GfPSaGjqDuEZpF4Z2uHpdBt+TLG+uEigq80VG8E
         QrbceAUStiIYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 37/43] xen: flag pvcalls-front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:50:14 -0500
Message-Id: <20211130145022.945517-37-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 03e143b2acebe23c893f22ebed9abc0fe2a7f27e ]

The Xen pvcalls device is not essential for booting. Set the respective
flag.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-5-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 7984645b59563..3c9ae156b597f 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -1275,6 +1275,7 @@ static struct xenbus_driver pvcalls_front_driver = {
 	.probe = pvcalls_front_probe,
 	.remove = pvcalls_front_remove,
 	.otherend_changed = pvcalls_front_changed,
+	.not_essential = true,
 };
 
 static int __init pvcalls_frontend_init(void)
-- 
2.33.0

