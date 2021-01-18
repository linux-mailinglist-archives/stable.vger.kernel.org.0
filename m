Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666832FA9D5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436955AbhARTOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390497AbhARLiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F5E22CA0;
        Mon, 18 Jan 2021 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969903;
        bh=pgYpSS5bQC0K9IkNVb6MCXE3lBgJonRBd+yxPo1Gcfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTqYNUPoJe9fRm/xMnBhBAY/DRLEhYu6ZSF7sxqJWeBfkguO97iH1c9wO02ZRjQB6
         D7mI3IAHjQs5nUo22MYtz+7sd05/lfp1/a6q96jb9Pf5hdGVjFh86JifTe+Pf01xdJ
         VROp5X56QW1f3/tvk3QlnmJ1f7hHZ/FnHi/lGR+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Duncan Findlay <duncf@duncf.ca>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/76] cifs: fix interrupted close commands
Date:   Mon, 18 Jan 2021 12:34:23 +0100
Message-Id: <20210118113342.098310614@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 2659d3bff3e1b000f49907d0839178b101a89887 ]

Retry close command if it gets interrupted to not leak open handles on
the server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reported-by: Duncan Findlay <duncf@duncf.ca>
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_send_rqst()")
Cc: stable@vger.kernel.org
Reviewd-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c095f2e6b0825..be06b26d6ca03 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2996,7 +2996,7 @@ close_exit:
 	free_rsp_buf(resp_buftype, rsp);
 
 	/* retry close in a worker thread if this one is interrupted */
-	if (rc == -EINTR) {
+	if (is_interrupt_error(rc)) {
 		int tmp_rc;
 
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
-- 
2.27.0



