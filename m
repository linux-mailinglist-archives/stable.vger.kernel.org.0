Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667082FA8C7
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393687AbhARS1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390734AbhARLl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90608223E4;
        Mon, 18 Jan 2021 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970070;
        bh=Zn5nRmlCfK1TNyBkimUzIiyU4RwFGBt77Uo4jIwPz9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjqlx42hDkgSwYPW3LWTdXJir/j10hg/c2tbHTnf7OydyZWPDJQJrxQ7K9+SjcYdK
         mQ46D4YRZlD3nnwhD48T3Qtr0mEPSXSTIH0UqPoIa92iXQEXSjW83VrPGumqZFb7uU
         ntlKR3PpQUY7ZJkQGtbrYBeg6XNsmsBt8xtg2uFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Duncan Findlay <duncf@duncf.ca>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 024/152] cifs: fix interrupted close commands
Date:   Mon, 18 Jan 2021 12:33:19 +0100
Message-Id: <20210118113353.938062054@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 2659d3bff3e1b000f49907d0839178b101a89887 upstream.

Retry close command if it gets interrupted to not leak open handles on
the server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reported-by: Duncan Findlay <duncf@duncf.ca>
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_send_rqst()")
Cc: stable@vger.kernel.org
Reviewd-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3248,7 +3248,7 @@ close_exit:
 	free_rsp_buf(resp_buftype, rsp);
 
 	/* retry close in a worker thread if this one is interrupted */
-	if (rc == -EINTR) {
+	if (is_interrupt_error(rc)) {
 		int tmp_rc;
 
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,


