Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5B579E80
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242581AbiGSNBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbiGSM71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF44F680;
        Tue, 19 Jul 2022 05:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D64BB81B29;
        Tue, 19 Jul 2022 12:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B714C341E1;
        Tue, 19 Jul 2022 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233468;
        bh=jD3s+6w84cU2Oi8eJMG5lj6xF1TAOiBOrVNqWZW59DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w74KDlVI18PGN0iVT9uTpT3ceT9Kl3LJ5b5RSm3GhDceoOaY/KRoqWQM4epUpD1cc
         pEN2gt2PFCFa94eNGxTueglGh77eoAJHbyUuLpku4KTy+ZrCV541zqWbJV8shC5QAH
         DL8+2FTxppMeDVB/BteYiHEZTv3Hp2EIx/mfGOwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sikorski <belegdol@gmail.com>,
        Julian Sikorski <belegdol+github@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 133/231] smb3: workaround negprot bug in some Samba servers
Date:   Tue, 19 Jul 2022 13:53:38 +0200
Message-Id: <20220719114725.618451555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 32f319183c439b239294cb2d70ada3564c4c7c39 ]

Mount can now fail to older Samba servers due to a server
bug handling padding at the end of the last negotiate
context (negotiate contexts typically are rounded up to 8
bytes by adding padding if needed). This server bug can
be avoided by switching the order of negotiate contexts,
placing a negotiate context at the end that does not
require padding (prior to the recent netname context fix
this was the case on the client).

Fixes: 73130a7b1ac9 ("smb3: fix empty netname context on secondary channels")
Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol+github@gmail.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6a8a00f28b19..2e6c0f4d8449 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -571,10 +571,6 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	*total_len += ctxt_len;
 	pneg_ctxt += ctxt_len;
 
-	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
-	*total_len += sizeof(struct smb2_posix_neg_context);
-	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
-
 	/*
 	 * secondary channels don't have the hostname field populated
 	 * use the hostname field in the primary channel instead
@@ -586,9 +582,14 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 					      hostname);
 		*total_len += ctxt_len;
 		pneg_ctxt += ctxt_len;
-		neg_context_count = 4;
-	} else /* second channels do not have a hostname */
 		neg_context_count = 3;
+	} else
+		neg_context_count = 2;
+
+	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
+	*total_len += sizeof(struct smb2_posix_neg_context);
+	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
+	neg_context_count++;
 
 	if (server->compress_algorithm) {
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)
-- 
2.35.1



