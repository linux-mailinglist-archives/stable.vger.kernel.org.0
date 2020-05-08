Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD71CAB79
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgEHMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729116AbgEHMnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C660C206B8;
        Fri,  8 May 2020 12:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941830;
        bh=ORv7Qy0u/bkXmW6s/tiSk5SObYIvGzfdzSsuQt1zCVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsDNt/g5/ro7JOfbNHLHpd4YktO2IDZDSUmOjaSCWc1MYwe41AudRiGSwa2eAMkHK
         wcaiAnUYe9CFqWzpWKAlof/AybqhzmynEtFkf/5p3vuHpLjhKsesJDlYx0PzJbgYYm
         FJd81XVySXTnD9Y0uDsrRGyAF5WOHiYJWBGJXhsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 149/312] sctp: fix the transports round robin issue when init is retransmitted
Date:   Fri,  8 May 2020 14:32:20 +0200
Message-Id: <20200508123134.940148234@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 39d2adebf137de5f900843f69f5e500932e31047 upstream.

prior to this patch, at the beginning if we have two paths in one assoc,
they may have the same params other than the last_time_heard, it will try
the paths like this:

1st cycle
  try trans1 fail.
  then trans2 is selected.(cause it's last_time_heard is after trans1).

2nd cycle:
  try  trans2 fail
  then trans2 is selected.(cause it's last_time_heard is after trans1).

3rd cycle:
  try  trans2 fail
  then trans2 is selected.(cause it's last_time_heard is after trans1).

....

trans1 will never have change to be selected, which is not what we expect.
we should keeping round robin all the paths if they are just added at the
beginning.

So at first every tranport's last_time_heard should be initialized 0, so
that we ensure they have the same value at the beginning, only by this,
all the transports could get equal chance to be selected.

Then for sctp_trans_elect_best, it should return the trans_next one when
*trans == *trans_next, so that we can try next if it fails,  but now it
always return trans. so we can fix it by exchanging these two params when
we calls sctp_trans_elect_tie().

Fixes: 4c47af4d5eb2 ('net: sctp: rework multihoming retransmission path selection to rfc4960')
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/associola.c |    2 +-
 net/sctp/transport.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1290,7 +1290,7 @@ static struct sctp_transport *sctp_trans
 	if (score_curr > score_best)
 		return curr;
 	else if (score_curr == score_best)
-		return sctp_trans_elect_tie(curr, best);
+		return sctp_trans_elect_tie(best, curr);
 	else
 		return best;
 }
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -72,7 +72,7 @@ static struct sctp_transport *sctp_trans
 	 */
 	peer->rto = msecs_to_jiffies(net->sctp.rto_initial);
 
-	peer->last_time_heard = ktime_get();
+	peer->last_time_heard = ktime_set(0, 0);
 	peer->last_time_ecne_reduced = jiffies;
 
 	peer->param_flags = SPP_HB_DISABLE |


