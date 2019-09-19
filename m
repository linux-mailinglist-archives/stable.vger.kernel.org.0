Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6FB8444
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405413AbfISWJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405379AbfISWJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E1B21928;
        Thu, 19 Sep 2019 22:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930964;
        bh=xNd4kCXq6hUuyEVyhnEMc4+6Y/+LDdNmnahKeej3FwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuwNSH4t7Ijvn+oYEBDQO8Z1bkiOikGqoAuNk0g5lQScuQ0e0hKLIsCM1I800qGHz
         PoZkjBtSvcalwjReyvDdseZtW0PpVVK1+NOpRiz06Gm2OuaKcmpTZeRBGu+Vb6qqUX
         oLy1/bv9CCeNMwNTz7GoXzOQ2sSRD0lsV+RpU79M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 079/124] cifs: set domainName when a domain-key is used in multiuser
Date:   Fri, 20 Sep 2019 00:02:47 +0200
Message-Id: <20190919214821.884661825@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 18c7c6b2fe08a..2beaa14519f5d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2961,6 +2961,7 @@ static int
 cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 {
 	int rc = 0;
+	int is_domain = 0;
 	const char *delim, *payload;
 	char *desc;
 	ssize_t len;
@@ -3008,6 +3009,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = PTR_ERR(key);
 			goto out_err;
 		}
+		is_domain = 1;
 	}
 
 	down_read(&key->sem);
@@ -3065,6 +3067,26 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
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



