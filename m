Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78973741EC
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhEEQmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234312AbhEEQkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:40:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCFEC61613;
        Wed,  5 May 2021 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232465;
        bh=zD/XlO3nFglcr4ayUhe59PHYI1gbpAn+M8Dg02aSF6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBiHK2JCK6a0mvs0OmoISK7oAEvdsYBuSQpLQ1hejQUs8jzQka5jsSoTkb5SnRRm5
         6TTxeyUEEyj5JKrhRfpnj3V4vwX0G+S/StcnEpruFBorHcP0kGYl4R27GeMttIn5Kw
         Y/1NWxZPa/fcZGfOr2QEeQim16OgLmnV619KpubzZrdQVUd/y0vwTo8Gf8etYfqqyC
         w55xYSMoqrwflgfV/I6R9LYQuRVghUf0nmKrFkSBT3beKHmIe3IhmzRDK2PFkGh6wG
         M60l9ixH5BEZb2BvZPNTaCAhA27Bkpxj3jOptOAQslk4kZl+3XVl9RXODC8VXFRLvh
         L79K0zbEAmw1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 008/104] fs: dlm: check on minimum msglen size
Date:   Wed,  5 May 2021 12:32:37 -0400
Message-Id: <20210505163413.3461611-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

