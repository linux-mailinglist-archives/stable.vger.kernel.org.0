Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B122F3B617A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhF1OgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234931AbhF1OeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 910DA61C4D;
        Mon, 28 Jun 2021 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890474;
        bh=vkswk7UbOZ3+JsU+pqXCR6lirRP7QuJ+DcBMYyBrDnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lswwug0XCeQ+Gt2zkFAs+BXnjhxQwGziUGEpGcFF8EDYyDjtK7qTZYo2CLHq7s3Wr
         4p0qvQ7+SW1gyyLGW07Fg5sD6ul0ZD984oSyMuQ8OOpnS1JmLDNSTMi8DIi7toDmGw
         udO+QYWjWz1GvsTS/EjSipGY1mX7jhU6M0UQuneCuOac1AKHa1hjWe3I8cOa8dlRbF
         FdwKUGm/iN1DcvoIjLxKBAMANljjSUKIeJtNsdOQtb9jwYe7g76WD10urNcyj2G4U4
         /ZaB0lacUMIXUfWYbbN0fwuGb435uHiZ/kjR9U3TbyEtYu10/3LM8H4+Gp6a6cSFQa
         eatQDoSnpySNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Snowberg <eric.snowberg@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/101] integrity: Load mokx variables into the blacklist keyring
Date:   Mon, 28 Jun 2021 10:26:06 -0400
Message-Id: <20210628142607.32218-101-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Snowberg <eric.snowberg@oracle.com>

[ Upstream commit ebd9c2ae369a45bdd9f8615484db09be58fc242b ]

During boot the Secure Boot Forbidden Signature Database, dbx,
is loaded into the blacklist keyring.  Systems booted with shim
have an equivalent Forbidden Signature Database called mokx.
Currently mokx is only used by shim and grub, the contents are
ignored by the kernel.

Add the ability to load mokx into the blacklist keyring during boot.

Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
cc: keyrings@vger.kernel.org
Link: https://lore.kernel.org/r/c33c8e3839a41e9654f41cc92c7231104931b1d7.camel@HansenPartnership.com/
Link: https://lore.kernel.org/r/20210122181054.32635-5-eric.snowberg@oracle.com/ # v5
Link: https://lore.kernel.org/r/161428674320.677100.12637282414018170743.stgit@warthog.procyon.org.uk/
Link: https://lore.kernel.org/r/161433313205.902181.2502803393898221637.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/161529607422.163428.13530426573612578854.stgit@warthog.procyon.org.uk/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/platform_certs/load_uefi.c | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index ee4b4c666854..f290f78c3f30 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -132,8 +132,9 @@ static int __init load_moklist_certs(void)
 static int __init load_uefi_certs(void)
 {
 	efi_guid_t secure_var = EFI_IMAGE_SECURITY_DATABASE_GUID;
-	void *db = NULL, *dbx = NULL;
-	unsigned long dbsize = 0, dbxsize = 0;
+	efi_guid_t mok_var = EFI_SHIM_LOCK_GUID;
+	void *db = NULL, *dbx = NULL, *mokx = NULL;
+	unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
 	efi_status_t status;
 	int rc = 0;
 
@@ -175,6 +176,21 @@ static int __init load_uefi_certs(void)
 		kfree(dbx);
 	}
 
+	mokx = get_cert_list(L"MokListXRT", &mok_var, &mokxsize, &status);
+	if (!mokx) {
+		if (status == EFI_NOT_FOUND)
+			pr_debug("mokx variable wasn't found\n");
+		else
+			pr_info("Couldn't get mokx list\n");
+	} else {
+		rc = parse_efi_signature_list("UEFI:MokListXRT",
+					      mokx, mokxsize,
+					      get_handler_for_dbx);
+		if (rc)
+			pr_err("Couldn't parse mokx signatures %d\n", rc);
+		kfree(mokx);
+	}
+
 	/* Load the MokListRT certs */
 	rc = load_moklist_certs();
 
-- 
2.30.2

