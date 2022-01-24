Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37B499926
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454269AbiAXVcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449139AbiAXVO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D80BC0610C6;
        Mon, 24 Jan 2022 12:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CEC26091A;
        Mon, 24 Jan 2022 20:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7B9C340E7;
        Mon, 24 Jan 2022 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055095;
        bh=uYz/Ns3E+w2ZjOC+zO1qZXD4ND4rwbLnrUZCfFXeUSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d83INRVXWrBDG+ACg43+4GBeQaudswPJpoDMoPJ/tbupjvSDkOZPc6pwMaBb3+lZh
         1bxWQVxSWahE1/HOqd6AvwQAgGvlvmGx+iSad7DVgyKZr64k/WloQf8d3WOg1x98zw
         kMB3TLtKDvEFQnKMOFeM5ZIxlrkj8YvK2Rh/yJkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 038/846] ksmbd: limits exceeding the maximum allowable outstanding requests
Date:   Mon, 24 Jan 2022 19:32:35 +0100
Message-Id: <20220124184102.259889512@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit b589f5db6d4af8f14d70e31e1276b4c017668a26 upstream.

If the client ignores the CreditResponse received from the server and
continues to send the request, ksmbd limits the requests if it exceeds
smb2 max credits.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    1 +
 fs/ksmbd/connection.h |    3 ++-
 fs/ksmbd/smb2misc.c   |    9 +++++++++
 fs/ksmbd/smb2pdu.c    |    1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,6 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
+	conn->outstanding_credits = 1;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -61,7 +61,8 @@ struct ksmbd_conn {
 	atomic_t			req_running;
 	/* References which are made for this Server object*/
 	atomic_t			r_count;
-	unsigned short			total_credits;
+	unsigned int			total_credits;
+	unsigned int			outstanding_credits;
 	spinlock_t			credits_lock;
 	wait_queue_head_t		req_running_q;
 	/* Lock to protect requests list*/
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,16 @@ static int smb2_validate_credit_charge(s
 			    credit_charge, conn->total_credits);
 		ret = 1;
 	}
+
+	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
+			    credit_charge, conn->outstanding_credits);
+		ret = 1;
+	} else
+		conn->outstanding_credits += credit_charge;
+
 	spin_unlock(&conn->credits_lock);
+
 	return ret;
 }
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -324,6 +324,7 @@ int smb2_set_rsp_credits(struct ksmbd_wo
 	}
 
 	conn->total_credits -= credit_charge;
+	conn->outstanding_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 


