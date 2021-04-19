Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425F5364279
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbhDSNJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239522AbhDSNJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A85A06127C;
        Mon, 19 Apr 2021 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837718;
        bh=CK+Bboxk461LlWw96ygFTIRyGwfcpkqmJqiQk8MCLO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J58x7K4/Snkqvjgut/SWOV934b0ZJQFBXQk/Fuz67Z6Ie3/PNwoNbfdjXU5S7I4cX
         tJnIhzHrwbAgaYqmDkEhLmGCDH3aWomAnh3STgPCi4vZ6yJUPhSygRKRSQOhtzViGi
         o+d01wMAzJFco5dty36XJynfAhbveXhsE6+a7xeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 008/122] dmaengine: idxd: fix delta_rec and crc size field for completion record
Date:   Mon, 19 Apr 2021 15:04:48 +0200
Message-Id: <20210419130530.453457308@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 4ac823e9cd85f66da274c951d21bf9f6b714b729 ]

The delta_rec_size and crc_val in the completion record should
be 32bits and not 16bits.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Reported-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161645618572.2003490.14466173451736323035.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/idxd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 236d437947bc..e33997b4d750 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -247,8 +247,8 @@ struct dsa_completion_record {
 			uint32_t	rsvd2:8;
 		};
 
-		uint16_t	delta_rec_size;
-		uint16_t	crc_val;
+		uint32_t	delta_rec_size;
+		uint32_t	crc_val;
 
 		/* DIF check & strip */
 		struct {
-- 
2.30.2



