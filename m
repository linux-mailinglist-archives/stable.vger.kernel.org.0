Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3476C2F5E
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 11:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCUKqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 06:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjCUKqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 06:46:38 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180983E1;
        Tue, 21 Mar 2023 03:46:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so13127743wra.13;
        Tue, 21 Mar 2023 03:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679395595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t4AxwrNbXBosIdWOTlqnL08w0o4lntoCcy4bybyLIr0=;
        b=OhYnpS1gk4YXU3Ngn85LyLKtfXXH/KOn2nGOozP4T6yreJX1sEkfYe9/dDK9vxQ2SH
         q41JPPd59YDUe8b2JgV2b58T+VWuigI5Od8y+cJuCeTkEvPWAXY5ZhSzSRE2w3DxeBCH
         OZSWwjA3LKC04+NZu+dyjqPRoVWUXJSF6FPIYegwWujDHqv89BV/egFG/Q/u61IFidOz
         1hgf0cvdC3xJ5nWrEdxJ41MvFyInRxaERXbgKYE05OEV6YzeYnfQzIDHFu8QJTa9Yo/Z
         1uNfdi4nLE21dFzKIaqfkPDrkk/D1SH5APteRC/uUhSrauwJMKOdUtztPIXVWhOSRjv3
         vkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679395595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4AxwrNbXBosIdWOTlqnL08w0o4lntoCcy4bybyLIr0=;
        b=q+BNzUAXQGAgAVBUBHI+knSsvGXujbcCrpPlodV+zdj+hMVlQ+sqAmLBO64gdlk+U9
         LcoUbnwbvigyZmhNn4m9EFU7jTUluhCfG7YNYdkzN6RcNlj+ZHZ/ed4qMoi2uuosK6DA
         YGIo28gLVnYk3pUX9CPRCJPywVYU+NndIpxEmhSsOBmi9+owo4chikBskjzO2e3cKZH+
         1PHwLgMcxCd9MWedPS5c6BK+s8J8dBudxXuMRfND+gwayj3bJ6mTj5rTcju46SpmnZGn
         Qj6uepsfpeDNvy+bVf4AM9oBJ3MG9Smz9xYTSJo8Bbq8JnOs4JCLvwBy0Dk3JoSEpJ9R
         oY6g==
X-Gm-Message-State: AO0yUKVwytQ7DifUbNxeoEkW5YC5SObszF70yGU2/x0PjuK8tqdNgYMP
        v3eGm6VsB1wI6IQJD7imo/25+GIT0rU=
X-Google-Smtp-Source: AK7set8phuvShdcncxaugj14Gu9OfaHJJOrx/MrybQyndt01XkYmqvNbxb8r4MwelS4o4h8rkds4ig==
X-Received: by 2002:a5d:6a44:0:b0:2cf:efa5:5322 with SMTP id t4-20020a5d6a44000000b002cfefa55322mr11436400wrw.14.1679395594500;
        Tue, 21 Mar 2023 03:46:34 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id a7-20020a5d5087000000b002c55306f6edsm10990645wrt.54.2023.03.21.03.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 03:46:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        stable@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 5.15] lockd: set file_lock start and end when decoding nlm4 testargs
Date:   Tue, 21 Mar 2023 12:46:28 +0200
Message-Id: <20230321104628.37323-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 7ff84910c66c9144cc0de9d9deed9fb84c03aff0 upstream.

Commit 6930bcbfb6ce dropped the setting of the file_lock range when
decoding a nlm_lock off the wire. This causes the client side grant
callback to miss matching blocks and reject the lock, only to rerequest
it 30s later.

Add a helper function to set the file_lock range from the start and end
values that the protocol uses, and have the nlm_lock decoder call that to
set up the file_lock args properly.

Fixes: 6930bcbfb6ce ("lockd: detect and reject lock arguments that overflow")
Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org #6.0
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Greg,

The upstream fix applies cleanly to 6.1.y and 6.2.y, so as the
Cc stable mentions, please apply upstream fix to those trees.

Alas, the regressing commit was also applied to v5.15.61,
so please apply this backport to fix 5.15.y.

Thanks,
Amir.

 fs/lockd/clnt4xdr.c        |  9 +--------
 fs/lockd/xdr4.c            | 13 ++++++++++++-
 include/linux/lockd/xdr4.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index 7df6324ccb8a..8161667c976f 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -261,7 +261,6 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	u32 exclusive;
 	int error;
 	__be32 *p;
-	s32 end;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(fl);
@@ -285,13 +284,7 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	fl->fl_type  = exclusive != 0 ? F_WRLCK : F_RDLCK;
 	p = xdr_decode_hyper(p, &l_offset);
 	xdr_decode_hyper(p, &l_len);
-	end = l_offset + l_len - 1;
-
-	fl->fl_start = (loff_t)l_offset;
-	if (l_len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = (loff_t)end;
+	nlm4svc_set_file_lock_range(fl, l_offset, l_len);
 	error = 0;
 out:
 	return error;
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 72f7d190fb3b..b303ecd74f33 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -33,6 +33,17 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
+void nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len)
+{
+	s64 end = off + len - 1;
+
+	fl->fl_start = off;
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = end;
+}
+
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -80,7 +91,7 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-
+	nlm4svc_set_file_lock_range(fl, lock->lock_start, lock->lock_len);
 	return true;
 }
 
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index 5ae766f26e04..025250ade98e 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -24,6 +24,7 @@
 
 
 
+void	nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len);
 int	nlm4svc_decode_testargs(struct svc_rqst *, __be32 *);
 int	nlm4svc_encode_testres(struct svc_rqst *, __be32 *);
 int	nlm4svc_decode_lockargs(struct svc_rqst *, __be32 *);
-- 
2.16.5

