Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE243CA86F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhGOTBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241332AbhGOS6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 747C0613C4;
        Thu, 15 Jul 2021 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375356;
        bh=Rq6Vllx5aizCaYRvGFri4AYkM3uXqJdalDaJzcbLmwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gwth65YQ8yxzPA51s9qu+nlm/z8X5FQMn9OrriEA3a/gJ25bSIOOw6MIfEQUk6c4
         Dhl5bHlFchLZkYTn2C6uaSM2vaEIW6gJVx2tMBkzRQAeNC3QeVo1gyklIQ1sHMsvSt
         nZb7/qzzC7KmHnZ25Tsl5WbuSv84MrgNjTJgSN9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 051/242] drm/amd/display: Avoid HDCP over-read and corruption
Date:   Thu, 15 Jul 2021 20:36:53 +0200
Message-Id: <20210715182601.283161448@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 06888d571b513cbfc0b41949948def6cb81021b2 ]

Instead of reading the desired 5 bytes of the actual target field,
the code was reading 8. This could result in a corrupted value if the
trailing 3 bytes were non-zero, so instead use an appropriately sized
and zero-initialized bounce buffer, and read only 5 bytes before casting
to u64.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
index 73ca49f05bd3..eb56526ec32c 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
@@ -29,8 +29,10 @@ static inline enum mod_hdcp_status validate_bksv(struct mod_hdcp *hdcp)
 {
 	uint64_t n = 0;
 	uint8_t count = 0;
+	u8 bksv[sizeof(n)] = { };
 
-	memcpy(&n, hdcp->auth.msg.hdcp1.bksv, sizeof(uint64_t));
+	memcpy(bksv, hdcp->auth.msg.hdcp1.bksv, sizeof(hdcp->auth.msg.hdcp1.bksv));
+	n = *(uint64_t *)bksv;
 
 	while (n) {
 		count++;
-- 
2.30.2



