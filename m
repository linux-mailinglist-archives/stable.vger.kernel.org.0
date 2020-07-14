Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86D321FB6B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgGNTBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbgGNS7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E78C22B4D;
        Tue, 14 Jul 2020 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753175;
        bh=ecVI2sKbstIFHqe7Mbv87GVVyEHewlYBn/1nEgvvHG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DA0Ea6vPvWNu+IjB/YPTna2IzVj60ZEQRQPmzW5ez6TbN7KJ+yscObTuWqkIYH5ZE
         4nz77GeEPrnFUmwVPzpHn1dDTO2i0mlb/u77QZEiyOSMQ04ARSIq6TlJPXPRp4XltN
         2sqjZC9j0+QjxQMwPeilOqt0TyfcvOFIxwmlcKoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 5.7 148/166] smb3: fix unneeded error message on change notify
Date:   Tue, 14 Jul 2020 20:45:13 +0200
Message-Id: <20200714184122.912946785@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 8668115cf2db40e22e7be02652a3673d8d30c9f0 upstream.

We should not be logging a warning repeatedly on change notify.

CC: Stable <stable@vger.kernel.org> # v5.6+
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -354,9 +354,13 @@ smb2_get_data_area_len(int *off, int *le
 		  ((struct smb2_ioctl_rsp *)shdr)->OutputCount);
 		break;
 	case SMB2_CHANGE_NOTIFY:
+		*off = le16_to_cpu(
+		  ((struct smb2_change_notify_rsp *)shdr)->OutputBufferOffset);
+		*len = le32_to_cpu(
+		  ((struct smb2_change_notify_rsp *)shdr)->OutputBufferLength);
+		break;
 	default:
-		/* BB FIXME for unimplemented cases above */
-		cifs_dbg(VFS, "no length check for command\n");
+		cifs_dbg(VFS, "no length check for command %d\n", le16_to_cpu(shdr->Command));
 		break;
 	}
 


