Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA12E409657
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345273AbhIMOvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346099AbhIMOrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 535EE6323E;
        Mon, 13 Sep 2021 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541554;
        bh=JGtyvFusl+H8klQABYldTExrZ9rGErbrO7in6R3WAmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAxLZrehvsygXfFi9ilrm81q7glF/44/gl6ju2IUO0JNcOHjeDHK8FB0kP7XvNvgB
         CJJi4CMdnRntJdy517zg6wiJsQ4ppviVjvD+hcb1llNIlXIkyFk3UuAGFE6fy0RBe0
         FJ9/eyIuFvhy7FXT9m/79FQWt5qPqtmW+vK76PrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 306/334] cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED
Date:   Mon, 13 Sep 2021 15:16:00 +0200
Message-Id: <20210913131123.762721637@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 3998f0b8bc49ec784990971dc1f16bf367b19078 upstream.

RHBZ: 1994393

If we hit a STATUS_USER_SESSION_DELETED for the Create part in the
Create/QueryDirectory compound that starts a directory scan
we will leak EDEADLK back to userspace and surprise glibc and the application.

Pick this up initiate_cifs_search() and retry a small number of tries before we
return an error to userspace.

Cc: stable@vger.kernel.org
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/readdir.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -369,7 +369,7 @@ int get_symlink_reparse_path(char *full_
  */
 
 static int
-initiate_cifs_search(const unsigned int xid, struct file *file,
+_initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
 {
 	__u16 search_flags;
@@ -451,6 +451,27 @@ error_exit:
 	return rc;
 }
 
+static int
+initiate_cifs_search(const unsigned int xid, struct file *file,
+		     const char *full_path)
+{
+	int rc, retry_count = 0;
+
+	do {
+		rc = _initiate_cifs_search(xid, file, full_path);
+		/*
+		 * If we don't have enough credits to start reading the
+		 * directory just try again after short wait.
+		 */
+		if (rc != -EDEADLK)
+			break;
+
+		usleep_range(512, 2048);
+	} while (retry_count++ < 5);
+
+	return rc;
+}
+
 /* return length of unicode string in bytes */
 static int cifs_unicode_bytelen(const char *str)
 {


