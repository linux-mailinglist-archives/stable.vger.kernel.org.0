Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBAC2692A4
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgINRLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgINNEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:04:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56FAE221E5;
        Mon, 14 Sep 2020 13:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088653;
        bh=L1FWJ3Phjt/pxDhSTC7ZNmaKjoDptfD5Cefa6BmLavA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/oTzkWf9LQq/GBDMOsWY6bIDunEJwRZNeL2HMN0mfORYVoxRVKmeqk+31fRdFmSa
         OrBXxUsZygII65XRNBm3AykSfF0d7gpnRM9gpoIMJnWA8vDxPr+XzLh6iA31fYOL4u
         6WyvmsVg7PRc7t3LNplH4luhbcBOZm8//GzTi3sg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 12/29] interconnect: Show bandwidth for disabled paths as zero in debugfs
Date:   Mon, 14 Sep 2020 09:03:41 -0400
Message-Id: <20200914130358.1804194-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit b1910c6b9983817160e04d4e87b2dc1413c5361a ]

For disabled paths the 'interconnect_summary' in debugfs currently shows
the orginally requested bandwidths. This is confusing, since the bandwidth
requests aren't active. Instead show the bandwidths for disabled
paths/requests as zero.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Link: https://lore.kernel.org/r/20200729104933.1.If8e80e4c0c7ddf99056f6e726e59505ed4e127f3@changeid
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 9e1ab701785c7..0162a9af93237 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -55,12 +55,18 @@ static int icc_summary_show(struct seq_file *s, void *data)
 
 			icc_summary_show_one(s, n);
 			hlist_for_each_entry(r, &n->req_list, req_node) {
+				u32 avg_bw = 0, peak_bw = 0;
+
 				if (!r->dev)
 					continue;
 
+				if (r->enabled) {
+					avg_bw = r->avg_bw;
+					peak_bw = r->peak_bw;
+				}
+
 				seq_printf(s, "  %-27s %12u %12u %12u\n",
-					   dev_name(r->dev), r->tag, r->avg_bw,
-					   r->peak_bw);
+					   dev_name(r->dev), r->tag, avg_bw, peak_bw);
 			}
 		}
 	}
-- 
2.25.1

