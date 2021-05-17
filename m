Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F582382E61
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbhEQOGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237713AbhEQOG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2C461350;
        Mon, 17 May 2021 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260299;
        bh=zD/XlO3nFglcr4ayUhe59PHYI1gbpAn+M8Dg02aSF6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwyooZdxLxPT0Mh3H70isO0RdKn0djfIFHkI1fL7pXkWb+mNVI+Ts/Ox2Cj7HPt2O
         gQH+zjfGbshE6nCgXTNdn/7nnYWoIQMi6WkErHvaT5hgfrv49imjaHC/aetXC9niEB
         saSuFcGoAGskZWxsTLCpAnpdgm4k5lAbEdo3xHVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 019/363] fs: dlm: check on minimum msglen size
Date:   Mon, 17 May 2021 15:58:05 +0200
Message-Id: <20210517140303.236475817@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 710176e8363f269c6ecd73d203973b31ace119d3 ]

This patch adds an additional check for minimum dlm header size which is
an invalid dlm message and signals a broken stream. A msglen field cannot
be less than the dlm header size because the field is inclusive header
lengths.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index fde3a6afe4be..0bedfa8606a2 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -49,9 +49,10 @@ int dlm_process_incoming_buffer(int nodeid, unsigned char *buf, int len)
 		 * cannot deliver this message to upper layers
 		 */
 		msglen = get_unaligned_le16(&hd->h_length);
-		if (msglen > DEFAULT_BUFFER_SIZE) {
-			log_print("received invalid length header: %u, will abort message parsing",
-				  msglen);
+		if (msglen > DEFAULT_BUFFER_SIZE ||
+		    msglen < sizeof(struct dlm_header)) {
+			log_print("received invalid length header: %u from node %d, will abort message parsing",
+				  msglen, nodeid);
 			return -EBADMSG;
 		}
 
-- 
2.30.2



