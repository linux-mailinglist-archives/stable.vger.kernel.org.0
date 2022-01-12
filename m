Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BB48C357
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 12:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiALLje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 06:39:34 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:45604 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiALLjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 06:39:33 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B23EB218EA;
        Wed, 12 Jan 2022 11:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641987571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=goAYM6J4lGKNnDQe8IuzdEHLzh77MdnGGq+LTJMPOSAGsaPuoE6zYAOAlNWkqgS/eRanvN
        RXfelNpl01wZM+H6noiRiOpEs/EJ3aKaMj3UpubVl7RPBlS4cuTgvBGNckwbhLEWuSLlv5
        S0ZG/9cPEH3E3BZHtlA+acPCnc2nxsI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641987571;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=tvEPqROvllD5hR5Wag5Ow0e0vh6RA6EVYfu1NlR9ktqFS5lSGUHkcqFSECfgJxYgqM95CO
        fSCbEhnOUPa09MDQ==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A18D0A3B88;
        Wed, 12 Jan 2022 11:39:31 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B32DDA03CF; Wed, 12 Jan 2022 12:39:28 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] bfq: Avoid false marking of bic as stably merged
Date:   Wed, 12 Jan 2022 12:39:19 +0100
Message-Id: <20220112113928.32349-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112113529.6355-1-jack@suse.cz>
References: <20220112113529.6355-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=5U8ovRbTkvkFai3dDsau8hR63c7msoBSWRjO0JL3zkc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh3r3mD9DXHDYFgwsklw51KXLtvtKGVx/PMj1feWCk x+0rFemJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYd695gAKCRCcnaoHP2RA2UK0B/ wN060fsI7A1B4TFD7vfyYcVRfrG4X+pvtbzgEL44Nj4mfxfwVE54ArI9Dyu4BYJgjBOGlpvgBPdFmE 2n6ymysjHfi8JGydPfQ8xlpzZ1yaTVsmSa3ZOMYVgqRM92EwaisFHiuWtvkh4jeZG6BtrghKNPfJrJ qwsAqkzNRlu7Te5Slt5zhVoOiuYKDQDoeq84CcMivAF1WoUHTQ84nlnDbYWdPqVoWBqFAzIb+/F5sB hcQQP6/2CFiIYW3huCWY0pLhi+053p5pjYNi2dB8xILNlYFKgb+V3HUUkYiSRos5/r/VQF6vRQ1JJG mdiuSRoJXWy/Yn3naP4joUOeGiWySj
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bfq_setup_cooperator() can mark bic as stably merged even though it
decides to not merge its bfqqs (when bfq_setup_merge() returns NULL).
Make sure to mark bic as stably merged only if we are really going to
merge bfqqs.

CC: stable@vger.kernel.org
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index fec18118dc30..056399185c2f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2762,9 +2762,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 				struct bfq_queue *new_bfqq =
 					bfq_setup_merge(bfqq, stable_merge_bfqq);
 
-				bic->stably_merged = true;
-				if (new_bfqq && new_bfqq->bic)
-					new_bfqq->bic->stably_merged = true;
+				if (new_bfqq) {
+					bic->stably_merged = true;
+					if (new_bfqq->bic)
+						new_bfqq->bic->stably_merged =
+									true;
+				}
 				return new_bfqq;
 			} else
 				return NULL;
-- 
2.31.1

