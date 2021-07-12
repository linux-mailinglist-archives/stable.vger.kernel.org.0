Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB273C4555
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhGLGZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234944AbhGLGYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9519461130;
        Mon, 12 Jul 2021 06:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070841;
        bh=nFiVBD9s1F0BKiFDeyhGID7OC5rzFoiX0HeTvFie4L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRTGkFItGPI2XkUlpGcp1qX1RpsFoqg5/qz5hPh8eEX1FqVtzNIa/pYfbzMyirVX2
         Q7YWfJzrd4bjOp1OjxJQHjtQVqghs3BFhqd0/TnaImuMjsspm08ZqlVlybXordBOEm
         uwBIcpVqqYSaRp4s6T/QCJZ0+GvcLxBlMqULSTS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/348] random32: Fix implicit truncation warning in prandom_seed_state()
Date:   Mon, 12 Jul 2021 08:08:24 +0200
Message-Id: <20210712060717.358547706@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d327ea15a305024ef0085252fa3657bbb1ce25f5 ]

sparse generates the following warning:

 include/linux/prandom.h:114:45: sparse: sparse: cast truncates bits from
 constant value

This is because the 64-bit seed value is manipulated and then placed in a
u32, causing an implicit cast and truncation. A forced cast to u32 doesn't
prevent this warning, which is reasonable because a typecast doesn't prove
that truncation was expected.

Logical-AND the value with 0xffffffff to make explicit that truncation to
32-bit is intended.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210525122012.6336-3-rf@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/prandom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index cc1e71334e53..e20339c78a84 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -93,7 +93,7 @@ static inline u32 __seed(u32 x, u32 m)
  */
 static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
-	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+	u32 i = ((seed >> 32) ^ (seed << 10) ^ seed) & 0xffffffffUL;
 
 	state->s1 = __seed(i,   2U);
 	state->s2 = __seed(i,   8U);
-- 
2.30.2



