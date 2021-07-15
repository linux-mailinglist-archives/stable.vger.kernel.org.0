Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54143CAA23
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbhGOTML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243503AbhGOTJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 741FA613F9;
        Thu, 15 Jul 2021 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375951;
        bh=co4ViAOkLJgTbOD/bShjc5Cfzwin0PgwlTQtXi3wqAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoBTs4I5/n52YWc0Zf6tm6DctVQ5YBq2jAQ6d4c1VyyHsrDvLqEgA3/mysh+1lGRk
         0lf8nWWzy7l9SNU95FCfOF0j51RHV7vmYfvloVDoSSZ266KeYhhBUKvV6vxEoR3mdN
         KtADT3kcEmmZYaDIK0FA1G+79a8ImO779Lr7TU6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/266] drm/amd/display: Avoid HDCP over-read and corruption
Date:   Thu, 15 Jul 2021 20:36:57 +0200
Message-Id: <20210715182625.190491995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index 2cbd931363bd..6d26d9c63ab2 100644
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



