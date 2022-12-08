Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC964709A
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLHNQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiLHNQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:16:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B130E92FE6;
        Thu,  8 Dec 2022 05:16:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 416BC3397C;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAVfV1xr3w2V1VuVqoxH5wiVVWcokkBFdzfcpikrNZM=;
        b=Rhfyc9uCbAaLTJRF9aSoXGDjXG9sh8iYo102C6wCO7d2UG8WQOTU1hbt3WaROP5YfIOf0E
        vEbCcZEw7dkD5Ohlfpv0qWCFM2JG3vt4lLHD3Dw4qdoyQR9GSH6wMG9zpxG6SzuB0v075o
        52CwDYqWdrg0J/tRj/f2IxDlBNQX3rQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAVfV1xr3w2V1VuVqoxH5wiVVWcokkBFdzfcpikrNZM=;
        b=TRHk6LWpWcGip46gfgT7a2F2KFyhZxx8KqJxNrO6cceRdd34kFw2R/JBj5jKUby8FijaG5
        GRhbR7coriw31vBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34AA0138E0;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gvjXDI/jkWNRTQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 13:15:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id BFDEBA0728; Thu,  8 Dec 2022 14:15:58 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/4] udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
Date:   Thu,  8 Dec 2022 14:15:49 +0100
Message-Id: <20221208131558.27298-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221208131111.29134-1-jack@suse.cz>
References: <20221208131111.29134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=895; i=jack@suse.cz; h=from:subject; bh=j6SpR+GLjZrfxyoy0lAfqMG1FSsd3rc+mDmoPSNgE3Y=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjkeOE8a+rg/yn+8UgR13XOlgHNcFY0n91N90F6YEm W7FY416JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY5HjhAAKCRCcnaoHP2RA2VcUB/ 0fke2/D7sJgZNgDDBBqsLBFNLjJu4pgVeyBbakprkNDzALmf3U76y05qskoIcM1SiEaGc5HNNJ4V9O EnjMzW1w1yVVcQXAv+R7YFAWo7U2vbuIQcOrXndMsiiDIAc8HRphuVJKx0bQk39CF3H3b3gn3w3bjO mkwRp0kD7CU3hw9WUzOzJk7Ns8Xw9R69PA7lbDei1j2LqeShnKHmhgUS5BpdkpC3eVz0XVYGUjQ3hj PrPzJlclodLo9PLaa4woR/60MMQ7btV/vEjYk4E/4ApFad0A18CSXJKnA/Lvg6rH8X/yayHHKpYvLL w+mcBCCSt+dJX0HWAnmXsdRrWXWTWD
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

If rounded block-rounded i_lenExtents matches block rounded i_size,
there are no preallocation extents. Do not bother walking extent linked
list.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/truncate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index a9790fb32f5f..036ebd892b85 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -127,9 +127,10 @@ void udf_discard_prealloc(struct inode *inode)
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == iinfo->i_lenExtents)
+	    ALIGN(inode->i_size, bsize) == ALIGN(iinfo->i_lenExtents, bsize))
 		return;
 
 	epos.block = iinfo->i_location;
-- 
2.35.3

