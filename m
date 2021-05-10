Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6907F3787E5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhEJLTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234990AbhEJLFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F2C661139;
        Mon, 10 May 2021 10:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644119;
        bh=LrpWikjAJmVDEgKRQhs4/S4vGblFHh9JVcW3zUzIXvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GolDhtVW0uDwIC8ymIPrXk5Ymlhgi7gq3uECJSRaYQG34lqsctOIAVGovgpceOCk6
         ngxKzA77ie7nls2gNZHnMb5JkkZt+D/hmRO2Oow7fiFi+7VIpGIz6r7hRmkVJU4eo+
         k9XlGSjvjiXATph7qsflRVV/mGUd1cUvVgURIylw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 296/342] smb3: when mounting with multichannel include it in requested capabilities
Date:   Mon, 10 May 2021 12:21:26 +0200
Message-Id: <20210510102019.890985141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 679971e7213174efb56abc8fab1299d0a88db0e8 upstream.

In the SMB3/SMB3.1.1 negotiate protocol request, we are supposed to
advertise CAP_MULTICHANNEL capability when establishing multiple
channels has been requested by the user doing the mount. See MS-SMB2
sections 2.2.3 and 3.2.5.2

Without setting it there is some risk that multichannel could fail
if the server interpreted the field strictly.

Reviewed-By: Tom Talpey <tom@talpey.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -840,6 +840,8 @@ SMB2_negotiate(const unsigned int xid, s
 		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
+	if (ses->chan_max > 1)
+		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
@@ -1025,6 +1027,9 @@ int smb3_validate_negotiate(const unsign
 
 	pneg_inbuf->Capabilities =
 			cpu_to_le32(server->vals->req_capabilities);
+	if (tcon->ses->chan_max > 1)
+		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+
 	memcpy(pneg_inbuf->Guid, server->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
 


