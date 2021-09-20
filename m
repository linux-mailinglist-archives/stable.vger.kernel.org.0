Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53844411A9C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243448AbhITQut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhITQuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AC3361262;
        Mon, 20 Sep 2021 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156513;
        bh=YFSk/PRbPNJQVhTmldNC5pNCP0IcDx+QfuxJ2U5SAaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsDNWuvspuzybNvCBiuw83SPgfUiAs1L2AI9M8NbiDs0xC9r4PdEzGsJuMco2/hNP
         AoNqCq4Ncy2Rj+PGJlfMAOEToDhbyK9bVKoluW0wnFoxydU/l1fUXJkQWjGj7mx9tN
         66wHVyIxn/0sRL9kpZ7QowLts49wIbiHXolRSep0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Baker <len.baker@gmx.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 062/133] CIFS: Fix a potencially linear read overflow
Date:   Mon, 20 Sep 2021 18:42:20 +0200
Message-Id: <20210920163914.679574667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
index 942874257a09..e5e780145728 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -367,14 +367,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
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



