Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E14417C4
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhKAJkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233230AbhKAJh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B6E60187;
        Mon,  1 Nov 2021 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758826;
        bh=Id8fWUsxCWOHV6k4CE1usYI6rxkOxb+zQWMlbsryPUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEJnDxRpbGVQ3COi6CWE2nZ3t8yvH38NGRyu8ctt+Mko7NuwPbkdjuAik+kJxn4aS
         iROPs6d+4O15FEY/j6/oXKDX8hhAvnBu10qqw9y677kJ4gHIfiMOaocHOuH4fxZfqY
         xJYrPxXAUgZeobrn+UjmYiDPjpynpjyGRNe4CxS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 68/77] sctp: add vtag check in sctp_sf_violation
Date:   Mon,  1 Nov 2021 10:17:56 +0100
Message-Id: <20211101082525.833757923@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit aa0f697e45286a6b5f0ceca9418acf54b9099d99 ]

sctp_sf_violation() is called when processing HEARTBEAT_ACK chunk
in cookie_wait state, and some other places are also using it.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0cfbf6046bf8..324c0222d9e6 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4549,6 +4549,9 @@ enum sctp_disposition sctp_sf_violation(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.33.0



