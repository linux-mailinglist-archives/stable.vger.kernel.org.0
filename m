Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7BD163230
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgBRUA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgBRUA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155F82464E;
        Tue, 18 Feb 2020 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056027;
        bh=mgL7HSGN6Ip5HwbugGrUQYfFeYcitgxBsLwi6J77rxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oi+6oVhCyf1n74NhQBJyAfuV08sgL68hji/1NjAbGUStfg5dEMv/QVSVN3RXkKtQd
         4I5tVBDI45Y+x9l7ai8OZTJlAYYGwahIUu70h2wsezC0yVWLizpX7FUEWmurAiEoZM
         stJ+ESXitc3wXVw4ZGN77pbEjzPkP6bYjzRo7qAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 59/66] NFSv4.1 make cachethis=no for writes
Date:   Tue, 18 Feb 2020 20:55:26 +0100
Message-Id: <20200218190433.535496148@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit cd1b659d8ce7697ee9799b64f887528315b9097b upstream.

Turning caching off for writes on the server should improve performance.

Fixes: fba83f34119a ("NFS: Pass "privileged" value to nfs4_init_sequence()")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5293,7 +5293,7 @@ static void nfs4_proc_write_setup(struct
 	hdr->timestamp   = jiffies;
 
 	msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_WRITE];
-	nfs4_init_sequence(&hdr->args.seq_args, &hdr->res.seq_res, 1, 0);
+	nfs4_init_sequence(&hdr->args.seq_args, &hdr->res.seq_res, 0, 0);
 	nfs4_state_protect_write(server->nfs_client, clnt, msg, hdr);
 }
 


