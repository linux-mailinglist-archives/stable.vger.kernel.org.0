Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8E33E36E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhCQA4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCQA4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF8864F92;
        Wed, 17 Mar 2021 00:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942572;
        bh=4DNjOmlZ7d4KBzzPxWE3LCyL6Js+P2t+Kvd2p4coykw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZNASM6cr5b3KmXDmazr8uu1JiKibo7kaoa05jo01Fx6c62ffCOZk36VvtFVzqZjH
         dEYpqdO3T7RmHgleoUbWKGhTnOUi1H0GtPmKoSe3SceLVNU3bt/SEdBEuH3YvuQD0A
         kgvS1CNfH4oh2OS9HOf5TI27XIhM5bEDeL1jslhFdHm3MC6NYEsmxwtdhcg8gktbkn
         IFvScV67mK5BjdHH3y6f3LUZ3ChydLg46vpgAG3S9Nkz/OD3+etX1QLPxSBYt4qCC4
         6vRUMSeimi+EdXMGalhrknfCJ6Rq4Yau1PkSCY+WheuQAuhiMb3TZmLa8h5zv7gojB
         nup3w1lO9AbXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.11 29/61] cifs: change noisy error message to FYI
Date:   Tue, 16 Mar 2021 20:55:03 -0400
Message-Id: <20210317005536.724046-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4a2b836eb017..39a8610c5de6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1182,7 +1182,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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

