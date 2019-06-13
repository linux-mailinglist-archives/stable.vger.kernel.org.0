Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8633445E7
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfFMQr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:47:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35438 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730259AbfFME7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 00:59:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so10203862pgl.2;
        Wed, 12 Jun 2019 21:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wLiv6GN7xAd5Zv2tE3Uvom556HtPMdkccB9NZBaHbY=;
        b=jltvVX7lsUUTKxPZyeSzWIf018y0fP8y5nQ+NWWAxnPTlVFWwLs85lF2YolJCJS9JB
         6GloAfUF+sbPjORm1UzyH8hpS3h1/ZziR5WP5SbBW7RSiNryWvNK5TTpyEAZtDzVcwDM
         Jyvj3Sa8zkG/rB4Yxzhunjsl2Gtx/p9bKlegqbW+fyXM7iOm8GN5wSnEDDWAokGaP1d3
         zeIuD8gtOSYzJV701nDSid73biG0QmRa942s7I+/QMExM3u69N0Sf8+s6McWOW9EQdS7
         raZAijhGdEkW7+klw/tN/7HfsI+wQnWGa4tbhVUkEGR3w57Xx6WK7X+XdGMJzs+/PTuo
         F8ug==
X-Gm-Message-State: APjAAAVxNAXmrCIkEsZovLXNNYZ9Lq2BGM9kPyKk3O0gKJLeIBst9zGs
        4kineA8lkzGfyIFMHCRB8Ho=
X-Google-Smtp-Source: APXvYqyRFetiSrVNAFOs+Vdat5g6tOVK6CHQ8Kpr4jVNenuu39OoAGQYcODaNP5cx3ByfK2aAkX8CQ==
X-Received: by 2002:a63:4813:: with SMTP id v19mr2978773pga.124.1560401964368;
        Wed, 12 Jun 2019 21:59:24 -0700 (PDT)
Received: from htb-2n-eng-dhcp405.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o66sm1215327pfb.86.2019.06.12.21.59.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 21:59:23 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/3] resource: Fix locking in find_next_iomem_res()
Date:   Wed, 12 Jun 2019 21:59:01 -0700
Message-Id: <20190613045903.4922-2-namit@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613045903.4922-1-namit@vmware.com>
References: <20190613045903.4922-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since resources can be removed, locking should ensure that the resource
is not removed while accessing it. However, find_next_iomem_res() does
not hold the lock while copying the data of the resource.

Keep holding the lock while the data is copied. While at it, change the
return value to a more informative value. It is disregarded by the
callers.

Fixes: ff3cc952d3f00 ("resource: Add remove_resource interface")
Cc: stable@vger.kernel.org
Cc: Borislav Petkov <bp@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 kernel/resource.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 158f04ec1d4f..c0f7ba0ece52 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -365,16 +365,16 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			break;
 	}
 
+	if (p) {
+		/* copy data */
+		res->start = max(start, p->start);
+		res->end = min(end, p->end);
+		res->flags = p->flags;
+		res->desc = p->desc;
+	}
+
 	read_unlock(&resource_lock);
-	if (!p)
-		return -1;
-
-	/* copy data */
-	res->start = max(start, p->start);
-	res->end = min(end, p->end);
-	res->flags = p->flags;
-	res->desc = p->desc;
-	return 0;
+	return p ? 0 : -ENODEV;
 }
 
 static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
-- 
2.20.1

