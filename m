Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CE373FE8
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEEQce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234148AbhEEQcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536C6613E3;
        Wed,  5 May 2021 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232296;
        bh=zD/XlO3nFglcr4ayUhe59PHYI1gbpAn+M8Dg02aSF6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmtCYzm9ohDGyfIdtndh+agn+IYF00hITMOqx46BtR4ffCbvwkLrOqJbFEbUxjYic
         m7P9CpjkdNsQ7gm7qPR567L7aT0eOD8NncjvvvYMGkc+MnURd+j3a5F5AJB3Gh9yTh
         igD1s77o+qb62i8xFmA/MKra4emlrDS7Tq6sBlSFkPhCLbYF+HQMAjQnFBaL4Ji9jb
         3Fbj295/CgMwpfymztI9EY5r34qanEoHO+h2/zMbPRaSpxTGOFOQi4jrZxXOpgNDVJ
         g920oYyPyAtfmq23qPmfLhcOyk2ITSHiqnIOlvbaf1kPUT9hQFh3was0JTyRGH9yEZ
         cp1MZpxMgkhPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 008/116] fs: dlm: check on minimum msglen size
Date:   Wed,  5 May 2021 12:29:36 -0400
Message-Id: <20210505163125.3460440-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

