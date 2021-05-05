Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6F373FE6
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhEEQcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234147AbhEEQcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45896613C0;
        Wed,  5 May 2021 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232294;
        bh=kYJP+xr+eioEkGpA7YJ4hGDOQL0z8iCLVBI/NZOrfGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlK5ka4sjFgu1t5nYJG1kB1ZuOVqIH5bw2EUvoS2RrI/5DroYxir5J5eB6jTSzEB0
         7MniHqesZ9gng+uqaBkrb8YgcnDQ4yuQAJAYrwUDRCiiTErNpAY2MP9C3vX2YpBot/
         +v9/YzhgOZTPXiSZya6sOagd8ELhFjdBZKDyLlE3HuUWI7FMxqCuk30B/hWlb2kYzB
         IJ1rPFXVNewpo2iV9H6wmTcSI2LGHY/bUo+CBOm+4kmbhuoMTORyq2/usVLgS4cHNf
         o2Od89psiJvRFUxmpdA+9bkaT8Ar12MI9ulPjN4moK7o+ebUyOaa7EbN0yvvhkCpFU
         GSrixxQAXHRzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 007/116] fs: dlm: change allocation limits
Date:   Wed,  5 May 2021 12:29:35 -0400
Message-Id: <20210505163125.3460440-7-sashal@kernel.org>
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
index c438ce0ac115..39d6418f6e89 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1374,9 +1374,11 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
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

