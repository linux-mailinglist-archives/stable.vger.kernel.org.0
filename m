Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38F122F046
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgG0OXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732027AbgG0OXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A23521883;
        Mon, 27 Jul 2020 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859790;
        bh=V5OWNkTgdBCyEL+REiwW5x93P/nnXPsdFaS/dcNSbK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXEluM4x8UEj1hKv6U6dgo4ZeOewRn28vbcmljWJKQsM8mAI8eiv0mAm5Cl49h+az
         +VrwecYw7Fghmn2MkKXU1u+sCCnDvM244aUBJMvwb47FNmPyvL7KMK54L+84aexK+q
         VNvcV+9aqBbO8w9Iezc/vUBQXQ6m01sPWgOeXQUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mona Hossain <mona.hossain@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/179] dmaengine: idxd: fix hw descriptor fields for delta record
Date:   Mon, 27 Jul 2020 16:04:41 +0200
Message-Id: <20200727134937.814859294@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



