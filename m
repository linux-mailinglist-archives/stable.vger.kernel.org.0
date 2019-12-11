Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1023911B376
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbfLKPmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbfLKP1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8962173E;
        Wed, 11 Dec 2019 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078058;
        bh=FVo9RzpRNbSQ5+JdfVLkPWd3hzdsy+4GQz+nCCrexhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JV6p8JDJtrRkL9XQ2tts2JxsE5P2wEDwG4+LGKlLKHtMM7jkp0ls13RLKO40BDOMQ
         KJgxLnV/7C4j7yrrqiQTIhb+Lt/wX3k+PPTj5mFvV23M5gRE+6NlaN3BfRDf56TQmb
         s6HE+Qy88Jv+An/jWrrVi526QkYDzNZKoC7hpps0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 4.19 51/79] libnvdimm/btt: fix variable 'rc' set but not used
Date:   Wed, 11 Dec 2019 10:26:15 -0500
Message-Id: <20191211152643.23056-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 4e24e37d5313edca8b4ab86f240c046c731e28d6 ]

drivers/nvdimm/btt.c: In function 'btt_read_pg':
drivers/nvdimm/btt.c:1264:8: warning: variable 'rc' set but not used
[-Wunused-but-set-variable]
    int rc;
        ^~

Add a ratelimited message in case a storm of errors is encountered.

Fixes: d9b83c756953 ("libnvdimm, btt: rework error clearing")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/1572530719-32161-1-git-send-email-cai@lca.pw
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/btt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 0360c015f6580..75ae2c508a044 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1260,11 +1260,11 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
 		if (ret) {
-			int rc;
-
 			/* Media error - set the e_flag */
-			rc = btt_map_write(arena, premap, postmap, 0, 1,
-				NVDIMM_IO_ATOMIC);
+			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
+				dev_warn_ratelimited(to_dev(arena),
+					"Error persistently tracking bad blocks at %#x\n",
+					premap);
 			goto out_rtt;
 		}
 
-- 
2.20.1

