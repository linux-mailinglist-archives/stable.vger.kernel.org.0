Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6574211623E
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLHNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59966 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbfLHNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0007dO-AH; Sun, 08 Dec 2019 13:54:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002LQ-P0; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Colin Ian King" <colin.king@canonical.com>
Date:   Sun, 08 Dec 2019 13:52:57 +0000
Message-ID: <lsq.1575813165.252402542@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 13/72] ext4: set error return correctly when
 ext4_htree_store_dirent fails
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 7a14826ede1d714f0bb56de8167c0e519041eeda upstream.

Currently when the call to ext4_htree_store_dirent fails the error return
variable 'ret' is is not being set to the error code and variable count is
instead, hence the error code is not being returned.  Fix this by assigning
ret to the error return code.

Addresses-Coverity: ("Unused value")
Fixes: 8af0f0822797 ("ext4: fix readdir error in the case of inline_data+dir_index")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1404,7 +1404,7 @@ int htree_inlinedir_to_tree(struct file
 		err = ext4_htree_store_dirent(dir_file,
 				   hinfo->hash, hinfo->minor_hash, de);
 		if (err) {
-			count = err;
+			ret = err;
 			goto out;
 		}
 		count++;

