Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305962534E4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHZQ24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgHZQ2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:45 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7ABC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:44 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id q23so972642wmj.0
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wC5wqDfuf+saZxph+SX8sbdo9xJEXrFL2V59EV+AaBQ=;
        b=g4qQ3iTG32xCzJKBJ2zbBeDT7UAk4pTAauSx2VxMxdWkJeLVY51KaKnfU9QssWDN7S
         F3DV2W1qNSH6UgH6HPpe+SYILOv4lU/RSCG99tZ9tlnfspTEhpd3gEsLxwaM2UmC0RhC
         9bD4mATXtZicirrXW+a1Bl4fnqzeOCJe8jHJRg5ExGFYirtAnWmaxC1mPzAZv0aT/aHp
         ZMIEvRRvOfOIquOmBPr+A9asz/KY1+IjTxdb+Ir5IcVFy7Qb2ITW0scyZcOgtFsycfRU
         UWcuNMs2qg+h5QtN85y8MEigLEHFmunQB7hnUIOeOSWtT8ogipGXVV7hix4fX+IK5Gxw
         qwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wC5wqDfuf+saZxph+SX8sbdo9xJEXrFL2V59EV+AaBQ=;
        b=RaxqDIeQzM3BefaKTNdD7Wx4kIz97UqQkmAcDFN6wqijURfl7L6Iz+LAP5zTyIXthv
         EnpkU4sfKsD3sjpITlFg1aQTJScFgoAffwHkthLdbTOnEOhwa6IcSWgFxvQVd/6staFw
         rj6dGWoqFDlTUGbD3NbKLs74kskDTvyYODS8s4JqVdRHLi1DUAH09Fs5tvKsoYNlIJOD
         4AT/ukbF1txT9GybpRkKto98fhXbUn3QBuyJSZF9o6MRm9rzPnicNtYu/XXqJYwALIJ2
         uccElZHbRHeyk+YdkkyeJRVLJ2BfAuz7n25y0WkJbPD3OdVbgD9NOOl21Us7uXjnbVNY
         zWgQ==
X-Gm-Message-State: AOAM532SVL7Tpthw3WxtkCkVdw2PyPaad+Ot3kmH1FVhds38zMiHWJQk
        3flsciIsbD/8rEpnDvBo8+XFGRs6zBMyiPdPy15X683KskHNAcGYvIxK/JylRmmZTTgcQsdKqYt
        KMfj5lH1ip2ccCmOQKOkeIjTRrh0n6LH2p9CzCd1D5qKgHhdlWcwrWJ+goL3fjKIWwsI=
X-Google-Smtp-Source: ABdhPJwbYy5bXjNnlxDWzHhcEVzoXrgKUSTxy6H8IQyMJ4DWZhMAaDHyfyHWpfNSBYG4Kskic4yABLeGNPMFug==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:a7b:c019:: with SMTP id
 c25mr210876wmb.0.1598459321617; Wed, 26 Aug 2020 09:28:41 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:25 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-4-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 3/6] kheaders: optimize header copy for in-tree builds
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

This script copies headers by the cpio command twice; first from
srctree, and then from objtree. However, when we building in-tree,
we know the srctree and the objtree are the same. That is, all the
headers copied by the first cpio are overwritten by the second one.

Skip the first cpio when we are building in-tree.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
(cherry picked from commit ea79e5168be644fdaf7d4e6a73eceaf07b3da76a)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/gen_kheaders.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 6ff86e62787f..0f7752dd93a6 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -56,14 +56,16 @@ fi
 rm -rf $cpio_dir
 mkdir $cpio_dir
 
-pushd $srctree > /dev/null
-for f in $dir_list;
-	do find "$f" -name "*.h";
-done | cpio --quiet -pd $cpio_dir
-popd > /dev/null
+if [ "$building_out_of_srctree" ]; then
+	pushd $srctree > /dev/null
+	for f in $dir_list
+		do find "$f" -name "*.h";
+	done | cpio --quiet -pd $cpio_dir
+	popd > /dev/null
+fi
 
-# The second CPIO can complain if files already exist which can
-# happen with out of tree builds. Just silence CPIO for now.
+# The second CPIO can complain if files already exist which can happen with out
+# of tree builds having stale headers in srctree. Just silence CPIO for now.
 for f in $dir_list;
 	do find "$f" -name "*.h";
 done | cpio --quiet -pd $cpio_dir >/dev/null 2>&1
-- 
2.28.0.297.g1956fa8f8d-goog

