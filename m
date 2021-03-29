Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296C134C986
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhC2IaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234380AbhC2I2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74FB961878;
        Mon, 29 Mar 2021 08:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006474;
        bh=KJ6RUJOvcleanaIOM1LdO8fBl2dfcR7eVyP52CzP6eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLMnPjEpHFtvIN5gJ+5+FuVaEGiKSLhTWCytWmLMIlNubOO0JqcagROCi9mIIzAtW
         a1sKSTSAquFMAJFwg3SsK7ADuOBvtS0E4T6r5SIiWcCyrRxYGhHPJ9CoV8TJ8sOIFQ
         StaxghoAk3HzjL7+R3mQ7CW0JOqHd/3ci5oVbIWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 029/254] cifs: change noisy error message to FYI
Date:   Mon, 29 Mar 2021 09:55:45 +0200
Message-Id: <20210329075634.096204297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit e3d100eae44b42f309c1366efb8397368f1cf8ed ]

A customer has reported that their dmesg were being flooded by

  CIFS: VFS: \\server Cancelling wait for mid xxx cmd: a
  CIFS: VFS: \\server Cancelling wait for mid yyy cmd: b
  CIFS: VFS: \\server Cancelling wait for mid zzz cmd: c

because some processes that were performing statfs(2) on the share had
been interrupted due to their automount setup when certain users
logged in and out.

Change it to FYI as they should be mostly informative rather than
error messages.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 64fccb8809ec..13d685f0ac8e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1185,7 +1185,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
-			cifs_server_dbg(VFS, "Cancelling wait for mid %llu cmd: %d\n",
+			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
-- 
2.30.1



