Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EA72D624B
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391118AbgLJOht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391106AbgLJOhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 25/75] cifs: add NULL check for ses->tcon_ipc
Date:   Thu, 10 Dec 2020 15:26:50 +0100
Message-Id: <20201210142607.291085463@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit 59463eb88829f646aed13283fd84d02a475334fe upstream.

In some scenarios (DFS and BAD_NETWORK_NAME) set_root_set() can be
called with a NULL ses->tcon_ipc.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4768,7 +4768,8 @@ static void set_root_ses(struct cifs_sb_
 	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
 		ses->ses_count++;
-		ses->tcon_ipc->remap = cifs_remap(cifs_sb);
+		if (ses->tcon_ipc)
+			ses->tcon_ipc->remap = cifs_remap(cifs_sb);
 		spin_unlock(&cifs_tcp_ses_lock);
 	}
 	*root_ses = ses;


