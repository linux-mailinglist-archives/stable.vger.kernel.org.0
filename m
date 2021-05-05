Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC7374312
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhEEQvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236123AbhEEQrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE3161439;
        Wed,  5 May 2021 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232615;
        bh=zD/XlO3nFglcr4ayUhe59PHYI1gbpAn+M8Dg02aSF6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6r/wGQnjvI9sFgmcitjtsrf6j8Cz69l+WZCIsMfbGUSNUwu49c/FtNuGzHriR7ri
         +KO/UHP2yp8+If9s3T1pvzVT+xQv/ckhOFTeI2GAO18qnfPNsbF/TjAeJq7i67IpuY
         sL1rmycC1iWPyeDnCaGquoQkT97rNn1HhsUhp0UxvRKY4Nf93ztNElwREVYzlJxLXw
         FHGJWEtDOBwvHW10tkqxfRJN2znP41iJ143OqlBuFGOf3+21LhVJlRdujaiaDnkgrw
         DaAs61BHy9BChXwnuqwg//x78/817JNmP57ZI5paB+uoAqfXaZliCl15x/0vAshsLc
         /kemQ3bZnto1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 04/85] fs: dlm: check on minimum msglen size
Date:   Wed,  5 May 2021 12:35:27 -0400
Message-Id: <20210505163648.3462507-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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

