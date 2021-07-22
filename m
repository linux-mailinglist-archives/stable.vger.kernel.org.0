Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D751B3D27A7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhGVPwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhGVPwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445966135A;
        Thu, 22 Jul 2021 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971558;
        bh=wzFNLVPeIlQlLrIQZ3+S8W4G1Mep2IE4KMTCFszJ1gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5esEYljpIy0dOaVssLMgpXDxlZeWrZ1uIP8eWU+gLNzjxHlvRq1OushGkT7YF5xy
         les+Tms+V1/QcFqfxuCtc1dpJhvmZbYmjkOFm7ngVqt3wIFw3in3u+nXzAAosj7Njb
         T75jqy4Q4BKVCY0RWUkGKu85QCxnwfSqV0PnBNcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/71] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Thu, 22 Jul 2021 18:30:47 +0200
Message-Id: <20210722155618.289483591@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
index a2635c21db7f..ecb8873e3a19 100644
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



