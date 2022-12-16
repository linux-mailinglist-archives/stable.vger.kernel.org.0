Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E381264EDE2
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiLPP10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiLPP1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:27:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685FD654DC;
        Fri, 16 Dec 2022 07:27:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 51BBF343E8;
        Fri, 16 Dec 2022 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671204423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfKQUeQ1SIa69rVLeAXATmvBL+mGnddXPrlolxJGssY=;
        b=jFWZ7EBYYjet3YIVMCgDSCeZgcTBs3jTiwDItkBCSDynBEKIHVNQymMmiaDI/mC/VVH9Vk
        gw0lICdPOoOIiR/gMqp9mjvAoAOf0etEpOfi9u71/hGKU20NOzSlUy0VFWXnGLruRsphzt
        +XtFuvYxJKOAY5SLZ10KaIuSotICwd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671204423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfKQUeQ1SIa69rVLeAXATmvBL+mGnddXPrlolxJGssY=;
        b=tLRtc5ejHkq5YrtL9wkXCNfPOQ3VzHE6JMEtINvUkXm81LqlqWW+X/kqIRBrr1eVSe4SUI
        Wx6ccZ3xenKAkaBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 33916138FD;
        Fri, 16 Dec 2022 15:27:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 90WUDEeOnGP2CAAAMHmgww
        (envelope-from <jack@suse.cz>); Fri, 16 Dec 2022 15:27:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DFAC5A0779; Fri, 16 Dec 2022 16:26:56 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 19/20] udf: Truncate added extents on failed expansion
Date:   Fri, 16 Dec 2022 16:24:23 +0100
Message-Id: <20221216152656.6236-19-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221216121344.14025-1-jack@suse.cz>
References: <20221216121344.14025-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1694; i=jack@suse.cz; h=from:subject; bh=86GOJ7HpEKwMdSlvlydtulXjXpNknj/0u/tIGFNmTiw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjnI2mbOwosMviQ+DtKBoU2eQ5RP3DRfdUWxDwPM76 bUBFzrCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY5yNpgAKCRCcnaoHP2RA2YVzCA CUdIAcW1AxLvNT2ZQutf8D89FfKdd1mpZV/8Q7mJlYOz8IBPMRvtHfYs1SI6NCtQvC7BDuzyjU+2Mr W8mGcmuM1IDSQWoyd/4vDqM1RAXsBd1Y5vA7SmOtraC+KVsgfZs7/5jr2n5gPkGPHAqY8X5fjxmAT7 uTChkHuklbt//SKH0JUjiYSuz363sKhndThiUFGHU1lk2kntkB1K7Aon7IfZGrnGLoKm+Ju+p9eHbj 7QapjQJb1lTqXKA1cX6EpP+k99dxWW6S9O3Z4zTqYUNS0UApKTYThk16niFJRMDynDBNIoPFxPdYXd soO44MY7/HHCFKIOPnSA8l7L2JFtkB
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

When a file expansion failed because we didn't have enough space for
indirect extents make sure we truncate extents created so far so that we
don't leave extents beyond EOF.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 787e6a7b355e..fc5937358148 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -431,8 +431,10 @@ static int udf_do_extend_file(struct inode *inode,
 	}
 
 	if (fake) {
-		udf_add_aext(inode, last_pos, &last_ext->extLocation,
-			     last_ext->extLength, 1);
+		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
+				   last_ext->extLength, 1);
+		if (err < 0)
+			goto out_err;
 		count++;
 	} else {
 		struct kernel_lb_addr tmploc;
@@ -466,7 +468,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -475,7 +477,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -489,6 +491,11 @@ static int udf_do_extend_file(struct inode *inode,
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */
-- 
2.35.3

