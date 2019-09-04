Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4934A8C27
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbfIDQKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732855AbfIDQA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7139023431;
        Wed,  4 Sep 2019 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612857;
        bh=aIqb/ccVgpL0SgjA7bseadHGY2YNbqvN7lKVsPwFE/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph1SZFK49h90iFZxPzbEnBWBkcWbom1/HShmfNbkQeLV5w0pN5EWarFJCSEnSl/hd
         lKXAeZ0DFcuiHvH1iTtrrju9qfCvnUYa3GIrMyIY8Npa0RF+jY9JCDTLOjkM+2TepX
         fs2N2meWOMnF08D7SjOGbKorFep9324uGEho7tpo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/52] cifs: set domainName when a domain-key is used in multiuser
Date:   Wed,  4 Sep 2019 11:59:48 -0400
Message-Id: <20190904160004.3671-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit f2aee329a68f5a907bcff11a109dfe17c0b41aeb ]

RHBZ: 1710429

When we use a domain-key to authenticate using multiuser we must also set
the domainnmame for the new volume as it will be used and passed to the server
in the NTLMSSP Domain-name.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c53a2e86ed544..6e004eb1b2bb8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2756,6 +2756,7 @@ static int
 cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 {
 	int rc = 0;
+	int is_domain = 0;
 	const char *delim, *payload;
 	char *desc;
 	ssize_t len;
@@ -2803,6 +2804,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = PTR_ERR(key);
 			goto out_err;
 		}
+		is_domain = 1;
 	}
 
 	down_read(&key->sem);
@@ -2860,6 +2862,26 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 		goto out_key_put;
 	}
 
+	/*
+	 * If we have a domain key then we must set the domainName in the
+	 * for the request.
+	 */
+	if (is_domain && ses->domainName) {
+		vol->domainname = kstrndup(ses->domainName,
+					   strlen(ses->domainName),
+					   GFP_KERNEL);
+		if (!vol->domainname) {
+			cifs_dbg(FYI, "Unable to allocate %zd bytes for "
+				 "domain\n", len);
+			rc = -ENOMEM;
+			kfree(vol->username);
+			vol->username = NULL;
+			kfree(vol->password);
+			vol->password = NULL;
+			goto out_key_put;
+		}
+	}
+
 out_key_put:
 	up_read(&key->sem);
 	key_put(key);
-- 
2.20.1

