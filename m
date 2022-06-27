Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C7D55DBF3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiF0Lxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiF0Lwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D2DDF64;
        Mon, 27 Jun 2022 04:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4CBC61192;
        Mon, 27 Jun 2022 11:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E267BC3411D;
        Mon, 27 Jun 2022 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330399;
        bh=XmVCpr/zKDWe90GV3W/5jn0rsMtY3ZHvfNsSb643UE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH+/09EsACx1D4t2BDBDAgsI97xBWDSORUA8qfvdjp/4j7yzq9v6Gy+k6to/ESsLy
         Js503+LRa0Sxmm96NgIrj4EmMxGLTuy/W1gklculFxUKK4qgm/B6YxiIfm3qPNtLV9
         comcTdJr2SebNa4jWEoqOGTSGT2FSE9Wwhz6Ygj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 178/181] smb3: use netname when available on secondary channels
Date:   Mon, 27 Jun 2022 13:22:31 +0200
Message-Id: <20220627111949.843791924@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 9de74996a739bf0b7b5d8c260bd207ad6007442b upstream.

Some servers do not allow null netname contexts, which would cause
multichannel to revert to single channel when mounting to some
servers (e.g. Azure xSMB). The previous patch fixed that by avoiding
incorrectly sending the netname context when there would be a null
hostname sent in the netname context, while this patch fixes the null
hostname for the secondary channel by using the hostname of the
primary channel for the secondary channel.

Fixes: 4c14d7043fede ("cifs: populate empty hostnames for extra channels")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5e8c4737b183..12b4dddaedb0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -543,6 +543,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
 	char *pneg_ctxt;
+	char *hostname = NULL;
 	unsigned int ctxt_len, neg_context_count;
 
 	if (*total_len > 200) {
@@ -574,9 +575,15 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	*total_len += sizeof(struct smb2_posix_neg_context);
 	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
 
-	if (server->hostname && (server->hostname[0] != 0)) {
+	/*
+	 * secondary channels don't have the hostname field populated
+	 * use the hostname field in the primary channel instead
+	 */
+	hostname = CIFS_SERVER_IS_CHAN(server) ?
+		server->primary_server->hostname : server->hostname;
+	if (hostname && (hostname[0] != 0)) {
 		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
-					server->hostname);
+					      hostname);
 		*total_len += ctxt_len;
 		pneg_ctxt += ctxt_len;
 		neg_context_count = 4;
-- 
2.36.1



