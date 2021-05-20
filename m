Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6134E38A821
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbhETKqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238227AbhETKok (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C225E61623;
        Thu, 20 May 2021 09:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504644;
        bh=i6nxWaGnI13Ya4iWXKJbLda0atge26fqRNEacbktChY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM6dCQy0gdybXwTijmTHpQWCEkRictNEyhu5xSIf8YoUhncDn9tI0PC5tIWKFQf/1
         0fbW3ez3jX0REi0f1+yX57mTK5M2DZ3y2qQobKt1xgg+qtgzrzi1MRdmWks/XqaWJr
         s8gACCvhi4c6zARG+vUKhhOgJNM3QZCVuYQj/6Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, karthik alapati <mail@karthek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 016/240] staging: wimax/i2400m: fix byte-order issue
Date:   Thu, 20 May 2021 11:20:08 +0200
Message-Id: <20210520092109.165281731@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/net/wimax/i2400m/op-rfkill.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/net/wimax/i2400m/op-rfkill.c
index dc6fe93ce71f..e8473047b2d1 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -101,7 +101,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
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



