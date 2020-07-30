Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B37232CE8
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgG3IFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729057AbgG3IEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06CB2074B;
        Thu, 30 Jul 2020 08:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096292;
        bh=nYYmCu2mzdlYsCUJMvY9cAUvH+NJHt5B/5k3hEAHv8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWcnoiykWLWF4Fpjm50nWqzZzB5/Wzdza4FcszpeZlEPE+DoryZ9iDddwuLwVzGH9
         LlBP6b/RYVVY0ps6/5RzjMoPvTZ5B4vNF1EHdUyquJP+Xms6OYbQMbNg7lSfFeJdbn
         E2ESyL2JBrAIaDN7Va3GMdaYIV903FHpa7+0Posk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 14/20] sctp: shrink stream outq only when new outcnt < old outcnt
Date:   Thu, 30 Jul 2020 10:04:04 +0200
Message-Id: <20200730074421.201786211@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8f13399db22f909a35735bf8ae2f932e0c8f0e30 ]

It's not necessary to go list_for_each for outq->out_chunk_list
when new outcnt >= old outcnt, as no chunk with higher sid than
new (outcnt - 1) exists in the outqueue.

While at it, also move the list_for_each code in a new function
sctp_stream_shrink_out(), which will be used in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -22,17 +22,11 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
-/* Migrates chunks from stream queues to new stream queues if needed,
- * but not across associations. Also, removes those chunks to streams
- * higher than the new max.
- */
-static void sctp_stream_outq_migrate(struct sctp_stream *stream,
-				     struct sctp_stream *new, __u16 outcnt)
+static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 {
 	struct sctp_association *asoc;
 	struct sctp_chunk *ch, *temp;
 	struct sctp_outq *outq;
-	int i;
 
 	asoc = container_of(stream, struct sctp_association, stream);
 	outq = &asoc->outqueue;
@@ -56,6 +50,19 @@ static void sctp_stream_outq_migrate(str
 
 		sctp_chunk_free(ch);
 	}
+}
+
+/* Migrates chunks from stream queues to new stream queues if needed,
+ * but not across associations. Also, removes those chunks to streams
+ * higher than the new max.
+ */
+static void sctp_stream_outq_migrate(struct sctp_stream *stream,
+				     struct sctp_stream *new, __u16 outcnt)
+{
+	int i;
+
+	if (stream->outcnt > outcnt)
+		sctp_stream_shrink_out(stream, outcnt);
 
 	if (new) {
 		/* Here we actually move the old ext stuff into the new


