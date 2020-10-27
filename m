Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5772529BE67
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812892AbgJ0Qqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801538AbgJ0Pmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FC120657;
        Tue, 27 Oct 2020 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813357;
        bh=Nsuz4rEgQEWFEnjbWZ2T9bMrWhD8ArUyif3hAx0gvd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6s5UKR7ddB765p8sKRW8kbjQH74kBerfcyWO2+efwrIPRNWUtScLmFOZ/ijWdr9K
         0mYT4N7kCUWRllFL+OdduydP9M078hEcMS/xRq7nQQd4citUy9y1WqZnM260ctqxM7
         K/mBHSC07KunWA88oOaJ+gFOvfbQ2G5BWCNmV07A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        kernel test robot <lkp@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 525/757] remoteproc: stm32: Fix pointer assignement
Date:   Tue, 27 Oct 2020 14:52:55 +0100
Message-Id: <20201027135515.109516958@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit cb2d8d5b196c2e96e29343383c8c8d8db68b934e ]

Fix the assignment of the @state pointer - it is obviously wrong.

Acked-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Fixes: 376ffdc04456 ("remoteproc: stm32: Properly set co-processor state when attaching")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200831213758.206690-1-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/stm32_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/stm32_rproc.c b/drivers/remoteproc/stm32_rproc.c
index f4da42fc0eeb1..d2414cc1d90d6 100644
--- a/drivers/remoteproc/stm32_rproc.c
+++ b/drivers/remoteproc/stm32_rproc.c
@@ -685,7 +685,7 @@ static int stm32_rproc_get_m4_status(struct stm32_rproc *ddata,
 		 * We couldn't get the coprocessor's state, assume
 		 * it is not running.
 		 */
-		state = M4_STATE_OFF;
+		*state = M4_STATE_OFF;
 		return 0;
 	}
 
-- 
2.25.1



