Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BCD4644A8
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 02:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345620AbhLAB6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 20:58:52 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:46040 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhLAB6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 20:58:51 -0500
Received: by mail-pf1-f173.google.com with SMTP id x131so22587996pfc.12;
        Tue, 30 Nov 2021 17:55:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CSlY3kDkqNpr0i143EnhPyM2hS2hMm/Ui4ojaZheVnw=;
        b=JatidTEl7eca0VwCsIn3I+hlsuLHxMvJVFmZ6sE1QieBIM6xPyaaBmcEY7BjsleQbk
         4DgVsXsaCpazBwbxaoygNJe67u4fFHLOIVWqs11Hd7NwtluzsnU/E0Ijz84y/PjgOerk
         J+SeAuTrYwCdUcomUf95gZF1QFevNS49ADk+PpOoPheT5pv+n+JUxYo85PvVZtMxXgj8
         Dep32cuqL18wFYtCGXTjBC8YkhlcY8RNjdn4nTOjuNxnjyjnsdDNYa9v15zgrggUO5B7
         dJNeUoF4Zs+6TEgrzSE/+10s/t80svleCKw3hLyW93Dlipbknv7GowP+fN+zNGsskUi4
         pjAw==
X-Gm-Message-State: AOAM532MUEHepbqDWZ9gsUb8QLMAhxVq+VXb6fL4ooB2mT8Il0TsKhJT
        CmY5ZltPi5pByqlIEEOAtCqWRbPBG2A=
X-Google-Smtp-Source: ABdhPJz35m2vF5a5muU8RxSqhsB3eyN31BC/XqgtkbYkYegJxfSQgoChDgIG6yUJrLBLrVsjxnDnCQ==
X-Received: by 2002:a05:6a00:1c56:b0:4a4:f8cb:2604 with SMTP id s22-20020a056a001c5600b004a4f8cb2604mr3015274pfw.34.1638323730694;
        Tue, 30 Nov 2021 17:55:30 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g19sm15930560pgi.10.2021.11.30.17.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 17:55:16 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] ksmbd: fix uninitialized symbol 'pntsd_size'
Date:   Wed,  1 Dec 2021 10:54:59 +0900
Message-Id: <20211201015459.26242-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No check for if "rc" is an error code for build_sec_desc().
This can cause problems with using uninitialized pntsd_size.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c70972b49da8..615f977b9d15 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2960,6 +2960,10 @@ int smb2_open(struct ksmbd_work *work)
 							    &pntsd_size, &fattr);
 					posix_acl_release(fattr.cf_acls);
 					posix_acl_release(fattr.cf_dacls);
+					if (rc) {
+						kfree(pntsd);
+						goto err_out;
+					}
 
 					rc = ksmbd_vfs_set_sd_xattr(conn,
 								    user_ns,
-- 
2.25.1

