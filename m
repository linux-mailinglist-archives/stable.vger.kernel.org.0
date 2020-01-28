Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48C14B61B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgA1OC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbgA1OC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0608524685;
        Tue, 28 Jan 2020 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220146;
        bh=uGwb690XcRRYmpaqN7R+SY+vxZZ7BfejGQQVQBgtTfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oydVqWlBEfGwInEifuzETK0OFPCzbSy7SaCmco6kK4ME/92ZGrXROCDoUvN5qL+43
         9Rfh2FY6loUUUEB7VtYLLDxxkh8GgSIjQqwkOq283ih/qNbI4PBZacKKsnppfkYQku
         XLtDk4ZIYsN+UZxGqJCJfd6MSblA1VYIDiSmJBpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b904ba7c947a37b4b291@syzkaller.appspotmail.com,
        stable@kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 034/104] afs: Fix characters allowed into cell names
Date:   Tue, 28 Jan 2020 14:59:55 +0100
Message-Id: <20200128135822.012551775@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit a45ea48e2bcd92c1f678b794f488ca0bda9835b8 upstream.

The afs filesystem needs to prohibit certain characters from cell names,
such as '/', as these are used to form filenames in procfs, leading to
the following warning being generated:

	WARNING: CPU: 0 PID: 3489 at fs/proc/generic.c:178

Fix afs_alloc_cell() to disallow nonprintable characters, '/', '@' and
names that begin with a dot.

Remove the check for "@cell" as that is then redundant.

This can be tested by running:

	echo add foo/.bar 1.2.3.4 >/proc/fs/afs/cells

Note that we will also need to deal with:

 - Names ending in ".invalid" shouldn't be passed to the DNS.

 - Names that contain non-valid domainname chars shouldn't be passed to
   the DNS.

 - DNS replies that say "your-dns-needs-immediate-attention.<gTLD>" and
   replies containing A records that say 127.0.53.53 should be
   considered invalid.
   [https://www.icann.org/en/system/files/files/name-collision-mitigation-01aug14-en.pdf]

but these need to be dealt with by the kafs-client DNS program rather
than the kernel.

Reported-by: syzbot+b904ba7c947a37b4b291@syzkaller.appspotmail.com
Cc: stable@kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/cell.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -134,8 +134,17 @@ static struct afs_cell *afs_alloc_cell(s
 		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
 	}
-	if (namelen == 5 && memcmp(name, "@cell", 5) == 0)
+
+	/* Prohibit cell names that contain unprintable chars, '/' and '@' or
+	 * that begin with a dot.  This also precludes "@cell".
+	 */
+	if (name[0] == '.')
 		return ERR_PTR(-EINVAL);
+	for (i = 0; i < namelen; i++) {
+		char ch = name[i];
+		if (!isprint(ch) || ch == '/' || ch == '@')
+			return ERR_PTR(-EINVAL);
+	}
 
 	_enter("%*.*s,%s", namelen, namelen, name, addresses);
 


