Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3555FB98C3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 23:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392512AbfITVIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 17:08:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35447 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387849AbfITVIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 17:08:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id a24so4521841pgj.2
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 14:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZO0hAvRwT2ibjcPc7GQW/oJUourWOBL7pIGUyi7fUZY=;
        b=hoyz9cihuwywQjF2OLD3ullaOs8igaLQm47jsEb/DpFWfjwFURPRbIMhRc+zArLuxJ
         bNqKpkzlL/ehhdQ7oXQIDWdUAgZmfqQRlzV/mEBF+/Jvqhry8RkIqXqZN0ZXFzN1OeJg
         xvCmeG8D4yniPEyngSLANElroOO3/nUyymDyPgJ+FfI5oErUcLuv1Zxy6+fpIJTr3Sak
         +VsA7FnLuAQUsb0eIbarR5utfL5z0Fr4QcARvAss23SBkKAejeTVtVzGPNWE3OV2thkM
         Gk3YSxK4/3XD8U30Z+VNJiYBYA7qrWeQL5x3wXor2uhMpmrau97nA/be7HbUuLXf5oA4
         VrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZO0hAvRwT2ibjcPc7GQW/oJUourWOBL7pIGUyi7fUZY=;
        b=mR99ykSJpUCQy5QD6W0tOeFLvz5Acfu9zf40Nqhu7FdwxhJk3hoOcf6qx3Y0+VJFHp
         1wxwxV9FhGj+cEoYd0JB67O/1HOZzXoZQlGAyYOnd3hh6Inj/EZld/3dQiYYfre97SZd
         GuVgIDPf4MCR+7Qv3HLAXJMY6opkNmULgcJqywmf1G0KQRZuYCh9jJ7dZxvTLLN4FUZn
         3OU0U/eqSh3RajdYi2Q9XsS03QiekdPfq28CcOkzSLjtl43cCPIy11bal6Leh6fkLTNV
         9NWHP4h8W8dIpohdlQWU3smk4f9DYiXgRDiRQSxkUyAf3iPdjgSPULoK+0lvpU3GXmi+
         Vs9Q==
X-Gm-Message-State: APjAAAU6kFQ188tTwEXp/BzMvoMOLADXtZWFaoCQhJgtHEyteHBLBPEK
        yxecCVnBql3DMjnSWx/IU+CAjJM=
X-Google-Smtp-Source: APXvYqy1V8E8wogT1GovF9lA9tZL4qNswHxhphguzRDb/taOSsKV1bK16HYuKfodjq4WLnEptqxIjA==
X-Received: by 2002:a17:90a:b114:: with SMTP id z20mr6975036pjq.113.1569013689393;
        Fri, 20 Sep 2019 14:08:09 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([131.107.159.106])
        by smtp.gmail.com with ESMTPSA id d69sm2663821pfd.175.2019.09.20.14.08.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 14:08:08 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     stable@vger.kernel.org
Subject: [PATCH] CIFS: fix deadlock in cached root handling
Date:   Fri, 20 Sep 2019 14:08:03 -0700
Message-Id: <20190920210803.4405-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Commit 7e5a70ad88b1 ("CIFS: fix deadlock in cached root handling") upstream.

Prevent deadlock between open_shroot() and
cifs_mark_open_files_invalid() by releasing the lock before entering
SMB2_open, taking it again after and checking if we still need to use
the result.

CC: <stable@vger.kernel.org> # v4.19+
Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com/T/#u
Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/smb2ops.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index cc9e846a3865..094be406cde4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -553,7 +553,50 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	oparams.fid = pfid;
 	oparams.reconnect = false;
 
+	/*
+	 * We do not hold the lock for the open because in case
+	 * SMB2_open needs to reconnect, it will end up calling
+	 * cifs_mark_open_files_invalid() which takes the lock again
+	 * thus causing a deadlock
+	 */
+	mutex_unlock(&tcon->crfid.fid_mutex);
 	rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
+	mutex_lock(&tcon->crfid.fid_mutex);
+
+	/*
+	 * Now we need to check again as the cached root might have
+	 * been successfully re-opened from a concurrent process
+	 */
+
+	if (tcon->crfid.is_valid) {
+		/* work was already done */
+
+		/* stash fids for close() later */
+		struct cifs_fid fid = {
+			.persistent_fid = pfid->persistent_fid,
+			.volatile_fid = pfid->volatile_fid,
+		};
+
+		/*
+		 * Caller expects this func to set pfid to a valid
+		 * cached root, so we copy the existing one and get a
+		 * reference
+		 */
+		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
+		kref_get(&tcon->crfid.refcount);
+
+		mutex_unlock(&tcon->crfid.fid_mutex);
+
+		if (rc == 0) {
+			/* close extra handle outside of critical section */
+			SMB2_close(xid, tcon, fid.persistent_fid,
+				   fid.volatile_fid);
+		}
+		return 0;
+	}
+
+	/* Cached root is still invalid, continue normaly */
+
 	if (rc == 0) {
 		memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 		tcon->crfid.tcon = tcon;
@@ -561,6 +604,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 		kref_init(&tcon->crfid.refcount);
 		kref_get(&tcon->crfid.refcount);
 	}
+
 	mutex_unlock(&tcon->crfid.fid_mutex);
 	return rc;
 }
-- 
2.17.1

