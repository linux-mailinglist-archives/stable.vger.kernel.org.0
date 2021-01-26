Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F0E304A4A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbhAZFH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732401AbhAZDSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 22:18:15 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05037C061756
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:17:36 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t25so2704107pga.2
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtFgKdR1zjiiMUBUqPm6k1kFKyYgh6EYu3v9cVSqtNg=;
        b=sF2eUBaye/dI0ORb+IJysE7/kIYxkBm/QMObpU+MUJZOrBp6kYvodeYp2+/6R4d8Ky
         veYIGeTldP9GIH+ZjLtGdEYpDt5BQG1w3Db2expTGEvQKwojiz/U3M6jWPQiesrZ4r4L
         U1kRgxxLL/gkrH4xPOfrVpjmFtrqnGINACEaC+Qe90jkH5vT2mlrfRCuK9fI8q/+acJX
         DLnNw8/xEW9x/ie/wPvyN3tGT3zco2Ml8BrNoO9CjaqvPFZClPS0aAUqesDvlB8fVmBk
         /HPpJXB2Pl0CmkgOoEKVIAjPJBLgLRT+aIZbTtnlj8QHIGzfdEpHF62I1IIIeIA04SIQ
         OyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtFgKdR1zjiiMUBUqPm6k1kFKyYgh6EYu3v9cVSqtNg=;
        b=rt71AnjbgP671KnQt3izI3mo0sj5+Tq8+mlgZFPWl/CbMbZ7lzOJZGL2XlXdBH8WWA
         CmFf549wTiS0PzC2LnC/3iYF5aAbt+VKI9OSXqC1UVB9DZxT4/KdvS8H55DLHuGiJpUs
         bKQHQZei8qFwj7xr0Q70rcVxLFEOdD4Lcd4lHJVvhDyLuRfGyiEEA9ZZlES8S/gsfg3/
         QjYwJBKDJ747CeXoOPPXauLcBITes3dw2efhVc/RpJGLooyYgbX7bp6E+bd3qNBvpBkw
         2sk51eEyd5rMeHPsPjr6gIIaOZX4ndtoUsxgLn4xlYaiCuz2coGSINTQ+1u0TgYAVuwI
         29/w==
X-Gm-Message-State: AOAM532qGS6ru9/hH+WfimfMUp+bUru37mD7ihGbRXi6K9qx6uEjTmZm
        YjLa/KU5QeXd969X+Avd8R0b3w==
X-Google-Smtp-Source: ABdhPJwWnnS4E0Ae7GCEUQPpPqdK8Q740j7chsbzcZJz2wQZQj2JkkLhhH44+ynxVV8IrPQkZt85CA==
X-Received: by 2002:a62:1c84:0:b029:1c4:f959:7b29 with SMTP id c126-20020a621c840000b02901c4f9597b29mr61452pfc.34.1611631055566;
        Mon, 25 Jan 2021 19:17:35 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.236])
        by smtp.gmail.com with ESMTPSA id m195sm18419305pfd.215.2021.01.25.19.17.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jan 2021 19:17:34 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     sh_def@163.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH] mm: hugetlb: fix missing put_page in gather_surplus_pages()
Date:   Tue, 26 Jan 2021 11:10:09 +0800
Message-Id: <20210126031009.96266-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VM_BUG_ON_PAGE avoids the generation of any code, even if that
expression has side-effects when !CONFIG_DEBUG_VM.

Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a6bad1f686c5..082ed643020b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2047,13 +2047,16 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		int zeroed;
+
 		if ((--needed) < 0)
 			break;
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
+		zeroed = put_page_testzero(page);
+		VM_BUG_ON_PAGE(!zeroed, page);
 		enqueue_huge_page(h, page);
 	}
 free:
-- 
2.11.0

