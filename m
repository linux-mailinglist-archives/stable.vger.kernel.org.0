Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9987353185D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbiEWRjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbiEWRe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A47CDC6;
        Mon, 23 May 2022 10:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46AA2608C0;
        Mon, 23 May 2022 17:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46740C385A9;
        Mon, 23 May 2022 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326889;
        bh=W89CsubPW/Em66wY0PHx9GzSKhev0KIhivQtzaBnt+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1EeB3GHF9ynaZs87rOC+Hd02/y6VqF9yVKrfWRBGQgMN6NBWrVdG5daldBwhz9xV
         iqTn746obFPFDonjORKR1CU+VtVi+AD6NZ+Tvf+UxtcIVe/feBAzqeh/r5jLaZeDR9
         S7txDlDg53rf5vAndDg9qpkWDbNnBiijEeffvS2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 089/158] ptp: ocp: have adjtime handle negative delta_ns correctly
Date:   Mon, 23 May 2022 19:04:06 +0200
Message-Id: <20220523165845.891391295@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit da2172a9bfec858ceeb0271b9d444378490398c8 ]

delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
as an u64.  Also, it turns out that timespec64_add_ns() only handles
positive values, so perform the math with set_normalized_timespec().

Fixes: 90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")
Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
Link: https://lore.kernel.org/r/20220513225231.1412-1-jonathan.lemon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 17ad5f0d13b2..6585789ed695 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -625,7 +625,7 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 }
 
 static void
-ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
 {
 	struct timespec64 ts;
 	unsigned long flags;
@@ -634,7 +634,8 @@ ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
 	spin_lock_irqsave(&bp->lock, flags);
 	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
 	if (likely(!err)) {
-		timespec64_add_ns(&ts, delta_ns);
+		set_normalized_timespec64(&ts, ts.tv_sec,
+					  ts.tv_nsec + delta_ns);
 		__ptp_ocp_settime_locked(bp, &ts);
 	}
 	spin_unlock_irqrestore(&bp->lock, flags);
-- 
2.35.1



