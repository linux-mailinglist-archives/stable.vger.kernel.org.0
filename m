Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8012271E0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgGTVpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgGTVhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C70F522BF5;
        Mon, 20 Jul 2020 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281044;
        bh=V5OWNkTgdBCyEL+REiwW5x93P/nnXPsdFaS/dcNSbK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No8mhGNAWIozYCkZNZfAlyZtihUAzmn5Lgl2+8p+FttA1HaaHwjfOXb+WLTY/T88t
         PG5hZMyxcNDqSK/TNRCPJCxAYyt0rZPneGZNAypoJl71T4u0QBJoCn9QNnZZYPZbma
         FMMPTZl4/gT6Q2OXqmVi9CxZ+U5nrkuEPCPC/iPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Jiang <dave.jiang@intel.com>,
        Mona Hossain <mona.hossain@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 07/40] dmaengine: idxd: fix hw descriptor fields for delta record
Date:   Mon, 20 Jul 2020 17:36:42 -0400
Message-Id: <20200720213715.406997-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 0b8975bdc0cc5310d48d9bdd871cefebe1f94c99 ]

Fix the hw descriptor fields for delta record in user exported idxd.h
header. Missing the "expected result mask" field.

Reported-by: Mona Hossain <mona.hossain@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/159120526866.65385.536565786678052944.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/idxd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 1f412fbf561bb..e103c1434e4b0 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -110,9 +110,12 @@ struct dsa_hw_desc {
 	uint16_t	rsvd1;
 	union {
 		uint8_t		expected_res;
+		/* create delta record */
 		struct {
 			uint64_t	delta_addr;
 			uint32_t	max_delta_size;
+			uint32_t 	delt_rsvd;
+			uint8_t 	expected_res_mask;
 		};
 		uint32_t	delta_rec_size;
 		uint64_t	dest2;
-- 
2.25.1

