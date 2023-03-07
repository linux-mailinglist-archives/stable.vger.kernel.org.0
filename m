Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F466AEC19
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjCGRwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjCGRv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A6ACE38;
        Tue,  7 Mar 2023 09:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DBACB819C1;
        Tue,  7 Mar 2023 17:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB081C4339E;
        Tue,  7 Mar 2023 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211172;
        bh=9aSMdrE6eO87rmSUfXuG5Ak7lUktr+u5yI/oZLiPlTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg3slsrzSTRpjEFyXN+aS3jZlnR5L1UaMdSoSrGXyW+gmBUAEqE6fObn1GUBE3T2p
         iYIzIix24lq+k1cHoFQiT02Oqf1hcCKEpfbp7E/wfXqPF1C37cOmGNzTjRg/OSonyV
         CRYCRGgcztawonYdBBcu4QFq8wGdoxyUzVE5kKkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0776/1001] cifs: dont try to use rdma offload on encrypted connections
Date:   Tue,  7 Mar 2023 17:59:08 +0100
Message-Id: <20230307170055.423579951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit 3891f6c7655a39065e44980f51ba46bb32be3133 upstream.

The aim of using encryption on a connection is to keep
the data confidential, so we must not use plaintext rdma offload
for that data!

It seems that current windows servers and ksmbd would allow
this, but that's no reason to expose the users data in plaintext!
And servers hopefully reject this in future.

Note modern windows servers support signed or encrypted offload,
see MS-SMB2 2.2.3.1.6 SMB2_RDMA_TRANSFORM_CAPABILITIES, but we don't
support that yet.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4081,6 +4081,10 @@ static inline bool smb3_use_rdma_offload
 	if (server->sign)
 		return false;
 
+	/* we don't support encrypted offload yet */
+	if (smb3_encryption_required(tcon))
+		return false;
+
 	/* offload also has its overhead, so only do it if desired */
 	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
 		return false;


