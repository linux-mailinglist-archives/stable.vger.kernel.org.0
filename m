Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4C321650
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhBVMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhBVMRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231CB64E77;
        Mon, 22 Feb 2021 12:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996206;
        bh=ntxbJx00AH2vKTePOuhG5yc/kxfdJJEwgru72dB4CTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqnjp+0K588BvHlZ3dCioZKFChTj5e04mVX3gtgajL3IpSXC1+GcwFI7P9yygb1x+
         75CpfwsCUZULYFTlcPVSrcfPVZ3igoLsexRyE8aDuz1Z90dcvGEM2CPEBlRBGjuIsE
         SbppSbRNdPQhHWP4SnEwIcNByit2G+DtfRRI0QcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        NeilBrown <neilb@suse.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 29/50] net: fix iteration for sctp transport seq_files
Date:   Mon, 22 Feb 2021 13:13:20 +0100
Message-Id: <20210222121025.367711041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
@@ -230,6 +230,12 @@ static void sctp_transport_seq_stop(stru
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
 
@@ -237,6 +243,12 @@ static void *sctp_transport_seq_next(str
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
@@ -292,8 +304,6 @@ static int sctp_assocs_seq_show(struct s
 		sk->sk_rcvbuf);
 	seq_printf(seq, "\n");
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
@@ -369,8 +379,6 @@ static int sctp_remaddr_seq_show(struct
 		seq_printf(seq, "\n");
 	}
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 


