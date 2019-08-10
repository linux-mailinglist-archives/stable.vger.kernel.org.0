Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986A488E57
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfHJUyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53824 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726490AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053F-9r; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Yi-QF; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Kara" <jack@suse.cz>,
        "jean-luc malet" <jeanluc.malet@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.39091445@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 016/157] udf: Fix crash on IO error during truncate
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d3ca4651d05c0ff7259d087d8c949bcf3e14fb46 upstream.

When truncate(2) hits IO error when reading indirect extent block the
code just bugs with:

kernel BUG at linux-4.15.0/fs/udf/truncate.c:249!
...

Fix the problem by bailing out cleanly in case of IO error.

Reported-by: jean-luc malet <jeanluc.malet@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/truncate.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -261,6 +261,9 @@ void udf_truncate_extents(struct inode *
 			epos.block = eloc;
 			epos.bh = udf_tread(sb,
 					udf_get_lb_pblock(sb, &eloc, 0));
+			/* Error reading indirect block? */
+			if (!epos.bh)
+				return;
 			if (elen)
 				indirect_ext_len =
 					(elen + sb->s_blocksize - 1) >>

