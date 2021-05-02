Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33123370BEF
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhEBOEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232418AbhEBOEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7E56102A;
        Sun,  2 May 2021 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964228;
        bh=JGsMDWyk27WjKby7HS2mvodyeAGC+CYxgjPT+Wz668U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIgnKbI6oINSETVgo1Hw2EWNTPskKJU0G0QyoTrl9/f9y79s4vrDhmuBRU1JB7NoB
         gT5qXl/JFQ+GWhE0hDcXn/tWCXFSGywgLlPgO4XKIIJ6zXafmfbjsuP1MX6RDOmZXR
         yR7JNJK30eGvMYDIIAQKZDcLHyjgvQedwB295ur4skS+ZGZJR8CULwv2Xekjzv7bko
         Ro3woOjUwtgqd1yBnl1NWpNCEb2WADnFvopvOEqBJdrt6t4TQQDY2ow+hgaRerQcGt
         9Q/xQSRpsHGjpqSArRpOiXcdZME3xUsKO3NxjRfwGYsXv3fB1pQdWb+dNirwNKT3XB
         Nh215KuWDw0xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     karthik alapati <mail@karthek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.11 02/70] staging: wimax/i2400m: fix byte-order issue
Date:   Sun,  2 May 2021 10:02:36 -0400
Message-Id: <20210502140344.2719040-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140344.2719040-1-sashal@kernel.org>
References: <20210502140344.2719040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: karthik alapati <mail@karthek.com>

[ Upstream commit 0c37baae130df39b19979bba88bde2ee70a33355 ]

fix sparse byte-order warnings by converting host byte-order
type to __le16 byte-order types before assigning to hdr.length

Signed-off-by: karthik alapati <mail@karthek.com>
Link: https://lore.kernel.org/r/0ae5c5c4c646506d8be871e7be5705542671a1d5.1613921277.git.mail@karthek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wimax/i2400m/op-rfkill.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wimax/i2400m/op-rfkill.c b/drivers/staging/wimax/i2400m/op-rfkill.c
index fbddf2e18c14..44698a1aae87 100644
--- a/drivers/staging/wimax/i2400m/op-rfkill.c
+++ b/drivers/staging/wimax/i2400m/op-rfkill.c
@@ -86,7 +86,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
 	if (cmd == NULL)
 		goto error_alloc;
 	cmd->hdr.type = cpu_to_le16(I2400M_MT_CMD_RF_CONTROL);
-	cmd->hdr.length = sizeof(cmd->sw_rf);
+	cmd->hdr.length = cpu_to_le16(sizeof(cmd->sw_rf));
 	cmd->hdr.version = cpu_to_le16(I2400M_L3L4_VERSION);
 	cmd->sw_rf.hdr.type = cpu_to_le16(I2400M_TLV_RF_OPERATION);
 	cmd->sw_rf.hdr.length = cpu_to_le16(sizeof(cmd->sw_rf.status));
-- 
2.30.2

