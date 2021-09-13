Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67246408D4D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhIMNY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240680AbhIMNXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B18461213;
        Mon, 13 Sep 2021 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539280;
        bh=/Q+nGGbuRQCEf4nJ+zVUPSAiTbJskpr6+hRJit8n4qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rA+CVFi2F14R8LOfCf1DY2s4IS0NL0zhaYcAAuFPI04Hxr/gqCI8F+9+ntMIYRFHu
         2vXbjFjA2jbc4SNpFY/yj9UPRV1nkTYJ1AI5kkzOQsp6p6c4affDsnejvSZTl7FUuA
         ZhwJvs4Dj6k0xBIbc5+vzd85ZU8CsElWljOuYsg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Baker <len.baker@gmx.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/144] CIFS: Fix a potencially linear read overflow
Date:   Mon, 13 Sep 2021 15:14:51 +0200
Message-Id: <20210913131051.619674851@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Baker <len.baker@gmx.com>

[ Upstream commit f980d055a0f858d73d9467bb0b570721bbfcdfb8 ]

strlcpy() reads the entire source buffer first. This read may exceed the
destination size limit. This is both inefficient and can lead to linear
read overflows if a source string is not NUL-terminated.

Also, the strnlen() call does not avoid the read overflow in the strlcpy
function when a not NUL-terminated string is passed.

So, replace this block by a call to kstrndup() that avoids this type of
overflow and does the same.

Fixes: 066ce6899484d ("cifs: rename cifs_strlcpy_to_host and make it use new functions")
Signed-off-by: Len Baker <len.baker@gmx.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_unicode.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9bd03a231032..171ad8b42107 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -358,14 +358,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
 		if (!dst)
 			return NULL;
 		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
-			       NO_MAP_UNI_RSVD);
+				NO_MAP_UNI_RSVD);
 	} else {
-		len = strnlen(src, maxlen);
-		len++;
-		dst = kmalloc(len, GFP_KERNEL);
-		if (!dst)
-			return NULL;
-		strlcpy(dst, src, len);
+		dst = kstrndup(src, maxlen, GFP_KERNEL);
 	}
 
 	return dst;
-- 
2.30.2



