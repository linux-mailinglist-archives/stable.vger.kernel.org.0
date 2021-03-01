Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF62328753
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhCARXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232262AbhCAROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5C465036;
        Mon,  1 Mar 2021 16:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617115;
        bh=Xh9cn6RjhCyZg3GvGnEY0eZq+WmufLNF3FJz8+Gi1gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiUR986ixRvsbkycDo5QkEY4tOjVlMCfZRNwzVTr+O/matY+vlnuGJhxgSnnwDj3G
         kC8f4oxsBk+M5y43nc+HW81FJDhjQDPUg9TCyN8/bORUd2AKsZy5aJ1oRuCWxMLn7o
         xGT4TJCTeYWXoOrqEts9zIjHfgqSK+v+QtuMM3O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Matteo Croce <mcroce@microsoft.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 207/247] pstore: Fix typo in compression option name
Date:   Mon,  1 Mar 2021 17:13:47 +0100
Message-Id: <20210301161041.806067010@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

commit 19d8e9149c27b689c6224f5c84b96a159342195a upstream.

Both pstore_compress() and decompress_record() use a mistyped config
option name ("PSTORE_COMPRESSION" instead of "PSTORE_COMPRESS"). As
a result compression and decompression of pstore records was always
disabled.

Use the correct config option name.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Fixes: fd49e03280e5 ("pstore: Fix linking when crypto API disabled")
Acked-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -250,7 +250,7 @@ static int pstore_compress(const void *i
 {
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESSION))
+	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESS))
 		return -EINVAL;
 
 	ret = crypto_comp_compress(tfm, in, inlen, out, &outlen);
@@ -650,7 +650,7 @@ static void decompress_record(struct pst
 	int unzipped_len;
 	char *decompressed;
 
-	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESSION) || !record->compressed)
+	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESS) || !record->compressed)
 		return;
 
 	/* Only PSTORE_TYPE_DMESG support compression. */


