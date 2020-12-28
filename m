Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5701F2E3F7B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502480AbgL1O2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502477AbgL1O2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F4F22583;
        Mon, 28 Dec 2020 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165699;
        bh=2eT1tiFrlrdnQyphbP6Kozpy3B250w82TeHZUqxlaJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfGxchV9Sd3J3Bc/HeGzCFPFTm+vrrHvCvFCxN9cjD9NTJCS1DxHxyCSRLggDjuk+
         rb+OWeObHudOV9hiNU7+mcHCsPq8JyXbJEILA3kTL/C9fEtuwSSp3MwoCWmi2kiiVh
         9TB8jaarKX3nFjTIQnmMuKL0Vo4Nb6P1tfuGsm+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 624/717] SMB3.1.1: remove confusing mount warning when no SPNEGO info on negprot rsp
Date:   Mon, 28 Dec 2020 13:50:22 +0100
Message-Id: <20201228125050.815411013@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit bc7c4129d4cdc56d1b5477c1714246f27df914dd upstream.

Azure does not send an SPNEGO blob in the negotiate protocol response,
so we shouldn't assume that it is there when validating the location
of the first negotiate context.  This avoids the potential confusing
mount warning:

   CIFS: Invalid negotiate context offset

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -94,6 +94,8 @@ static const __le16 smb2_rsp_struct_size
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
+#define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_sync_hdr) + sizeof(struct smb2_negotiate_rsp))
+
 static __u32 get_neg_ctxt_len(struct smb2_sync_hdr *hdr, __u32 len,
 			      __u32 non_ctxlen)
 {
@@ -109,11 +111,17 @@ static __u32 get_neg_ctxt_len(struct smb
 
 	/* Make sure that negotiate contexts start after gss security blob */
 	nc_offset = le32_to_cpu(pneg_rsp->NegotiateContextOffset);
-	if (nc_offset < non_ctxlen) {
-		pr_warn_once("Invalid negotiate context offset\n");
+	if (nc_offset + 1 < non_ctxlen) {
+		pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
 		return 0;
-	}
-	size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;
+	} else if (nc_offset + 1 == non_ctxlen) {
+		cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
+		size_of_pad_before_neg_ctxts = 0;
+	} else if (non_ctxlen == SMB311_NEGPROT_BASE_SIZE)
+		/* has padding, but no SPNEGO blob */
+		size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen + 1;
+	else
+		size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;
 
 	/* Verify that at least minimal negotiate contexts fit within frame */
 	if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_context))) {


