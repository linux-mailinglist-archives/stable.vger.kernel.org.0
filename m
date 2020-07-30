Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDC5232CE7
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgG3IE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgG3IEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:04:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F7420672;
        Thu, 30 Jul 2020 08:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096294;
        bh=ipcRqVKadOr2wSzvs5irTgQXRdhc2Mh6Demw+mkQXo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1Cl3oJlet+seCQKEjFcm5gOajrgfqHn8Xcq3h9T5IiRq5kfr7vuAV65v/JS6fXRy
         V8c0Egm08gBWjQKNgZ5Hp1zNG6DfGSm56PM4Q2dCMlBhHHLz25P64yV+ho4gM45eJH
         krXj5JncT3L+ANS/7lgXYY9CVvOzczwnF3yPJGpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 15/20] sctp: shrink stream outq when fails to do addstream reconf
Date:   Thu, 30 Jul 2020 10:04:05 +0200
Message-Id: <20200730074421.249394108@linuxfoundation.org>
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

[ Upstream commit 3ecdda3e9ad837cf9cb41b6faa11b1af3a5abc0c ]

When adding a stream with stream reconf, the new stream firstly is in
CLOSED state but new out chunks can still be enqueued. Then once gets
the confirmation from the peer, the state will change to OPEN.

However, if the peer denies, it needs to roll back the stream. But when
doing that, it only sets the stream outcnt back, and the chunks already
in the new stream don't get purged. It caused these chunks can still be
dequeued in sctp_outq_dequeue_data().

As its stream is still in CLOSE, the chunk will be enqueued to the head
again by sctp_outq_head_data(). This chunk will never be sent out, and
the chunks after it can never be dequeued. The assoc will be 'hung' in
a dead loop of sending this chunk.

To fix it, this patch is to purge these chunks already in the new
stream by calling sctp_stream_shrink_out() when failing to do the
addstream reconf.

Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Reconf Response Parameter")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -1044,11 +1044,13 @@ struct sctp_chunk *sctp_process_strreset
 		nums = ntohs(addstrm->number_of_streams);
 		number = stream->outcnt - nums;
 
-		if (result == SCTP_STRRESET_PERFORMED)
+		if (result == SCTP_STRRESET_PERFORMED) {
 			for (i = number; i < stream->outcnt; i++)
 				SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
-		else
+		} else {
+			sctp_stream_shrink_out(stream, number);
 			stream->outcnt = number;
+		}
 
 		*evp = sctp_ulpevent_make_stream_change_event(asoc, flags,
 			0, nums, GFP_ATOMIC);


