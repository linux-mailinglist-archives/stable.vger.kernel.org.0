Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2367C14B683
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgA1OFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbgA1OFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D373724688;
        Tue, 28 Jan 2020 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220335;
        bh=p1bznxppQ8v2ql/W4sqG7SE5ypuX4taSUTHF6+WPVK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNHqneGyX50fNqhA5lDbTLwMcJFiKrdnySG2A7WcW3kyrWTsD4KCNke9p8X9msE0l
         3qeIlWl/2ipdS1GDF/Km3YdlMEeZ3p45cnaIK2TeVCCtzGIFr5SrVgw6N8K0iI6i6a
         7RbSu5LrBb0bLA0Yvp+er8XM2qZFuaRCfuGW0dFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 086/104] readdir: be more conservative with directory entry names
Date:   Tue, 28 Jan 2020 15:00:47 +0100
Message-Id: <20200128135829.029117938@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2c6b7bcd747201441923a0d3062577a8d1fbd8f8 upstream.

Commit 8a23eb804ca4 ("Make filldir[64]() verify the directory entry
filename is valid") added some minimal validity checks on the directory
entries passed to filldir[64]().  But they really were pretty minimal.

This fleshes out at least the name length check: we used to disallow
zero-length names, but really, negative lengths or oevr-long names
aren't ok either.  Both could happen if there is some filesystem
corruption going on.

Now, most filesystems tend to use just an "unsigned char" or similar for
the length of a directory entry name, so even with a corrupt filesystem
you should never see anything odd like that.  But since we then use the
name length to create the directory entry record length, let's make sure
it actually is half-way sensible.

Note how POSIX states that the size of a path component is limited by
NAME_MAX, but we actually use PATH_MAX for the check here.  That's
because while NAME_MAX is generally the correct maximum name length
(it's 255, for the same old "name length is usually just a byte on
disk"), there's nothing in the VFS layer that really cares.

So the real limitation at a VFS layer is the total pathname length you
can pass as a filename: PATH_MAX.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/readdir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -102,10 +102,14 @@ EXPORT_SYMBOL(iterate_dir);
  * filename length, and the above "soft error" worry means
  * that it's probably better left alone until we have that
  * issue clarified.
+ *
+ * Note the PATH_MAX check - it's arbitrary but the real
+ * kernel limit on a possible path component, not NAME_MAX,
+ * which is the technical standard limit.
  */
 static int verify_dirent_name(const char *name, int len)
 {
-	if (!len)
+	if (len <= 0 || len >= PATH_MAX)
 		return -EIO;
 	if (memchr(name, '/', len))
 		return -EIO;


