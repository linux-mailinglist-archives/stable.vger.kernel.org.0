Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827CB460657
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 14:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357401AbhK1NJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 08:09:29 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36607 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhK1NH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 08:07:28 -0500
Received: by mail-pf1-f176.google.com with SMTP id n26so13799501pff.3
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 05:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/TnZNKZkafvJr3ns6CmBq/+QHjZonikIoSOO2Wk5nE=;
        b=Yk4UQg8RqZDT8bReXYqH5dWZc96AigU1eiK0EGRBMHJ+7qm550yMr0YHKTMA3yDShr
         OshSTkQa9j8SdT4ew/dMmae7MtuWbuZvMoIb9LdLbK3EAdHvL2Hv/UXTZP9XphZLGx/5
         7TVGBWWl5kqi4RBCj8ipIYKZlCQfjjMYMlDH36Z14k6hUSa+qFRhLnvryjJ9y/3dBZ4D
         yTfu49xxbikZqnLrnNYZJitKGAH36MgDkXHolT6mP372meCtwb+uVIrOSChC5dFHntjT
         e2r4yqMDU4QfXlDeLt3IvtL0iY2OZ9R22yUMauR/p1Uh7gpmmmyx3SGi7Q1lGr0lmsFI
         txiQ==
X-Gm-Message-State: AOAM531XpNyPGNsBlIOfYv+/WO6eRy49M5tqXq6HX/Lz7EcvICm66706
        GfacTICL0Z5ANBrY3wVTLoc2G1Krq1s=
X-Google-Smtp-Source: ABdhPJzAvagsKqAf8vQQO1Axs8MtXRdJrAIHfGD1l6fYewnVj7dvSe4hSX3hMzXfXBWuNghyN9Ltog==
X-Received: by 2002:aa7:9249:0:b0:4a2:d1c5:c94b with SMTP id 9-20020aa79249000000b004a2d1c5c94bmr32833441pfp.45.1638104652478;
        Sun, 28 Nov 2021 05:04:12 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id w186sm9540069pgb.80.2021.11.28.05.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 05:04:12 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, christophe.jaillet@wanadoo.fr,
        linkinjeon@kernel.org, stfrench@microsoft.com
Subject: [PATCH v2 BACKPORT for 5.15 stable] ksmbd: Fix an error handling path in 'smb2_sess_setup()'
Date:   Sun, 28 Nov 2021 22:04:03 +0900
Message-Id: <20211128130403.10297-1-linkinjeon@kernel.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 v2:
   - add missing Steve's signoff tag.

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

