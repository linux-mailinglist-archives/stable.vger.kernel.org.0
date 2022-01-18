Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B55492366
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiARJ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:57:58 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36308 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiARJ55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:57:57 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 58D5E1F3C0;
        Tue, 18 Jan 2022 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642499876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSHOPK7zYi3j7vq/yLcdOnOdEZ24LfmyZEXUCcoD0Jw=;
        b=eSvWZ+/4LNDWzjE5pqTe6MtcZDWGsdtFGxWafIfMSd3wf2nyNbCdvN8LIjwwSksW4olS1H
        Au2Px91/OKwIE9wd80R1BRULziEr696RLXaomoHnLqkSrz8vd7YiCMAEaGDjH6rgR7ntrw
        6qOqpdXb2tnQtoED2JuGcnmz3ApJrIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642499876;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSHOPK7zYi3j7vq/yLcdOnOdEZ24LfmyZEXUCcoD0Jw=;
        b=9fiOC4YZZptMD4zettNfBcy+tt0lm08GzdWGjgm5vnqeuHWUavl+CHS6nzIfB5j//NtIgL
        942BwZoWhCSKGsDg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4D29AA3B85;
        Tue, 18 Jan 2022 09:57:56 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 12D42A05E5; Tue, 18 Jan 2022 10:57:56 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/2] udf: Restore i_lenAlloc when inode expansion fails
Date:   Tue, 18 Jan 2022 10:57:48 +0100
Message-Id: <20220118095753.627-2-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118095449.2937-1-jack@suse.cz>
References: <20220118095449.2937-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=985; h=from:subject; bh=9b9vN2SU722zTqf8/Q5HNRvRGqESjFPUxds0LOSprRo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh5o8cWdAYPLgqHofPVfMk2ZkcoazBcz8l901c5NdL 4o6ztwyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeaPHAAKCRCcnaoHP2RA2ZBCCA CLAJ/L+dFi36l1RSdqp2ZwqsQ9pYD5v2zaK/BBysFrvjL6+RTk0iSbnuKHNAdt3lkFbflAc+5bR7Sv MnUu6T1u2JkpiFPWhlHyI/qnELpN9QOIojei2vQLvekuE2vNkm6ZS6M0wFPswpv9EvREf+C5cB+DxB VPW/fNWaumesZfAwY8JtqafwLt/+Rb2GxPL9piHncorvqTzkRhKmPek1CE1PManQGTsyNZWQkWnjm6 Uj0zEw2+4RLY6lE20uGxYW3TVYDaqZnENFLcoqKFW+tzMyPCaAFSVdyM+HvbYRtfS7kOMCdQbrR7y9 Y6iIAUyJY8krueRasMQ2/e7YvlAMni
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we fail to expand inode from inline format to a normal format, we
restore inode to contain the original inline formatting but we forgot to
set i_lenAlloc back. The mismatch between i_lenAlloc and i_size was then
causing further problems such as warnings and lost data down the line.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 7e49b6f2480c ("udf: Convert UDF to new truncate calling sequence")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index d6aa506b6b58..ea8f6cd01f50 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -315,6 +315,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	put_page(page);
-- 
2.31.1

