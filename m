Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0562E176B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgLWDJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgLWCSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FA962333E;
        Wed, 23 Dec 2020 02:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689824;
        bh=jgDMhoTyoK1/RUr17XYy22VC/nKPC37Of8t6WeoISOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqG+dsfC9Ofl2+ljQCSngOy93WDGawdcuGKhoX7l98EnpRUQj5eyc+zBuYPUbeMYq
         smrVP12l4EmTSNUndHkmTnePLhtiXxUJMQDoLlwWeDAXOZhZPW9wiW4aA8jMQ9VuMA
         xd0XDvJGExoZUakHyLltf7E5h0jFk04SJN77tJClODV/XSM64GfwJ/mj4kOb5lq69g
         vZJWifh44iEaPwO2dKWEpbtPDG5lkvzmgAYxG+T1LNhCztdJ+IpHBNEKofBKjd1gLQ
         giorogI4//ZYgvVhgVJyXvNhvpmoTEPyrLBQlnaqru+JNLx8QeWhXWJBHMV4x5a9a/
         jPQG+9FvKSAuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 029/217] scsi: target: Fix cmd_count ref leak
Date:   Tue, 22 Dec 2020 21:13:18 -0500
Message-Id: <20201223021626.2790791-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 02dd4914b0bcb8fd8f8cad9817f5715a17466261 ]

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iSCSI and loop do not call target_sess_cmd_list_set_waiting
during session shutdown, though, so they have been calling percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Link: https://lore.kernel.org/r/1604257174-4524-3-git-send-email-michael.christie@oracle.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0a5f600..d47619a5d172e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -238,6 +238,14 @@ EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	/*
+	 * Drivers like iscsi and loop do not call
+	 * target_sess_cmd_list_set_waiting during session shutdown so we
+	 * have to drop the ref taken at init time here.
+	 */
+	if (!se_sess->sess_tearing_down)
+		percpu_ref_put(&se_sess->cmd_count);
+
 	percpu_ref_exit(&se_sess->cmd_count);
 }
 
-- 
2.27.0

