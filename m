Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042AA2E8531
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 18:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbhAAR0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 12:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbhAAR0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 12:26:38 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BEEC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 09:25:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x126so12675850pfc.7
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 09:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dK4DFEA9uE1+g1ysqpdtxeRlNjmXMnJk0nB110YHg6k=;
        b=NYnBiSY3C1lJfPkZXbi+VjchRhuhaFLh84/D/glI67G3TsgS0Cbu3NBIJg32rxVFqy
         NvHchhA8qmfXzgfCav7LkOrmsxNLeabyWIzdXnfFIO7UDBH4c8Bn1B+xqLeNTnp/AWvD
         mpsmunrMqLDj9gSlmwTQ/lVpcdcDs4LGNLcpVVBZSQZDzQLodU+VJBYe89VkYcBgnGVN
         HAfVPa2n+BFjTKeze2Yi0MFT41FJrd6sD9Gn0Ftsmqt1lOJYy9HpWq+kKrQfToYxRUZF
         9w5APAdtZZwALFFAiUvAAT6Naa/TgIQH7eQQnxCEo84xkiJWieBXY0pnPu8BKUrsskHH
         jrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dK4DFEA9uE1+g1ysqpdtxeRlNjmXMnJk0nB110YHg6k=;
        b=O4/ew7922hJfZnhr+Rt8+5EH2urGiS1IZp/VKH8TOm5c6HvJjZCFckKH60p8YA87Bf
         sSExap73hsf6IwRwZmjUJpxCVBfb6mtdydmMpsFXz01UnBv0cJEVC7BXLmmjabWBK2rL
         xZywi0XrASMSijLGmaq8bslOtGJpdJV5ds3SchAX7uX6qcMzCQSRPPZNpfKK8h2fVhRw
         BC/KgJ96hKhz9V5p8pLJmAP4IikPPKRO/G5n3LHpuuH3Du6sD4gQhMbLeiJws0Fyesn8
         BzLHoKqFYSjLymEW0jcK0QqfhaQa9p4jAjqfMzaXDcT17bh/2bfGbUPqJqnQd4Wg2Nrk
         g4eQ==
X-Gm-Message-State: AOAM530F1Ev4fqFm4+oF7AombJnfu83UJuoSHXDAb3/kdeggBW3WQ+P9
        hvkSlC87Met/QbCHZVX7pBLIibuZUXgM3vyk
X-Google-Smtp-Source: ABdhPJzqxzUhhojqKNAkSHWcd5ibw8huVMF1EsaeLcP4wEe5cgRuT12Gt0pWNO7oUKqPaFjqc/VRsg==
X-Received: by 2002:a65:5b0a:: with SMTP id y10mr59420871pgq.337.1609521957485;
        Fri, 01 Jan 2021 09:25:57 -0800 (PST)
Received: from [127.0.0.1] ([118.34.233.180])
        by smtp.gmail.com with ESMTPSA id nk11sm13889151pjb.26.2021.01.01.09.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 09:25:57 -0800 (PST)
From:   Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: [PATCH 4.19 bp] xen/gntdev.c: Mark pages as dirty
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Souptick Joarder <jrdr.linux@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        John Hubbard <jhubbard@nvidia.com>, stable@vger.kernel.org
References: <160413862539217@kroah.com>
Message-ID: <d4310d1f-8add-4074-ea4c-1c6b8276e79f@gmail.com>
Date:   Fri, 1 Jan 2021 17:25:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <160413862539217@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

commit 779055842da5b2e508f3ccf9a8153cb1f704f566 upstream.

There seems to be a bug in the original code when gntdev_get_page()
is called with writeable=true then the page needs to be marked dirty
before being put.

To address this, a bool writeable is added in gnt_dev_copy_batch, set
it in gntdev_grant_copy_seg() (and drop `writeable` argument to
gntdev_get_page()) and then, based on batch->writeable, use
set_page_dirty_lock().

Fixes: a4cdb556cae0 (xen/gntdev: add ioctl for grant copy)
Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1599375114-32360-1-git-send-email-jrdr.linux@gmail.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jinoh: backport accounting for missing
  commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")]
Signed-off-by: Jinoh Kang <jinoh.kang.kr@gmail.com>
---
 drivers/xen/gntdev.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 9d8e02cfd480..3cfbec482efb 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -842,17 +842,18 @@ struct gntdev_copy_batch {
 	s16 __user *status[GNTDEV_COPY_BATCH];
 	unsigned int nr_ops;
 	unsigned int nr_pages;
+	bool writeable;
 };
 
 static int gntdev_get_page(struct gntdev_copy_batch *batch, void __user *virt,
-			   bool writeable, unsigned long *gfn)
+				unsigned long *gfn)
 {
 	unsigned long addr = (unsigned long)virt;
 	struct page *page;
 	unsigned long xen_pfn;
 	int ret;
 
-	ret = get_user_pages_fast(addr, 1, writeable, &page);
+	ret = get_user_pages_fast(addr, 1, batch->writeable, &page);
 	if (ret < 0)
 		return ret;
 
@@ -868,9 +869,13 @@ static void gntdev_put_pages(struct gntdev_copy_batch *batch)
 {
 	unsigned int i;
 
-	for (i = 0; i < batch->nr_pages; i++)
+	for (i = 0; i < batch->nr_pages; i++) {
+		if (batch->writeable && !PageDirty(batch->pages[i]))
+			set_page_dirty_lock(batch->pages[i]);
 		put_page(batch->pages[i]);
+	}
 	batch->nr_pages = 0;
+	batch->writeable = false;
 }
 
 static int gntdev_copy(struct gntdev_copy_batch *batch)
@@ -959,8 +964,9 @@ static int gntdev_grant_copy_seg(struct gntdev_copy_batch *batch,
 			virt = seg->source.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = false;
 
-			ret = gntdev_get_page(batch, virt, false, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 
@@ -978,8 +984,9 @@ static int gntdev_grant_copy_seg(struct gntdev_copy_batch *batch,
 			virt = seg->dest.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = true;
 
-			ret = gntdev_get_page(batch, virt, true, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 
-- 
2.26.2

