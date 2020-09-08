Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD3C261C2E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbgIHTPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgIHQEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D0B23E1D;
        Tue,  8 Sep 2020 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579464;
        bh=0OpwguM5VuIK0HzhVOAJGjUbPJq9mNBmUvNdlbS1eyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eca0E/wwios6s6k+JvvI/LOlhtHhgsOkhR3CBEFLiMDS9KbErUBj0RNfPXOZo9ycR
         cjARc+mPN8a0T3kE80xMFA+MS8bLw5whIGrroikjvHSfiYJLNTO2nAomBOrLJTI+IY
         ylAxdl/y73ot8XkFewgZlwX9iNP+bD8GhRSmK8W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 089/186] MIPS: perf: Fix wrong check condition of Loongson event IDs
Date:   Tue,  8 Sep 2020 17:23:51 +0200
Message-Id: <20200908152245.958909094@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit a231995700c392c0807da95deea231b23fc51a3c ]

According to the user's manual chapter 8.2.1 of Loongson 3A2000 CPU [1]
and 3A3000 CPU [2], we should take some event IDs such as 274, 358, 359
and 360 as valid in the check condition, otherwise they are recognized
as "not supported", fix it.

[1] http://www.loongson.cn/uploadfile/cpu/3A2000/Loongson3A2000_user2.pdf
[2] http://www.loongson.cn/uploadfile/cpu/3A3000/Loongson3A3000_3B3000user2.pdf

Fixes: e9dfbaaeef1c ("MIPS: perf: Add hardware perf events support for new Loongson-3")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/perf_event_mipsxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index efce5defcc5cf..011eb6bbf81a5 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1898,8 +1898,8 @@ static const struct mips_perf_event *mipsxx_pmu_map_raw_event(u64 config)
 				(base_id >= 64 && base_id < 90) ||
 				(base_id >= 128 && base_id < 164) ||
 				(base_id >= 192 && base_id < 200) ||
-				(base_id >= 256 && base_id < 274) ||
-				(base_id >= 320 && base_id < 358) ||
+				(base_id >= 256 && base_id < 275) ||
+				(base_id >= 320 && base_id < 361) ||
 				(base_id >= 384 && base_id < 574))
 				break;
 
-- 
2.25.1



