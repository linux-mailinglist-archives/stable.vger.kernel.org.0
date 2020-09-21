Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9607E272DCF
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgIUQn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgIUQn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3908D235F9;
        Mon, 21 Sep 2020 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706607;
        bh=L1FWJ3Phjt/pxDhSTC7ZNmaKjoDptfD5Cefa6BmLavA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oylHFbJdFIX0Q8pMqzbzhqfV3ue6sqJWZOrh5HvgG/KNb2Fc5p4qH4dAtukIF37Ti
         k8JEZDcKSzdXR/APWQLHUwTQi/6icjxGBFe22Uwg5o52AjECm3jwXokrsjHf0ISlEV
         U2OILEzhZoG8UC23hmY6Ic2WNky2s2EivTwlWF/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 020/118] interconnect: Show bandwidth for disabled paths as zero in debugfs
Date:   Mon, 21 Sep 2020 18:27:12 +0200
Message-Id: <20200921162037.258229222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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



