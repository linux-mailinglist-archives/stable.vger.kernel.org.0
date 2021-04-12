Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1E835BCA2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbhDLIoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237596AbhDLIoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF4261244;
        Mon, 12 Apr 2021 08:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217026;
        bh=sB/h/eSQ2458ajgcns8IhhsiKdJecRZ6yQxCkgNJHw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F06B+pKWzSkh5B8i3eExBMvbPdtHxtWr3ARiQUq92EnNfNTLk02/AjzCutXFPY+QD
         Kk3UL2ehlPALvVs6jEPNOP+CjzBH5+vBDJlgLagXYG9IqPmw/MiLdEkfqODtTr8lJE
         e4iexN4FXFpHaTbG0dcXfbykquqF08woGCK3Ppgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/66] soc/fsl: qbman: fix conflicting alignment attributes
Date:   Mon, 12 Apr 2021 10:40:49 +0200
Message-Id: <20210412083959.512517999@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 040f31196e8b2609613f399793b9225271b79471 ]

When building with W=1, gcc points out that the __packed attribute
on struct qm_eqcr_entry conflicts with the 8-byte alignment
attribute on struct qm_fd inside it:

drivers/soc/fsl/qbman/qman.c:189:1: error: alignment 1 of 'struct qm_eqcr_entry' is less than 8 [-Werror=packed-not-aligned]

I assume that the alignment attribute is the correct one, and
that qm_eqcr_entry cannot actually be unaligned in memory,
so add the same alignment on the outer struct.

Fixes: c535e923bb97 ("soc/fsl: Introduce DPAA 1.x QMan device driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210323131530.2619900-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/qman.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index a4ac6073c555..d7bf456fd10e 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -184,7 +184,7 @@ struct qm_eqcr_entry {
 	__be32 tag;
 	struct qm_fd fd;
 	u8 __reserved3[32];
-} __packed;
+} __packed __aligned(8);
 #define QM_EQCR_VERB_VBIT		0x80
 #define QM_EQCR_VERB_CMD_MASK		0x61	/* but only one value; */
 #define QM_EQCR_VERB_CMD_ENQUEUE	0x01
-- 
2.30.2



