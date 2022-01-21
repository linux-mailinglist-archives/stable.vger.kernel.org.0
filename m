Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323AB496866
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiAUXyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:50 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:35330 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiAUXys (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:48 -0500
Received: by mail-pj1-f49.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso14972200pjh.0;
        Fri, 21 Jan 2022 15:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptHSWfZg92dLsxCEcWmPzTBy5GPDtKlzuE5K+wwkQgI=;
        b=3X/2ZCKuC4cbd0ZuSTUHz9qAbKMYzA0iI7qZTpGXGHPGd7xXtEn1EzQA0yejGFR2/n
         bzvMy1YuME6/JY5OMmzRTbueCeLVQHj5h83Hh/Fbu1eKJGi4Slk1jCs10gaxZAwkitll
         QXLBjn4E5C1FPRq16n56+MByzDUbkh/CXEwk319aKNGelzlTqHQvsgtgyHqwRe45ctBS
         jQKsNuScluLCumgAAGtemIHXhiyNdJEiSlqCZrB1G6XIDLG5soURarU6ATV8IDpoLxRJ
         BkukdGb2Lca6IYRc/On15DlCpkFQ3TbML7RqvtjhBDec64ucfD6Y06lpXM6cRRon64Co
         0QOg==
X-Gm-Message-State: AOAM530hcy4awLT47GqWdd7iyVSBfel1vryqfP6VQMKut5VMqoiBbp59
        IP/BBZ1rjKzSUxv430dcESU=
X-Google-Smtp-Source: ABdhPJxz1NqsX6kUg5rlqMtKK6bAholKNHoE3i3Nr8XIS585WqxegyyoEe+FkI4IENH0JyTZ3wmMIw==
X-Received: by 2002:a17:90a:9284:: with SMTP id n4mr2921502pjo.109.1642809288525;
        Fri, 21 Jan 2022 15:54:48 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 5sm14530082pjf.34.2022.01.21.15.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:48 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16.y 3/4] ksmbd: limits exceeding the maximum allowable outstanding requests
Date:   Sat, 22 Jan 2022 08:54:26 +0900
Message-Id: <20220121235427.10349-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235427.10349-1-linkinjeon@kernel.org>
References: <20220121235427.10349-1-linkinjeon@kernel.org>
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
index 83a94d0bb480..d1d0105be5b1 100644
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
index fedcb753c7af..4a9460153b59 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -337,7 +337,16 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
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
index cbeadaf20697..fcb456ef765b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -322,6 +322,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	}
 
 	conn->total_credits -= credit_charge;
+	conn->outstanding_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-- 
2.25.1

