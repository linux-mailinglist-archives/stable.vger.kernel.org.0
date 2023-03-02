Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387586A8570
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 16:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCBPix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 10:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCBPiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 10:38:52 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53751E1F7
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 07:38:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5DECA1FE67;
        Thu,  2 Mar 2023 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677771530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Ic6a4JKCvOEfJSHXSfajhI4WHcORLiQuhsnE+C5oJ5U=;
        b=wTG2YJwvVEu0LWGHAklq5GOutiekAACpZrLwTycR9vNhjuq7nG0fLp3dWHUCwlZZuN3ezb
        ZJeknG5aWTQs5jab8bW+B0qv5DnyPHAItJSVKxtk7HL71WYBzzSjT5az1SLz15BDugZ3OH
        Dx5jUY02htMYYnjLAURAa9MsVrz+W6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677771530;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Ic6a4JKCvOEfJSHXSfajhI4WHcORLiQuhsnE+C5oJ5U=;
        b=B9sp8ZP++eLdCRbtmRslgXHMAqIUMeTNaQzxdOeHNCi6NLXD2mx5ZNzK8BPPomjrQh+i39
        tASvTNPnRYFl/6Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D9BB13349;
        Thu,  2 Mar 2023 15:38:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R1TtEgrDAGRQDwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 02 Mar 2023 15:38:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7C9B1A06E5; Thu,  2 Mar 2023 16:38:49 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     ocfs2-devel@oss.oracle.com, heming.zhao@suse.com,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] ocfs2: Fix data corruption after failed write
Date:   Thu,  2 Mar 2023 16:38:43 +0100
Message-Id: <20230302153843.18499-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1876; i=jack@suse.cz; h=from:subject; bh=/rKo0FOKiHUXGPKBoNJqtkfi9xkL98IIPrdtd0bUJoI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkAMLycOQHKp0sC2T/Sc+XbDDLf4n2oCUPKeKOtNRe v4D8uD2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZADC8gAKCRCcnaoHP2RA2QePCA DXKXTik128ek3BRYUdzOAqB5VuDGDseHDi4xjGKD7Ul6dweeUIEE2JIM9hmja0ZCFRMPDqvuHLnuWm 1MlPbm8wh7bcniK1WzTcV4WG3Gfs0tqELsC3Hl7qdWz2RdO7VFtEyAlnSjr5dSYnd+cWdfLbj4/uyf 9ScLL8yYO3eaBtxWy1QMf/XQ11oMsYJqpgwez8NLxsPVMWCqiJKhyjozi2QG8ofwP0z+cWuvCgGMHe P+vk+U1I5/m9/q50QZlbrr7GjaHFVVmF0DymC/+ONELpkX5ii3APaQJ8EcDSCSm6LhYL7Rx6016PwB mS4D/lHZZQ3TGH8NRPvnJbNJYEXrLx
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When buffered write fails to copy data into underlying page cache page,
ocfs2_write_end_nolock() just zeroes out and dirties the page. This can
leave dirty page beyond EOF and if page writeback tries to write this
page before write succeeds and expands i_size, page gets into
inconsistent state where page dirty bit is clear but buffer dirty bits
stay set resulting in page data never getting written and so data copied
to the page is lost. Fix the problem by invalidating page beyond EOF
after failed write.

Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1d65f6ef00ca..0394505fdce3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
-- 
2.35.3

