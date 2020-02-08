Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C7F1565DD
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBHS3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33974 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbgBHS3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dt-Mw; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CMS-C3; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chengguang Xu" <cgxu519@mykernel.net>, "Jan Kara" <jack@suse.cz>
Date:   Sat, 08 Feb 2020 18:19:49 +0000
Message-ID: <lsq.1581185940.332816048@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 050/148] ext2: check err when partial != NULL
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chengguang Xu <cgxu519@mykernel.net>

commit e705f4b8aa27a59f8933e8f384e9752f052c469c upstream.

Check err when partial == NULL is meaningless because
partial == NULL means getting branch successfully without
error.

Link: https://lore.kernel.org/r/20191105045100.7104-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext2/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -696,11 +696,14 @@ static int ext2_get_blocks(struct inode
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
-			if (err)
-				goto cleanup;
 			clear_buffer_new(bh_result);
 			goto got_it;
 		}
+
+		if (err) {
+			mutex_unlock(&ei->truncate_mutex);
+			goto cleanup;
+		}
 	}
 
 	/*

