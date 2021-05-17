Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8671D383132
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbhEQOfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240217AbhEQOcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6698D613F2;
        Mon, 17 May 2021 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260952;
        bh=M5+oJRYsV3pUQaiHvw5PgbCbW1aT7Sa7iR37zhCCqJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGGKwSXKWlkrCi84gEPuzsQVKHXR20118OcpV1jjWWWU4KNqSMvhGuFgWC8dsI2Zr
         h/5ZkK7Rf2ih1szdLOYaD4zgXBpmJL1TF+WjvRYKqjIK7nq7drEizcv5Ty8Ycp+mAq
         kjytUV1jzOq8wY6FIK0dQqM5utD2MzGgWBVeVi8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 018/329] fs: dlm: change allocation limits
Date:   Mon, 17 May 2021 15:58:49 +0200
Message-Id: <20210517140302.672693733@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit c45674fbdda138814ca21138475219c96fa5aa1f ]

While running tcpkill I experienced invalid header length values while
receiving to check that a node doesn't try to send a invalid dlm message
we also check on applications minimum allocation limit. Also use
DEFAULT_BUFFER_SIZE as maximum allocation limit. The define
LOWCOMMS_MAX_TX_BUFFER_LEN is to calculate maximum buffer limits on
application layer, future midcomms layer will subtract their needs from
this define.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 0f7fa23cccf0..f827d0b3962a 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1375,9 +1375,11 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 	struct writequeue_entry *e;
 	int offset = 0;
 
-	if (len > LOWCOMMS_MAX_TX_BUFFER_LEN) {
-		BUILD_BUG_ON(PAGE_SIZE < LOWCOMMS_MAX_TX_BUFFER_LEN);
+	if (len > DEFAULT_BUFFER_SIZE ||
+	    len < sizeof(struct dlm_header)) {
+		BUILD_BUG_ON(PAGE_SIZE < DEFAULT_BUFFER_SIZE);
 		log_print("failed to allocate a buffer of size %d", len);
+		WARN_ON(1);
 		return NULL;
 	}
 
-- 
2.30.2



