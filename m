Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1B4B4638
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbiBNJdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:33:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243674AbiBNJcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124B460DBC;
        Mon, 14 Feb 2022 01:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A181460F83;
        Mon, 14 Feb 2022 09:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735C5C340E9;
        Mon, 14 Feb 2022 09:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831080;
        bh=27snDcMHmdboqii2MmwxWugX1Q1BDnFqJRQ8YQ86qqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpIkGo1J3xto1g9K2+BpMltdeS+3lPFtyJ29jjmtMQXFgZjtJ7KLJv1e4AdnRvDVm
         iI+Rpw4Yrrvxkf7y04qECVN/duj8deOZfFMMTemT1II5haBzfTtWDUBmOzB2dlf+r8
         dMGxni3jqE4mP0saM7QamsgVaGH2tk46SRg9ia7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/44] NFSv4 only print the label when its queried
Date:   Mon, 14 Feb 2022 10:25:31 +0100
Message-Id: <20220214092448.186241179@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
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
index 3cd04c98da6bc..99facb5f186fd 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4272,10 +4272,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
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
 
 out_overflow:
-- 
2.34.1



