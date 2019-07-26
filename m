Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A229376CA6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbfGZP0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387834AbfGZP0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE0922BF5;
        Fri, 26 Jul 2019 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154768;
        bh=tp8Iagt+Ausx74B2p9vp97XiN5fd8WInryLepiW6ebE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOhFVmQo/N2zLOtvIxvbmVcXeHMnxqcyJGgYBbdXDnxgAg6ABKqUBva/I9R8bEq9w
         +XHJK0/W6M6+7uC5zgEMQ8x5Kmgg37ErGj3tpnnwpllyTNgsbw7mVO2EF+zkCXmvGj
         J3G0doTAk8g9xVXexwsVj80LyzJciTTYyhHuDl+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 20/66] sctp: fix error handling on stream scheduler initialization
Date:   Fri, 26 Jul 2019 17:24:19 +0200
Message-Id: <20190726152303.969554244@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 4d1415811e492d9a8238f8a92dd0d51612c788e9 ]

It allocates the extended area for outbound streams only on sendmsg
calls, if they are not yet allocated.  When using the priority
stream scheduler, this initialization may imply into a subsequent
allocation, which may fail.  In this case, it was aborting the stream
scheduler initialization but leaving the ->ext pointer (allocated) in
there, thus in a partially initialized state.  On a subsequent call to
sendmsg, it would notice the ->ext pointer in there, and trip on
uninitialized stuff when trying to schedule the data chunk.

The fix is undo the ->ext initialization if the stream scheduler
initialization fails and avoid the partially initialized state.

Although syzkaller bisected this to commit 4ff40b86262b ("sctp: set
chunk transport correctly when it's a new asoc"), this bug was actually
introduced on the commit I marked below.

Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -153,13 +153,20 @@ out:
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
 {
 	struct sctp_stream_out_ext *soute;
+	int ret;
 
 	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
 	if (!soute)
 		return -ENOMEM;
 	SCTP_SO(stream, sid)->ext = soute;
 
-	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
+	if (ret) {
+		kfree(SCTP_SO(stream, sid)->ext);
+		SCTP_SO(stream, sid)->ext = NULL;
+	}
+
+	return ret;
 }
 
 void sctp_stream_free(struct sctp_stream *stream)


