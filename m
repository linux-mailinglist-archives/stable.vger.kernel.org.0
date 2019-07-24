Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B49C73BB6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405586AbfGXUCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404679AbfGXUCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:02:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A596A20665;
        Wed, 24 Jul 2019 20:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998567;
        bh=0ec6NeFqmFZxWWpQ73b8nQMKU7+faETgn/Bt1DHjJ4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nWEunGyjzSXbdmOTpGFb9Z8XEWsNOFdxF69cp2v4fdYf4MM3cj8OL8E1FuVNNx0T
         1ThsiYud2t/DTURAGYx9a1iL8rGIMIbSv3Dy/86JAvyo/iy5DCIZi5Y1VTxUrAYEih
         eg1QbbQc/YSS/Nyrw37zgmYlvCg3AcJBaF/xtA7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Chris Leech <cleech@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/271] scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not supported
Date:   Wed, 24 Jul 2019 21:17:53 +0200
Message-Id: <20190724191655.622988677@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



