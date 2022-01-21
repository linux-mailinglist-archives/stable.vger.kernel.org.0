Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDCD49685B
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiAUXyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:04 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:45890 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiAUXyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:04 -0500
Received: by mail-pg1-f178.google.com with SMTP id c5so9376981pgk.12;
        Fri, 21 Jan 2022 15:54:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WHDD6AnNIbFltgrQnZ3SkV7eKjXRnp3FzJv1cPkHzs8=;
        b=o+pixkJe3SNxcoVKROW0J5l7XRkCo0xD+p60r7xSFcIMzJeffLjK1QZOxgafu1lddc
         tWhP9am1hjxUiSZN+g/FeS2GLqCCPNK0Tif0y09YeJJIti+EzVQwE+30AVfnAFK/NkYT
         nY+CXRRy2BuBG4HBkZ1KQ9uvr9IBBz+JOH8J2eFe8yk9Ns2vwQjg/lK+QhfWizdSao6L
         PjUCm/c+wY3BSUD8iMqgyhMwimpOA++bMyvwHcQOzUxf/hBAN8IWOuXYmlq+CSLbchLm
         TIwjYZKG91zLSILqf9aPET+Kfwo7XeHkNHSq02aMQPS3IDvLjx66cdB4nd23+rbelfVJ
         ksSw==
X-Gm-Message-State: AOAM532DM2U88Ut54sYf94AphydYdSbg6Xsql7Um3nTGI//eRJgksYes
        AOcNSJ/HaI1lsrrBEbGc/RBJDblDVx8=
X-Google-Smtp-Source: ABdhPJyOI99NLxzay0/sIgGgPGA7+6x07gUbIEdHFjK0hgkEiYC5N65o4qoDrC2Qtnixaxmoj7NAaA==
X-Received: by 2002:a63:7110:: with SMTP id m16mr4372330pgc.621.1642809244068;
        Fri, 21 Jan 2022 15:54:04 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id nn14sm6076356pjb.26.2022.01.21.15.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:03 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15.y 3/4] ksmbd: limits exceeding the maximum allowable outstanding requests
Date:   Sat, 22 Jan 2022 08:53:39 +0900
Message-Id: <20220121235340.10269-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235340.10269-1-linkinjeon@kernel.org>
References: <20220121235340.10269-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b589f5db6d4af8f14d70e31e1276b4c017668a26 upstream.

If the client ignores the CreditResponse received from the server and
continues to send the request, ksmbd limits the requests if it exceeds
smb2 max credits.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/connection.c | 1 +
 fs/ksmbd/connection.h | 3 ++-
 fs/ksmbd/smb2misc.c   | 9 +++++++++
 fs/ksmbd/smb2pdu.c    | 1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index b57a0d8a392f..f7d5e8b7bef7 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,6 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
+	conn->outstanding_credits = 1;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 08e85568ccd6..8694aef482c1 100644
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
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index e4a28eae51b2..cc1c38686ecd 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,16 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
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
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0ce35717cdde..5327247f98e4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -324,6 +324,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	}
 
 	conn->total_credits -= credit_charge;
+	conn->outstanding_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-- 
2.25.1

