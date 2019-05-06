Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5597714F6A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEFOfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbfEFOfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D294420B7C;
        Mon,  6 May 2019 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153306;
        bh=SGIO49HU9nzxxhyzNornMmXmuF4ftIIlr/spORJIoHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoNJ4QZZHFNm3wIBk8ofECOpGlVOpvXhnx4q1qdTqS5dFpcjp/vv2cXvfxcoFdDcN
         T319DoXA+w+CzuOghugEymdK1tlxmBZpJl19SW1ov2sEZUndLheHhpZC8+1Jb8Rt4q
         BP2gjqz/3DpSC1xs0wYfRQ10OKK06DoWESSOonjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 039/122] i40e: fix i40e_ptp_adjtime when given a negative delta
Date:   Mon,  6 May 2019 16:31:37 +0200
Message-Id: <20190506143058.408004932@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b3ccbbce1e455b8454d3935eb9ae0a5f18939e24 ]

Commit 0ac30ce43323 ("i40e: fix up 32 bit timespec references",
2017-07-26) claims to be cleaning up references to 32-bit timespecs.

The actual contents of the commit make no sense, as it converts a call
to timespec64_add into timespec64_add_ns. This would seem ok, if (a) the
change was documented in the commit message, and (b) timespec64_add_ns
supported negative numbers.

timespec64_add_ns doesn't work with signed deltas, because the
implementation is based around iter_div_u64_rem. This change resulted in
a regression where i40e_ptp_adjtime would interpret small negative
adjustments as large positive additions, resulting in incorrect
behavior.

This commit doesn't appear to fix anything, is not well explained, and
introduces a bug, so lets just revert it.

Reverts: 0ac30ce43323 ("i40e: fix up 32 bit timespec references", 2017-07-26)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 5fb4353c742b..31575c0bb884 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -146,12 +146,13 @@ static int i40e_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 static int i40e_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct i40e_pf *pf = container_of(ptp, struct i40e_pf, ptp_caps);
-	struct timespec64 now;
+	struct timespec64 now, then;
 
+	then = ns_to_timespec64(delta);
 	mutex_lock(&pf->tmreg_lock);
 
 	i40e_ptp_read(pf, &now, NULL);
-	timespec64_add_ns(&now, delta);
+	now = timespec64_add(now, then);
 	i40e_ptp_write(pf, (const struct timespec64 *)&now);
 
 	mutex_unlock(&pf->tmreg_lock);
-- 
2.20.1



