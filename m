Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2626D329207
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbhCAUiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237871AbhCAU3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FA036541E;
        Mon,  1 Mar 2021 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622066;
        bh=/cGct8chtji+zZuqDVMmp/AXb38bCfz0Dl3gEEcjk8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nHEqyyD2vAbXdidx/F/xCjhS87typydgGESbjuUrKQ/XXef0MJUb7JpqM4UXG4V1
         /B+5l3uR1kyRKjzg4xYTByy6qByU7eCGC+pZy9g4v+kkUL77OAaq+2FzfXqXhjkiXf
         KjEbaZAohEzJR9HUcHISlftpp6gpEULY+F1nTqV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Taylor <simon@simon-taylor.me.uk>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 744/775] cifs: fix handling of escaped , in the password mount argument
Date:   Mon,  1 Mar 2021 17:15:12 +0100
Message-Id: <20210301161238.095698581@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit d08395a3f2f473c6ceeb316a1aeb7fad5b43014f upstream.

Passwords can contain ',' which are also used as the separator between
mount options. Mount.cifs will escape all ',' characters as the string ",,".
Update parsing of the mount options to detect ",," and treat it as a single
'c' character.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11
Reported-by: Simon Taylor <simon@simon-taylor.me.uk>
Tested-by: Simon Taylor <simon@simon-taylor.me.uk>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -542,20 +542,37 @@ static int smb3_fs_context_parse_monolit
 
 	/* BB Need to add support for sep= here TBD */
 	while ((key = strsep(&options, ",")) != NULL) {
-		if (*key) {
-			size_t v_len = 0;
-			char *value = strchr(key, '=');
-
-			if (value) {
-				if (value == key)
-					continue;
-				*value++ = 0;
-				v_len = strlen(value);
-			}
-			ret = vfs_parse_fs_string(fc, key, value, v_len);
-			if (ret < 0)
-				break;
+		size_t len;
+		char *value;
+
+		if (*key == 0)
+			break;
+
+		/* Check if following character is the deliminator If yes,
+		 * we have encountered a double deliminator reset the NULL
+		 * character to the deliminator
+		 */
+		while (options && options[0] == ',') {
+			len = strlen(key);
+			strcpy(key + len, options);
+			options = strchr(options, ',');
+			if (options)
+				*options++ = 0;
+		}
+
+
+		len = 0;
+		value = strchr(key, '=');
+		if (value) {
+			if (value == key)
+				continue;
+			*value++ = 0;
+			len = strlen(value);
 		}
+
+		ret = vfs_parse_fs_string(fc, key, value, len);
+		if (ret < 0)
+			break;
 	}
 
 	return ret;


