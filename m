Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25BB31BCCB
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBOPfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhBOPdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0DF64EB2;
        Mon, 15 Feb 2021 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403033;
        bh=CqKua+9AC4BBzGT223pySJUvNsv/Q9xQ2IvYXgmVfvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHHhXs2LVd6hSSQJMV8hgLQ3uYyejLdgjtBJtmHwdTSk/QKeoVazvTGWl5lhb7/No
         NSnrqKyf3u2mA4SMl3yGOxPeHrqM6psxLMs/A/L48Pvp4fMRycet/6ML7DSycfu21H
         vh8XyWFFhD4Z7k4DrevI6rQpCoQtYpbxs5Iqjp7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        NeilBrown <neilb@suse.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 53/60] net: fix iteration for sctp transport seq_files
Date:   Mon, 15 Feb 2021 16:27:41 +0100
Message-Id: <20210215152717.077186043@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit af8085f3a4712c57d0dd415ad543bac85780375c upstream.

The sctp transport seq_file iterators take a reference to the transport
in the ->start and ->next functions and releases the reference in the
->show function.  The preferred handling for such resources is to
release them in the subsequent ->next or ->stop function call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak references.

So move the sctp_transport_put() call to ->next and ->stop.

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Reported-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/proc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
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
 


