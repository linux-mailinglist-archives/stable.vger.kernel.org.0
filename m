Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B651B38A5D7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhETKUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhETKR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C48B613DA;
        Thu, 20 May 2021 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503985;
        bh=qbbmotqRcQsqZb8LKliq760hLm0WV5WZAvv/LQ2y9qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Am5QtegRppxPdM8O57aw2vtWYjOswR9I1sm6FOnw+kKQhuei78sC0e86m+RV8aO9B
         Iy7PlQ95iv80ctRLXzsCOLbz+aRp1cFibVZs03QIC4ra/rPyNrjoJtZgIze51Ruz7+
         m3jJM0AdcbK1HtdXcojgb4YBwuHgSotKrh7tZqts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/323] intel_th: Consistency and off-by-one fix
Date:   Thu, 20 May 2021 11:18:54 +0200
Message-Id: <20210520092121.547462229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

[ Upstream commit 18ffbc47d45a1489b664dd68fb3a7610a6e1dea3 ]

Consistently use "< ... +1" in for loops.

Fix of-by-one in for_each_set_bit().

Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/lkml/20190724095841.GA6952@amd/
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210414171251.14672-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/gth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index 2a3ae9006c58..79473ba48d0c 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -485,7 +485,7 @@ static void intel_th_gth_disable(struct intel_th_device *thdev,
 	output->active = false;
 
 	for_each_set_bit(master, gth->output[output->port].master,
-			 TH_CONFIGURABLE_MASTERS) {
+			 TH_CONFIGURABLE_MASTERS + 1) {
 		gth_master_set(gth, master, -1);
 	}
 	spin_unlock(&gth->gth_lock);
@@ -624,7 +624,7 @@ static void intel_th_gth_unassign(struct intel_th_device *thdev,
 	othdev->output.port = -1;
 	othdev->output.active = false;
 	gth->output[port].output = NULL;
-	for (master = 0; master <= TH_CONFIGURABLE_MASTERS; master++)
+	for (master = 0; master < TH_CONFIGURABLE_MASTERS + 1; master++)
 		if (gth->master[master] == port)
 			gth->master[master] = -1;
 	spin_unlock(&gth->gth_lock);
-- 
2.30.2



