Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEF55E384
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiF0Lxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbiF0Lwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8271BDF24;
        Mon, 27 Jun 2022 04:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F3BE61274;
        Mon, 27 Jun 2022 11:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF51C3411D;
        Mon, 27 Jun 2022 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330390;
        bh=Qd/CJBdk7IjouJA7xPLfk0c+qDDiBr7bA/pHqdsM3U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glXmQciCVIdOL892duyh8q+tvsHxrtcDIYwn6cuAX/NTreKKmK1pPcAPYh/m5GkSf
         v1vjvPAR2gT0HXtOs3teJ9e3dApEf78f5OUbr2MxlmfWSDuQ9KMTG25uWPXXZurw8I
         CVgp201gyv8skECBOVGWLGPqScKWS1LpyNRDAUlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 175/181] smb3: fix empty netname context on secondary channels
Date:   Mon, 27 Jun 2022 13:22:28 +0200
Message-Id: <20220627111949.758271609@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit 73130a7b1ac92c9f30e0a255951129f4851c5794 upstream.

Some servers do not allow null netname contexts, which would cause
multichannel to revert to single channel when mounting to some
servers (e.g. Azure xSMB).

Fixes: 4c14d7043fede ("cifs: populate empty hostnames for extra channels")
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -570,16 +570,18 @@ assemble_neg_contexts(struct smb2_negoti
 	*total_len += ctxt_len;
 	pneg_ctxt += ctxt_len;
 
-	ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
-					server->hostname);
-	*total_len += ctxt_len;
-	pneg_ctxt += ctxt_len;
-
 	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
 	*total_len += sizeof(struct smb2_posix_neg_context);
 	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
 
-	neg_context_count = 4;
+	if (server->hostname && (server->hostname[0] != 0)) {
+		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
+					server->hostname);
+		*total_len += ctxt_len;
+		pneg_ctxt += ctxt_len;
+		neg_context_count = 4;
+	} else /* second channels do not have a hostname */
+		neg_context_count = 3;
 
 	if (server->compress_algorithm) {
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)


