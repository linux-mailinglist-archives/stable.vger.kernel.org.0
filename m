Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5291014E2B1
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgA3Skn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbgA3Skl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA73214AF;
        Thu, 30 Jan 2020 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409641;
        bh=JkVwYf0IXv2ijGwm1KGIIPEiPDUR4873p/dAQ6BicAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnqJIbtDfbQFISeEDiqG0nvFThrXIXUE+x+QV0cLi4vlKrUPzvOT1FXDplxlmpQAg
         HnNqd3k7z7y5ysgp1h3DZsngWEwAcFN8eBD1/KSQFyv731eMS+hF6KrObgxJBR5Q2j
         psOQOSgx0NmdX5HXGlQMFJqg9fX5VZFGC7aERFqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.5 30/56] cifs: set correct max-buffer-size for smb2_ioctl_init()
Date:   Thu, 30 Jan 2020 19:38:47 +0100
Message-Id: <20200130183614.551929041@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 731b82bb1750a906c1e7f070aedf5505995ebea7 upstream.

Fix two places where we need to adjust down the max response size for
ioctl when it is used together with compounding.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1523,7 +1523,9 @@ smb2_ioctl_query_info(const unsigned int
 					     COMPOUND_FID, COMPOUND_FID,
 					     qi.info_type, true, buffer,
 					     qi.output_buffer_length,
-					     CIFSMaxBufSize);
+					     CIFSMaxBufSize -
+					     MAX_SMB2_CREATE_RESPONSE_SIZE -
+					     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 		}
 	} else if (qi.flags == PASSTHRU_SET_INFO) {
 		/* Can eventually relax perm check since server enforces too */
@@ -2697,7 +2699,10 @@ smb2_query_symlink(const unsigned int xi
 
 	rc = SMB2_ioctl_init(tcon, &rqst[1], fid.persistent_fid,
 			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0, CIFSMaxBufSize);
+			     true /* is_fctl */, NULL, 0,
+			     CIFSMaxBufSize -
+			     MAX_SMB2_CREATE_RESPONSE_SIZE -
+			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 	if (rc)
 		goto querty_exit;
 


