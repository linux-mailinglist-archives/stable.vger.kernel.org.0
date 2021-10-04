Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE411420C49
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhJDNEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234680AbhJDNDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8855C61501;
        Mon,  4 Oct 2021 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352371;
        bh=1zXDoBecLzzbpfoabilc9opIXwaCoU+M4zLd/yn41II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNcCzLlW/xJv7IpsBOMcsHWk89MGWUvpJioOFWbVIbaVzShJ9y1xAUcXtABmiowjT
         QTrWZLQ0ySWFb4dVgDn0nlTf3qHRp7XKbPNnYNznzSgSgmRZCHHODFWUTt/Erj9Owy
         rPWZdtkKcr/1fIRNrP83iViK68SH1jjjqGWPP6ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.14 04/75] cifs: fix incorrect check for null pointer in header_assemble
Date:   Mon,  4 Oct 2021 14:51:39 +0200
Message-Id: <20211004125031.675631254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 9ed38fd4a15417cac83967360cf20b853bfab9b6 upstream.

Although very unlikely that the tlink pointer would be null in this case,
get_next_mid function can in theory return null (but not an error)
so need to check for null (not for IS_ERR, which can not be returned
here).

Address warning:

        fs/smbfs_client/connect.c:2392 cifs_match_super()
        warn: 'tlink' isn't an ERR_PTR

Pointed out by Dan Carpenter via smatch code analysis tool

CC: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3079,9 +3079,10 @@ cifs_match_super(struct super_block *sb,
 	spin_lock(&cifs_tcp_ses_lock);
 	cifs_sb = CIFS_SB(sb);
 	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
-	if (IS_ERR(tlink)) {
+	if (tlink == NULL) {
+		/* can not match superblock if tlink were ever null */
 		spin_unlock(&cifs_tcp_ses_lock);
-		return rc;
+		return 0;
 	}
 	tcon = tlink_tcon(tlink);
 	ses = tcon->ses;


