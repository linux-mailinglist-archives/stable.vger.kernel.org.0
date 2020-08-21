Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA38724DDBE
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgHURV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgHUQPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E568022B49;
        Fri, 21 Aug 2020 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026553;
        bh=sxeAFQ52ASL5nje3aqcIGZzuZ/bCaSzJFdyZUqp6SKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eS5yNa1HAl+Z/w6IOhEf7mgRFMkhtm5qCxl0LhykN/1Ev/NTNCzJQglPFuve28+D5
         T/YNh8tQItwJzaRocslrEPB1aBOvgwKzVwhWeeKnuX6xmZ5ve4B6BFtZNoFPP25lh5
         5p8LMkq8VAw22uOQaBjG99ucUEzYgKho8knlgjqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 06/61] EDAC/mc: Call edac_inc_ue_error() before panic
Date:   Fri, 21 Aug 2020 12:14:50 -0400
Message-Id: <20200821161545.347622-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit e9ff6636d3f97a764487999754c0bfee9d2c231e ]

By calling edac_inc_ue_error() before panic, we get a correct UE error
count for core dump analysis.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20200610065846.3626-2-zhenzhong.duan@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 75ede27bdf6aa..c1f23c21a4106 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1011,6 +1011,8 @@ static void edac_ue_error(struct edac_raw_error_desc *e)
 			e->other_detail);
 	}
 
+	edac_inc_ue_error(e);
+
 	if (edac_mc_get_panic_on_ue()) {
 		panic("UE %s%son %s (%s page:0x%lx offset:0x%lx grain:%ld%s%s)\n",
 			e->msg,
@@ -1020,8 +1022,6 @@ static void edac_ue_error(struct edac_raw_error_desc *e)
 			*e->other_detail ? " - " : "",
 			e->other_detail);
 	}
-
-	edac_inc_ue_error(e);
 }
 
 static void edac_inc_csrow(struct edac_raw_error_desc *e, int row, int chan)
-- 
2.25.1

