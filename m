Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436013155D7
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhBISYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233236AbhBISV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 13:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EA964EC5;
        Tue,  9 Feb 2021 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612893449;
        bh=R5/Z4YVY+CRp4WOBrSRBK9EYjUyvY/7ttju1PrJy/tg=;
        h=Date:From:To:Subject:From;
        b=yixuL2P+wFSthqbZXG1u9v6tUFmRfZWhSPRF6Bt86jNibq/tf42s6p/DszfCcQrxF
         XqKj75aTk6Q2XRqdrVv7wMM5p2CQRBNTaEW97OdoUMfgkO3eLmnrV6xa3M3r1gu5nP
         k0Q22VpoELecjlHCNouYWRglEBZ29T4B5iVdaatg=
Date:   Tue, 09 Feb 2021 09:57:28 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
        lucien.xin@gmail.com, luto@kernel.org, marcelo.leitner@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.de,
        nhorman@tuxdriver.com, peterz@infradead.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        vyasevich@gmail.com
Subject:  [merged]
 net-fix-iteration-for-sctp-transport-seq_files.patch removed from -mm tree
Message-ID: <20210209175728.8pjvclyN3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: net: fix iteration for sctp transport seq_files
has been removed from the -mm tree.  Its filename was
     net-fix-iteration-for-sctp-transport-seq_files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: net: fix iteration for sctp transport seq_files

The sctp transport seq_file iterators take a reference to the transport in
the ->start and ->next functions and releases the reference in the ->show
function.  The preferred handling for such resources is to release them in
the subsequent ->next or ->stop function call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak references.

So move the sctp_transport_put() call to ->next and ->stop.

Link: https://lkml.kernel.org/r/161248539022.21478.17038123892954492263.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/proc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/sctp/proc.c~net-fix-iteration-for-sctp-transport-seq_files
+++ a/net/sctp/proc.c
@@ -215,6 +215,12 @@ static void sctp_transport_seq_stop(stru
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	sctp_transport_walk_stop(&iter->hti);
 }
 
@@ -222,6 +228,12 @@ static void *sctp_transport_seq_next(str
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	++*pos;
 
 	return sctp_transport_get_next(seq_file_net(seq), &iter->hti);
@@ -277,8 +289,6 @@ static int sctp_assocs_seq_show(struct s
 		sk->sk_rcvbuf);
 	seq_printf(seq, "\n");
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
@@ -354,8 +364,6 @@ static int sctp_remaddr_seq_show(struct
 		seq_printf(seq, "\n");
 	}
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from neilb@suse.de are

seq_file-document-how-per-entry-resources-are-managed.patch
x86-fix-seq_file-iteration-for-pat-memtypec.patch

