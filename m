Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3D3D5DA3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhGZPCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235758AbhGZPCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF1560F37;
        Mon, 26 Jul 2021 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314187;
        bh=4iyJmHIX7DMzBZng0NIVgAwDZxZPFo6127VKEYN3pkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEfP6au12iItH1Yb7Rlzrh50y/pMmW8RMnzsnrf359pl45eLA0943uU7FsQOZNs0A
         QFr9F2a9t+KYWrDH7pNfDcrg4RZyF78vUSFZb95Gow8vQudRJinXy/Z2zyGPB0pmRy
         COm28jygU9Iz+0espi6Io44QTiRmTuXZ4OeMznnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/60] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Mon, 26 Jul 2021 17:38:17 +0200
Message-Id: <20210726153824.978465434@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 05cf8fffcdeb47aef1203c08cbec5224fd3a0e1c ]

The to_ti_syscon_reset_data macro currently only works if the
parameter passed into it is called 'rcdev'.

Fixes a checkpatch --strict issue:

  CHECK: Macro argument reuse 'rcdev' - possible side-effects?
  #53: FILE: drivers/reset/reset-ti-syscon.c:53:
  +#define to_ti_syscon_reset_data(rcdev)	\
  +	container_of(rcdev, struct ti_syscon_reset_data, rcdev)

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-ti-syscon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/reset-ti-syscon.c b/drivers/reset/reset-ti-syscon.c
index 1799fd423901..54ae04333d75 100644
--- a/drivers/reset/reset-ti-syscon.c
+++ b/drivers/reset/reset-ti-syscon.c
@@ -58,8 +58,8 @@ struct ti_syscon_reset_data {
 	unsigned int nr_controls;
 };
 
-#define to_ti_syscon_reset_data(rcdev)	\
-	container_of(rcdev, struct ti_syscon_reset_data, rcdev)
+#define to_ti_syscon_reset_data(_rcdev)	\
+	container_of(_rcdev, struct ti_syscon_reset_data, rcdev)
 
 /**
  * ti_syscon_reset_assert() - assert device reset
-- 
2.30.2



