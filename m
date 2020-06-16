Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CED1FBA20
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbgFPPp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbgFPPp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F2D2071A;
        Tue, 16 Jun 2020 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322327;
        bh=jRX2BqKsnp6TD45Yoi2jMgpDW11Cawk4jDLNyN7IzcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQzwkOi2GRDro2pIWVkcz8ovWrNgTAvWS21S8CR0FXXXCKwR1qQWjrGwFTRLlr/gz
         11luO0w0rtxtr5oDTZuco9HwP585zuAL9iHjrxRQpAtGNAimaaGHMLZp9BotLujYpU
         Om68cRY9PixtveflA3udzCpW7cFhr8NiLp9SJMGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.7 058/163] smb3: fix incorrect number of credits when ioctl MaxOutputResponse > 64K
Date:   Tue, 16 Jun 2020 17:33:52 +0200
Message-Id: <20200616153109.627967037@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit e80ddeb2f70ebd0786aa7cdba3e58bc931fa0bb5 upstream.

We were not checking to see if ioctl requests asked for more than
64K (ie when CIFSMaxBufSize was > 64K) so when setting larger
CIFSMaxBufSize then ioctls would fail with invalid parameter errors.
When requests ask for more than 64K in MaxOutputResponse then we
need to ask for more than 1 credit.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2922,7 +2922,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 	 * response size smaller.
 	 */
 	req->MaxOutputResponse = cpu_to_le32(max_response_size);
-
+	req->sync_hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(max_response_size, SMB2_MAX_BUFFER_SIZE));
 	if (is_fsctl)
 		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
 	else


