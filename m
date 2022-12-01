Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2396B63EFCB
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiLALpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiLALo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:44:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F272D9FAAA;
        Thu,  1 Dec 2022 03:44:49 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8DA5121B27;
        Thu,  1 Dec 2022 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1669895088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4i2hmTJG3JZsAjlKbUAjxq/hqJ7aLy9kBI8fYx+RIJg=;
        b=vwZNtzztj30ZpXCjM0tQYerWIdtxacuAPZ41HsakLScp80AKil5u4csGaS3EfIVru11eYF
        uFwpfpq4k4kTgv1JjBxfsJ3JIlM0Grsr7TxDMwFVK+EjwohpxocXvUVPu4QFJxpQSrJdSP
        V6q6Hk5mmkhVyRpHZmF+ZIDnohN40+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1669895088;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4i2hmTJG3JZsAjlKbUAjxq/hqJ7aLy9kBI8fYx+RIJg=;
        b=9Ru6jInkyfuPLUrMALp40MO5qAj6FtOu9oX7T0AXbgoH2uev2sWnGSD3CP4ZwuGk1KooGw
        4I3Py+nKKXm2tfDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7F1001320E;
        Thu,  1 Dec 2022 11:44:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id OUQCH7CTiGOIVwAAGKfGzw
        (envelope-from <jack@suse.cz>); Thu, 01 Dec 2022 11:44:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 28023A06E4; Thu,  1 Dec 2022 12:44:48 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] block: Fixup condition detecting exclusive opener during partition rescan
Date:   Thu,  1 Dec 2022 12:44:42 +0100
Message-Id: <20221201114442.6829-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1191; i=jack@suse.cz; h=from:subject; bh=ooTJMstDsEeDfhzqsy9acY1xNmp8/ie8MZFBcMY6qqs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjiJOj2L9J6qHjP43xvAGiCcJYfTx28vIn8EVRSzN7 oG3vxbSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY4iTowAKCRCcnaoHP2RA2ZROCA CtoxD65QZ/kyl/S13etoR+OBqqgF+awC7lzzeL3P0HjKjZgDPwPF0/E3R5KDseafDxxOFLuAGKebYr 0a1EC3vrRzoZQhoAy3spxqYwmGT8lTZxw1m9Ml61PR3akjim4aFGjiNLHQISiAGqjP7QzGDsr6lH24 QituANcYJ9z4kULGjbXu65CKhUM/k2lEwUisPQE6Y/Mg23xQWIIo6v1H0uxewjOEjjVAggUj/tK8PT aGiiidoEH0CN/OKCo5KJYswwtno2gpILP0Po/K7QD+kwqpaLEV2hAVv5ZUkaIae4p7Pisz47LpJrdQ bqBBSENkqavRiVd69n7vDQYEcuNNUP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The condition detecting whether somebody else has the device exclusively
open in disk_scan_partitions() has a brownpaper bag bug. It triggers also
when nobody has the device exclusively open and we are coming from
BLKRRPART path. Interestingly this didn't have any adverse effects
during testing because tools update kernel's notion of the partition
table using ioctls and don't rely on BLKRRPART. Fix the bug before
somebody trips over it.

Fixes: 8d67fc20caf8 ("block: Do not reread partition table on exclusively open device")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 012529d36f5b..29fb2c98b401 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -367,7 +367,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 	if (disk->open_partitions)
 		return -EBUSY;
 	/* Someone else has bdev exclusively open? */
-	if (disk->part0->bd_holder != owner)
+	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
 		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-- 
2.35.3

