Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48032441608
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhKAJVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhKAJVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512BA610CA;
        Mon,  1 Nov 2021 09:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758331;
        bh=TzYbZJm6PuycSa3kbPc1wiutaXxPx3pu7Gv4n2qurJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1ae6UeVY3+1VlEpN9nSYKmbst2lowqWPJuzIuzGb6bePEHA4YXmwl0weWmqHh+Rp
         Ck8TVOmVS8ql29FnvivuBRAFV9IF8xhKJ/t7/2LEo46DthIg61wL3rEqsj2TE8Xwz9
         Ir6cwI249PozDsuh0Hm8Hqf2xsRLS2+pobbeg7TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/17] sctp: add vtag check in sctp_sf_violation
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082444.507136382@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
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
index b83f90bb1a6e..53bb631ec490 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4337,6 +4337,9 @@ sctp_disposition_t sctp_sf_violation(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.33.0



