Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF51B2046
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbfIMNTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390356AbfIMNTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:08 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEC820640;
        Fri, 13 Sep 2019 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380747;
        bh=HAmmkIcp7no0uC3WdtdrKjJJZWCoxqdHRWx5eZr7dXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHHnwz+7LUz+A+8gK95fnUCcsF+1SkLkjHS3pa2WENKjYq8beBXyzJh4vRUKi0G3E
         6NejthWzxwByL5oBqEcu0sYiGY5WEb9nLDE0ULJdjjogAM4wxRUgjHVlnxUOlIj9ZV
         y7ZFHlc47PaCj4StApQoZMnhnEWHw4ijuI2+F8gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Salvatore <mike.salvatore@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/190] apparmor: reset pos on failure to unpack for various functions
Date:   Fri, 13 Sep 2019 14:06:39 +0100
Message-Id: <20190913130611.488999485@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 156e42996bd84eccb6acf319f19ce0cb140d00e3 ]

Each function that manipulates the aa_ext struct should reset it's "pos"
member on failure. This ensures that, on failure, no changes are made to
the state of the aa_ext struct.

There are paths were elements are optional and the error path is
used to indicate the optional element is not present. This means
instead of just aborting on error the unpack stream can become
unsynchronized on optional elements, if using one of the affected
functions.

Cc: stable@vger.kernel.org
Fixes: 736ec752d95e ("AppArmor: policy routines for loading and unpacking policy")
Signed-off-by: Mike Salvatore <mike.salvatore@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 40 +++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 088ea2ac85706..612f737cee836 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -223,16 +223,21 @@ static void *kvmemdup(const void *src, size_t len)
 static size_t unpack_u16_chunk(struct aa_ext *e, char **chunk)
 {
 	size_t size = 0;
+	void *pos = e->pos;
 
 	if (!inbounds(e, sizeof(u16)))
-		return 0;
+		goto fail;
 	size = le16_to_cpu(get_unaligned((__le16 *) e->pos));
 	e->pos += sizeof(__le16);
 	if (!inbounds(e, size))
-		return 0;
+		goto fail;
 	*chunk = e->pos;
 	e->pos += size;
 	return size;
+
+fail:
+	e->pos = pos;
+	return 0;
 }
 
 /* unpack control byte */
@@ -294,49 +299,66 @@ fail:
 
 static bool unpack_u32(struct aa_ext *e, u32 *data, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_U32, name)) {
 		if (!inbounds(e, sizeof(u32)))
-			return 0;
+			goto fail;
 		if (data)
 			*data = le32_to_cpu(get_unaligned((__le32 *) e->pos));
 		e->pos += sizeof(u32);
 		return 1;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static bool unpack_u64(struct aa_ext *e, u64 *data, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_U64, name)) {
 		if (!inbounds(e, sizeof(u64)))
-			return 0;
+			goto fail;
 		if (data)
 			*data = le64_to_cpu(get_unaligned((__le64 *) e->pos));
 		e->pos += sizeof(u64);
 		return 1;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static size_t unpack_array(struct aa_ext *e, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_ARRAY, name)) {
 		int size;
 		if (!inbounds(e, sizeof(u16)))
-			return 0;
+			goto fail;
 		size = (int)le16_to_cpu(get_unaligned((__le16 *) e->pos));
 		e->pos += sizeof(u16);
 		return size;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static size_t unpack_blob(struct aa_ext *e, char **blob, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_BLOB, name)) {
 		u32 size;
 		if (!inbounds(e, sizeof(u32)))
-			return 0;
+			goto fail;
 		size = le32_to_cpu(get_unaligned((__le32 *) e->pos));
 		e->pos += sizeof(u32);
 		if (inbounds(e, (size_t) size)) {
@@ -345,6 +367,9 @@ static size_t unpack_blob(struct aa_ext *e, char **blob, const char *name)
 			return size;
 		}
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
@@ -361,9 +386,10 @@ static int unpack_str(struct aa_ext *e, const char **string, const char *name)
 			if (src_str[size - 1] != 0)
 				goto fail;
 			*string = src_str;
+
+			return size;
 		}
 	}
-	return size;
 
 fail:
 	e->pos = pos;
-- 
2.20.1



