Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555234417DD
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhKAJki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233647AbhKAJhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C8161351;
        Mon,  1 Nov 2021 09:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758805;
        bh=RC6JetzLfBNEde2KfJFt1UuHBRjs8PXp+JrE2f97nKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsA+aBiWOCtK11BL+NGWwDdew32Sb/mmPJoqgiIbJMB8XZAbgEpBtHeBGfMBp8pV4
         zkcFjg4WiOQuqkAAmYeobTUFxDh3MeGUovpq56Jv6fmBAtRKnbz/FFEva2W23vmPtX
         Uz9CVFoB48vxKu1e+I8urS0IYytAoLKq2KOkHTDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/77] sctp: use init_tag from inithdr for ABORT chunk
Date:   Mon,  1 Nov 2021 10:17:53 +0100
Message-Id: <20211101082525.252345963@linuxfoundation.org>
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

[ Upstream commit 4f7019c7eb33967eb87766e0e4602b5576873680 ]

Currently Linux SCTP uses the verification tag of the existing SCTP
asoc when failing to process and sending the packet with the ABORT
chunk. This will result in the peer accepting the ABORT chunk and
removing the SCTP asoc. One could exploit this to terminate a SCTP
asoc.

This patch is to fix it by always using the initiate tag of the
received INIT chunk for the ABORT chunk to be sent.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b65bdaa84228..89a86728184d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6248,6 +6248,7 @@ static struct sctp_packet *sctp_ootb_pkt_new(
 		 * yet.
 		 */
 		switch (chunk->chunk_hdr->type) {
+		case SCTP_CID_INIT:
 		case SCTP_CID_INIT_ACK:
 		{
 			struct sctp_initack_chunk *initack;
-- 
2.33.0



