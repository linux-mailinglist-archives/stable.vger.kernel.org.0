Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5626490A
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfGJPDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbfGJPDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E952064A;
        Wed, 10 Jul 2019 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562771011;
        bh=LMO9SlGP21+nsQr6IidSCJbD4Vg7RTJcjTaiZ0yhzkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoEYXNC0ZyXNuuIhQ0C0QecXby4+pSaCpVjSklvtNZcgco6h7VGeLozuRH5i2BuMC
         3o/UIuQNXeb6Jrhz7ughDmpK8G5KrbUWx2bxtSNjCpEp6vCl/RjNLJe2lvZPqBnWQ/
         fkRjQzmp7RVrP/nTNwq3s6LFu3Wvm9OsUtfccv/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Chris Leech <cleech@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/8] scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not supported
Date:   Wed, 10 Jul 2019 11:03:15 -0400
Message-Id: <20190710150319.7258-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150319.7258-1-sashal@kernel.org>
References: <20190710150319.7258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 5dd6c49339126c2c8df2179041373222362d6e49 ]

If the CHAP_A value is not supported, the chap_server_open() function
should free the auth_protocol pointer and set it to NULL, or we will leave
a dangling pointer around.

[   66.010905] Unsupported CHAP_A value
[   66.011660] Security negotiation failed.
[   66.012443] iSCSI Login negotiation failed.
[   68.413924] general protection fault: 0000 [#1] SMP PTI
[   68.414962] CPU: 0 PID: 1562 Comm: targetcli Kdump: loaded Not tainted 4.18.0-80.el8.x86_64 #1
[   68.416589] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   68.417677] RIP: 0010:__kmalloc_track_caller+0xc2/0x210

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_auth.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 4e680d753941..e2fa3a3bc81d 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -89,6 +89,12 @@ static int chap_check_algorithm(const char *a_str)
 	return CHAP_DIGEST_UNKNOWN;
 }
 
+static void chap_close(struct iscsi_conn *conn)
+{
+	kfree(conn->auth_protocol);
+	conn->auth_protocol = NULL;
+}
+
 static struct iscsi_chap *chap_server_open(
 	struct iscsi_conn *conn,
 	struct iscsi_node_auth *auth,
@@ -126,7 +132,7 @@ static struct iscsi_chap *chap_server_open(
 	case CHAP_DIGEST_UNKNOWN:
 	default:
 		pr_err("Unsupported CHAP_A value\n");
-		kfree(conn->auth_protocol);
+		chap_close(conn);
 		return NULL;
 	}
 
@@ -141,19 +147,13 @@ static struct iscsi_chap *chap_server_open(
 	 * Generate Challenge.
 	 */
 	if (chap_gen_challenge(conn, 1, aic_str, aic_len) < 0) {
-		kfree(conn->auth_protocol);
+		chap_close(conn);
 		return NULL;
 	}
 
 	return chap;
 }
 
-static void chap_close(struct iscsi_conn *conn)
-{
-	kfree(conn->auth_protocol);
-	conn->auth_protocol = NULL;
-}
-
 static int chap_server_compute_md5(
 	struct iscsi_conn *conn,
 	struct iscsi_node_auth *auth,
-- 
2.20.1

