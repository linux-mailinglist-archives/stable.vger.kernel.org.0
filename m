Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730E84B47F8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244256AbiBNJio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:38:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiBNJhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8431660D86;
        Mon, 14 Feb 2022 01:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7CA61163;
        Mon, 14 Feb 2022 09:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774E5C340F0;
        Mon, 14 Feb 2022 09:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831305;
        bh=8tqkdPSe1TX4gYfhZraComcw/+m05OtfO1tnPVdC2rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSiv7W4Y3oHEwkxYeizkO6QiDkd8TpwO7JWuunaFG/A1+8BKSpoblBCzZB5PXUGOn
         OzejjohDIY0qjLfSgjcZMLjDe181R7f+mAQWunriaosysZjhaR1n+cykt4AH49ihN8
         YD5Dtn3YCOqEYtQS4337drtj9kZiUnsNjH2v0T4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/71] NFSv4 only print the label when its queried
Date:   Mon, 14 Feb 2022 10:25:40 +0100
Message-Id: <20220214092452.442678468@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 2c52c8376db7160a1dd8a681c61c9258405ef143 ]

When the bitmask of the attributes doesn't include the security label,
don't bother printing it. Since the label might not be null terminated,
adjust the printing format accordingly.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 9a022a4fb9643..0fc08d22c9218 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4187,10 +4187,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
+		if (label && label->label)
+			dprintk("%s: label=%.*s, len=%d, PI=%d, LFS=%d\n",
+				__func__, label->len, (char *)label->label,
+				label->len, label->pi, label->lfs);
 	}
-	if (label && label->label)
-		dprintk("%s: label=%s, len=%d, PI=%d, LFS=%d\n", __func__,
-			(char *)label->label, label->len, label->pi, label->lfs);
 	return status;
 }
 
-- 
2.34.1



