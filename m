Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C842746064A
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357456AbhK1NAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 08:00:02 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:37464 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357524AbhK1M6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:58:01 -0500
Received: by mail-pg1-f176.google.com with SMTP id 71so12989829pgb.4
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 04:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PrKHxqv7fDMlqfSZwdEAMplqou+69N9YTQNIyaHczuc=;
        b=mh81LqOvy68tF7svBPsRzsU1Vu6GEXxenMLnE4WtWMI3Ni/TEhLSr3p1MnFyMrZk60
         wpF3k/D9hmtDZ4SW7nlv9ZDS4cHnffmCWgzaWbFT0Fnx6jI904xatIHKzBjqnrOSz7vI
         15+q8hUJHQCA5akMbiI0OP7ERUMwZ+gfCqvi5J7eSvAJCGtMQyZGGkJEMpjkzYYrGyBe
         Vx6pTl3YyfBiTsMI1aWoHQZ4v4raUHADQTqsTvnQX5LnVSasgBb9iOlQG4MfCNXl2fCT
         vLRJagFb8y7woXv+r6yPXPxSrsphgPSQNMI/p+TSVEgYBOtDIncTSGIAJCzHM4lK44wG
         pQ2Q==
X-Gm-Message-State: AOAM530CeS3Mfk4m0fOAmnLdM7RNEMLxG/PTkoFfON2f+HeAb1t7mPFC
        k5+zdfHEHMLj59GQ2Bt5+UjRee5ncHg=
X-Google-Smtp-Source: ABdhPJwoE6tCYyQGenL+zFukSkoerEc940t7TEMczCCy5bO420i/p0C0gUoFgNDhU5K6m6ni0U9QEg==
X-Received: by 2002:a05:6a00:a18:b0:4a7:ef65:ddfb with SMTP id p24-20020a056a000a1800b004a7ef65ddfbmr24193691pfh.17.1638104085541;
        Sun, 28 Nov 2021 04:54:45 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id z10sm8231816pfh.188.2021.11.28.04.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:54:45 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, christophe.jaillet@wanadoo.fr,
        linkinjeon@kernel.org, stfrench@microsoft.com
Subject: [PATCH BACKPORT for 5.15 stable] ksmbd: Fix an error handling path in 'smb2_sess_setup()'
Date:   Sun, 28 Nov 2021 21:54:37 +0900
Message-Id: <20211128125437.10027-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.

All but the new error handling path added by the commit given in the Fixes
tag below.

Fix this error handling path and branch to 'out_err' as well.

Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ksmbd/smb2pdu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 589694af4e95..9ae1d19ebc38 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1700,8 +1700,10 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
 	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
-		return -EINVAL;
+	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+		rc = -EINVAL;
+		goto out_err;
+	}
 
 	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
 			negblob_off);
-- 
2.25.1

