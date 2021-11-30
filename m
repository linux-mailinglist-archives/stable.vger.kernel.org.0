Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFD4637D3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243118AbhK3O4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbhK3Oyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE24C061379;
        Tue, 30 Nov 2021 06:49:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84498B81A20;
        Tue, 30 Nov 2021 14:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6588CC53FC7;
        Tue, 30 Nov 2021 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283755;
        bh=oRuAmpp5REdqeW8iRnEJPu/Vsovl/VI3cLjHZcmwVyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4rxyShlKx52j5Xnvk/W9k2vEVjbxm/8K8E9LWQXd4eOdBuM2IdgImMiY3w7LDC8/
         E2gANettHp8ne7JxlRLjzJRS6xg72bOswP0y5j0ucLQHB3HrmejJm9zy0Z7IXZ1nci
         gjdYdHY6fq+Muo0thL4ERLKuoLIHiKPFbevjt4ZHTq8/Z29pFsmlOpGAT/VbR4U6uH
         DD0VHv0heMdfrTHwGSCNSLpYiTG1EwhZOby+HmwOtxob3StyxZcUHgO1nGjgQ3fk2t
         FimxHt/J4J6hPJ2nDrXVYmKmHAGswV1R+I19JkBbOMKK7iCiOkMOetWd5Q/cxLK7NL
         t8/D83H6humPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, jbeulich@suse.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 50/68] xen: flag hvc_xen to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:46:46 -0500
Message-Id: <20211130144707.944580-50-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 0239143490a9fa1344955dde93527b09f5576dac ]

The Xen pv console driver is not essential for boot. Set the respective
flag.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-4-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_xen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index f0bf01ea069ae..71e0dd2c0ce5b 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -522,6 +522,7 @@ static struct xenbus_driver xencons_driver = {
 	.remove = xencons_remove,
 	.resume = xencons_resume,
 	.otherend_changed = xencons_backend_changed,
+	.not_essential = true,
 };
 #endif /* CONFIG_HVC_XEN_FRONTEND */
 
-- 
2.33.0

