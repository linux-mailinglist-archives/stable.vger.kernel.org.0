Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8036E359A28
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhDIJ4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233505AbhDIJ4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 641866115B;
        Fri,  9 Apr 2021 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962149;
        bh=jX/uMPf9O5TqBbLReJpZMDzgWBSR4cg8pgu28NAtz/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jrty2x33x99qJKjDdrVBwBu3hVsY1OPiK5NPBCwEsma+L3KaEo/bOyGWB3HqLYGa3
         XmL9dpTpOtRjhyiDz7+VPa1Vr3xC1EQfDvG5cfX8CZKRjPoVgtI820JxF0xKDitQut
         912TaBY5l2tiSfjcr9RxCjKfaFUFnpI3ei3YAVo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/13] cifs: Silently ignore unknown oplock break handle
Date:   Fri,  9 Apr 2021 11:53:29 +0200
Message-Id: <20210409095259.926118372@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
References: <20210409095259.624577828@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 219481a8f90ec3a5eed9638fb35609e4b1aeece7 ]

Make SMB2 not print out an error when an oplock break is received for an
unknown handle, similar to SMB1.  The debug message which is printed for
these unknown handles may also be misleading, so fix that too.

The SMB2 lease break path is not affected by this patch.

Without this, a program which writes to a file from one thread, and
opens, reads, and writes the same file from another thread triggers the
below errors several times a minute when run against a Samba server
configured with "smb2 leases = no".

 CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
 00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
 00000010: 00000001 00000000 ffffffff ffffffff  ................
 00000020: 00000000 00000000 00000000 00000000  ................
 00000030: 00000000 00000000 00000000 00000000  ................

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -651,8 +651,8 @@ smb2_is_valid_oplock_break(char *buffer,
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
-	return false;
+	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
+	return true;
 }
 
 void


