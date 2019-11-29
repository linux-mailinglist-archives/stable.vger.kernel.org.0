Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0058710D027
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 01:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfK2ATx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 19:19:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39564 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfK2ATw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 19:19:52 -0500
Received: by mail-pj1-f67.google.com with SMTP id v93so9233577pjb.6;
        Thu, 28 Nov 2019 16:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h53cQjZSibuH3tAJSYGep55eMe8Vd0lhXfafS/71YMc=;
        b=Bv85t85R3UvENEoNM1z9LUb+cWEgsm9+BUi6Z6TY45q7P4tPHrTkzmbq19ZyKt3gaY
         4Y7b1GC07f6G3J9lhtrt1nyCJUz91Vr1W2Zz7WfhKYP89Y1e+CepLYa/Fd3ILNkgJBYm
         HXkFZ33yEKBBype4wxBkYrsItVCCwAL4ez8pa2iagti25qmNm1/7arPwnqs0LjBvPk/a
         HcOWyYq2ZMG0wlTN87SrVWqCrlFKwRYxUDQ1pE9TplPwkhzvnEg5teYfGGf3zSega9/A
         2n83v1OcpOZr1pKNmtVs5LQQ3sLA7oD9FUEar9wbLLo7EXJLaDtOv+EpKnCuO6o92m7i
         Udsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=h53cQjZSibuH3tAJSYGep55eMe8Vd0lhXfafS/71YMc=;
        b=Hbc8GTR+F11fK97IH198Du+vIq0CbVSZQ4h3RYE46wCQuPEfqDoCXejrwQOUFx5bq2
         0T/7dwBMyKnHlyVESVwXiQ5VH2XFdOYqAmyn1HJ0WkoxwtJHsXCTe1tPkZq9q/ir/779
         3Cx90518HkSfCOD1O7OsdLoUUPNGMVoMn4ht5d3L4Krg0bljfSFB+3ckvljRm2Bkxmyr
         gvAAu+qSZ0laG6u5LrbiB/Jr2niqjc2gRPcor76pwHut4hCswrhCdsWxTNpHVaSDxcmj
         exm3vy5ccNj0qY35zBBegBJUggu6vNkJT9X2jZ7Nth5dzNyEvTfV9hRl6fdGYrMo4OaD
         Nn+g==
X-Gm-Message-State: APjAAAWbvCYNVYuzUFawhyVTX/ma2N2BVtfnqtRAPQATA1hrPBEIodz3
        cbv1x35OW/GgzMkBY9XxO+w=
X-Google-Smtp-Source: APXvYqydSlcywgyu28ko3Or1LMj946GqVhi84pXtfb+mGorPFT5tefwcV+ieBvVCZA+weqO0Y7JsjQ==
X-Received: by 2002:a17:902:a408:: with SMTP id p8mr12227465plq.266.1574986791930;
        Thu, 28 Nov 2019 16:19:51 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id c2sm21717929pfn.55.2019.11.28.16.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 16:19:50 -0800 (PST)
From:   Joel Stanley <joel@jms.id.au>
To:     David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, openbmc@lists.ozlabs.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>
Subject: [PATCH] Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
Date:   Fri, 29 Nov 2019 10:49:30 +1030
Message-Id: <20191129001930.651128-1-joel@jms.id.au>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit f2538f999345405f7d2e1194c0c8efa4e11f7b3a. The patch
stopped JFFS2 from being able to mount an existing filesystem with the
following errors:

 jffs2: error: (77) jffs2_build_inode_fragtree: Add node to tree failed -22
 jffs2: error: (77) jffs2_do_read_inode_internal: Failed to build final fragtree for inode #5377: error -22

Fixes: f2538f999345 ("jffs2: Fix possible null-pointer dereferences...")
Cc: stable@vger.kernel.org
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
5.4 cannot mount (some?) jffs2 filesystems without this fix. Hou pointed
this out[1] a while back but the fix didn't make it in. It's still
broken in -next.

[1] https://lore.kernel.org/lkml/2758feea-8d6e-c690-5cac-d42213f2024b@huawei.com/

 fs/jffs2/nodelist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c
index 021a4a2190ee..b86c78d178c6 100644
--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -226,7 +226,7 @@ static int jffs2_add_frag_to_fragtree(struct jffs2_sb_info *c, struct rb_root *r
 		lastend = this->ofs + this->size;
 	} else {
 		dbg_fragtree2("lookup gave no frag\n");
-		return -EINVAL;
+		lastend = 0;
 	}
 
 	/* See if we ran off the end of the fragtree */
-- 
2.24.0

