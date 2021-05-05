Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A463741E9
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhEEQmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234462AbhEEQj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B61161629;
        Wed,  5 May 2021 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232464;
        bh=kYJP+xr+eioEkGpA7YJ4hGDOQL0z8iCLVBI/NZOrfGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyx+CCReMVd+P+Sj3avvJKOMKjKh5G/1/Q1LTMDHgF3hpi2cG/xsfhWyPSYAR7H2N
         CN1P6bLLD47/86E/bSzxm0V3Ab9O3fRIVkxcPqgVyNhgIZxkhNfcpTlQauMpSVTjua
         Gt9+nEkEGPMjnrPBEXg3vwMG5kh5u1v1K1oAD+Cm2HsLT5V/kQgW2sVaUAiMdAFFKY
         O5/Xut6ikIkAt2OHVCsq7wNnMGZZo1xNrdOR0fJHLYd33uyOL8bNZ4T8wht1ALxP9c
         JuVtiZv8ezYjqk1iBXrxZxyAB2TYT99E82IsODb9cNhlVVeq8ej/EIVUbwpdudo1A3
         Ft5CPLzq1egtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 007/104] fs: dlm: change allocation limits
Date:   Wed,  5 May 2021 12:32:36 -0400
Message-Id: <20210505163413.3461611-7-sashal@kernel.org>
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

