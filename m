Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6867978B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbjAXMS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbjAXMSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:18:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302B442F1;
        Tue, 24 Jan 2023 04:18:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A56A421892;
        Tue, 24 Jan 2023 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674562695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w15/0UL/apowGdJ7y6J7HeBMbOdAZPHl5hFCfmWK+HY=;
        b=GVuDKujZOKNY3Qiev05AL+BRhKsUtiORAwYSLdtR0WiC+Mc44vXKO7VxLZZuLz9Ofd/LNM
        wuY/1U5YLdD00pkTaRusEF8GKWY2Zz6JMl4HAEQIQkoAoAR3f9vKFziTL8s3tLS3FRmtEd
        0gm1Tfhu3fvg2nDM1hWCN1Xv5ZXQNeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674562695;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w15/0UL/apowGdJ7y6J7HeBMbOdAZPHl5hFCfmWK+HY=;
        b=cox9P3pyRB81yzhq01Nix8050qQyFJ5bSJRngdG5SNAv7qaRI30gJCp3C38j26EccpLW+j
        vzlJGCdcB1ududDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 98FDA13A06;
        Tue, 24 Jan 2023 12:18:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ld1hJYfMz2MGOAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 24 Jan 2023 12:18:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 8246AA071C; Tue, 24 Jan 2023 13:18:14 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 22/22] udf: Fix off-by-one error when discarding preallocation
Date:   Tue, 24 Jan 2023 13:18:08 +0100
Message-Id: <20230124121814.25951-22-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230124120835.21728-1-jack@suse.cz>
References: <20230124120835.21728-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1058; i=jack@suse.cz; h=from:subject; bh=k3x+adLT4BFXbkMp/FV2130s8476xk1byYMXuARSDQc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjz8x/5ZkOM49oEAt047qYwMzlE594teF0jR+PwK6N ZMazJN2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY8/MfwAKCRCcnaoHP2RA2VrNB/ 47o3YgERK+G7Etg5JpZZ8InRqnY11KfgVWtb6JoONKoPqbCf+GT1vJWejcn83nRKt0P44EXUMSxChK KRCtFKvgd/krEVeXBjzCyWbzDXIsXw/3CLPCiRTBCitxH1qY1SkGpbtlgeFD9Zu/Tsw+Ddx6m2OVI9 zxc1dcrVq96+cWGz7g0XfUJHdeqUMrhUwKGAPWgLzUGZEkYlOdpHWuluL4NymwmiUyV2717edwNA5y Zj+O3FaN+T2TvtrIjKR834ee4khj8Yox3/3/5CZjSS84brfUkAtwj45+rqt2/KkqChP5HHdkZWxA+w inCIV0DNQBbCPDqAyEWhT9XjQvNKUF
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

The condition determining whether the preallocation can be used had
an off-by-one error so we didn't discard preallocation when new
allocation was just following it. This can then confuse code in
inode_getblk().

CC: stable@vger.kernel.org
Fixes: 16d055656814 ("udf: Discard preallocation before extending file with a hole")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6826c2aa021f..15e0d9f23c06 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -361,7 +361,7 @@ static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)map->lblk) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)map->lblk) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	err = inode_getblk(inode, map);
-- 
2.35.3

