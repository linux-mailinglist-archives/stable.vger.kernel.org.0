Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA7436EB9
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 02:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhJVATI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 20:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVATI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 20:19:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3228C061764
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 17:16:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 187so2092449pfc.10
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 17:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rdvyTfRGFSUweVBJzGUOEyZAwLa83Gi/4ABfxwq3VmI=;
        b=LW/wG3DVE/ZTnkdFV51CnYmi9uEOcshQeet2505PriejxU5vgNfdRNWwjllZGxB4vZ
         nJAKjjkdADaCP3Rd6RSEl7RvbXWi9FDnEniplZF8QiKb3aTudqrMqb49//B9oSAVJ+xI
         rktAP9A+oQKKQHVR9vD/N6UcSZL8sixvijkLj+IXPwTVO0iQZz4bKxZkt45DyvVwTEec
         IdCqrB6ksxEWaB0ONaHmKU/ZI6INYmJKPPU5qzmPh7rqb7f4gK8hYXZ0kH+lPwgjPC1G
         oDvv3vBYxPAwvNOPIAlXliPWdORg9PZx9aR8arWCreI1kSmyStD/uvTmLwViTTI6l43G
         w/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rdvyTfRGFSUweVBJzGUOEyZAwLa83Gi/4ABfxwq3VmI=;
        b=E+sun+GbTmn8GynkZIM/kKFrWioLmnpKzYJqCPFnnqGQsbvP9NfAfquFUUO6GUCTT1
         TtOm2xJ4faAf73r67gOqsEzJvPSAShm1n5PTMXAa4RDLo2INwwnigDCjFILgBhJUGQDg
         OlPcvK0ttj2jfTPQQZnRKaBzWW4082tT9Yk87oKikEgXjDNlkb/2Ds4Df8XkmVrtDn6h
         uicTOzbplF3hmAyly2rVqoW4hB60ARt6L7g31BjBWYL9e0tAnlZ/e60Ij/7UItDlob5d
         9BJnEIqtywUO6Uu+5Fmkf4BNUUXW8pfjt9AcGyxGl2jppLd6+rWhnHSDNCuti+gizNmr
         r9eQ==
X-Gm-Message-State: AOAM5327iZLs4OIitNUBFxnnm9eg1tqUDKbP3dcIA/rXfl7Oykp4P11y
        RN3UWVJYw4TkkzUHALBVB9HWU2HPCNk=
X-Google-Smtp-Source: ABdhPJzM2c8Q5TkAhG+PH8qWFPhquWqHI6S3isaArWIe18qcU+Pl9+Xt9gQ4yn2SSzWXY+dCNuwerQ==
X-Received: by 2002:a63:191a:: with SMTP id z26mr6721470pgl.373.1634861811043;
        Thu, 21 Oct 2021 17:16:51 -0700 (PDT)
Received: from moon.. (FL1-122-133-108-128.tky.mesh.ad.jp. [122.133.108.128])
        by smtp.gmail.com with ESMTPSA id m10sm2229504pfk.78.2021.10.21.17.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 17:16:50 -0700 (PDT)
From:   "Masami Ichikawa(CIP)" <masami256@gmail.com>
X-Google-Original-From: "Masami Ichikawa(CIP)" <masami.ichikawa@cybertrust.co.jp>
To:     gregkh@linuxfoundation.org
Cc:     mszeredi@redhat.com, stable@vger.kernel.org,
        zhengliang6@huawei.com,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>
Subject: [PATCH] ovl: fix missing negative dentry check in ovl_rename()
Date:   Fri, 22 Oct 2021 09:16:05 +0900
Message-Id: <20211022001605.22814-1-masami.ichikawa@cybertrust.co.jp>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <163378772914820@kroah.com>
References: <163378772914820@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Liang <zhengliang6@huawei.com>

From: Zheng Liang <zhengliang6@huawei.com>

commit a295aef603e109a47af355477326bd41151765b6 upstream.

The following reproducer

  mkdir lower upper work merge
  touch lower/old
  touch lower/new
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
  rm merge/new
  mv merge/old merge/new & unlink upper/new

may result in this race:

PROCESS A:
  rename("merge/old", "merge/new");
  overwrite=true,ovl_lower_positive(old)=true,
  ovl_dentry_is_whiteout(new)=true -> flags |= RENAME_EXCHANGE

PROCESS B:
  unlink("upper/new");

PROCESS A:
  lookup newdentry in new_upperdir
  call vfs_rename() with negative newdentry and RENAME_EXCHANGE

Fix by adding the missing check for negative newdentry.

Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reference: CVE-2021-20321
Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
---
 fs/overlayfs/dir.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index eedacae889b9..80bf0ab52e81 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -824,9 +824,13 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 		}
 	} else {
 		new_create = true;
-		if (!d_is_negative(newdentry) &&
-		    (!new_opaque || !ovl_is_whiteout(newdentry)))
-			goto out_dput;
+		if (!d_is_negative(newdentry)) {
+			if (!new_opaque || !ovl_is_whiteout(newdentry))
+				goto out_dput;
+		} else {
+			if (flags & RENAME_EXCHANGE)
+				goto out_dput;
+		}
 	}
 
 	if (olddentry == trap)
-- 
2.33.0

