Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADE441714
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhKAJc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232927AbhKAJa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23FE60C41;
        Mon,  1 Nov 2021 09:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758637;
        bh=LK6mRyKBKRLg7955qJTFbgduwjPT32d9UvAbFbuSBts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sis0NMHx7JQO6E5OLxr/yVA6hKBiT83ZC7P/mLTmYHtU5GSbK7P/u6+AgQZdEAT8z
         KOAc7S5M3lQIENiFYuFJmIB6eud7cBQGXVgwehHU2i1jUa0GyeZjTOIajYiRUg/jxj
         NnviJd9ktVUcz5bM7andqxdHFPpFgjbwQ+3wGahI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/51] sctp: add vtag check in sctp_sf_ootb
Date:   Mon,  1 Nov 2021 10:17:50 +0100
Message-Id: <20211101082511.330475646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 9d02831e517aa36ee6bdb453a0eb47bd49923fe3 ]

sctp_sf_ootb() is called when processing DATA chunk in closed state,
and many other places are also using it.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

When fails to verify the vtag from the chunk, this patch sets asoc
to NULL, so that the abort will be made with the vtag from the
received chunk later.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 877420868a42..7c6dcbc8e98b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3568,6 +3568,9 @@ enum sctp_disposition sctp_sf_ootb(struct net *net,
 
 	SCTP_INC_STATS(net, SCTP_MIB_OUTOFBLUES);
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		asoc = NULL;
+
 	ch = (struct sctp_chunkhdr *)chunk->chunk_hdr;
 	do {
 		/* Report violation if the chunk is less then minimal */
-- 
2.33.0



