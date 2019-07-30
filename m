Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E037B203
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 20:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfG3Sct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 14:32:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34656 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfG3Sct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 14:32:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so24278098pgc.1;
        Tue, 30 Jul 2019 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6fCIBt83Qg0xm9/csFeyeLFWARKqAMvTELcBmphTpo0=;
        b=JUA9FbUPr0F6xNgBd5J9MHwHtCHrMpBJuNDTvZBzKBZeCmNsbohHado2HBbGTi0It9
         yThD+OL5Bkf6Da9wJnEKF7n1ZuYfE+RCaAChBqmkI/jmB2QhloDai+ucTPidoKT2u6UQ
         29UC6QoAyrEf4tN2GNQniwXjZkr83rJH4ak6SFrbJFSb15jmyMBIWZiHh1EgvVH6j48q
         cZKmuIlqPfwxsnRzt4ye0SXQ2NpyGAmqO03R0RsRzNRYkzGXP/3U1W6hIGXqsFMnjHXR
         g7Xo3I2gA+uPgrVqyPZw3rp948eNJFIjP60aR0GcG/CsRV9BR7dafhIdCpB5PUi2sogn
         ixHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6fCIBt83Qg0xm9/csFeyeLFWARKqAMvTELcBmphTpo0=;
        b=H2MThA67qYPZW3whWUWmv1wpTsz4n7hsBi7YYWQkbmeHxkouQeztlHvj9RcEP2YNn/
         0bwbajJxRfrMD44wa89uP7Dyb0ZLNl8GeNHGMFpcsl+zjMR2/0U2MZM7xR2AfVVAOyyP
         ySAOjbAHq5an67cbAQy7/+z2qKgkxbKTBwA6mn+mjgOTCUEguZDzwTUJwLq1EQdqMeQA
         C68ov5HTq0IrrpgaJDl9nhbjTLPsm8vADBrGZVfxGaH97Spo4SRiaTOWjWOodtKarK/O
         HpxR9l51rzNZLJRkfV+VG+LPgCbl9Fu6klAwlX6yNdvW+rmj+2hV2SzigMnRpfOF5Rev
         DBiw==
X-Gm-Message-State: APjAAAVXcbBUhpFx6is2mQzzo94H1HRSnUYaALZaIcjlLU45TIMTGjCW
        3G0iro+5s8tdu7cTBDFZ+6E=
X-Google-Smtp-Source: APXvYqz3TKO5CR8bm9L/zAhw0K/5mmOOXYnkeug29AHRYcKaRz4UPuCN4Qa7WYzWXEa+PlUkZGXEBw==
X-Received: by 2002:a62:754d:: with SMTP id q74mr42050335pfc.211.1564511568653;
        Tue, 30 Jul 2019 11:32:48 -0700 (PDT)
Received: from jordon-HP-15-Notebook-PC.domain.name ([106.51.16.0])
        by smtp.gmail.com with ESMTPSA id j5sm57328671pgp.59.2019.07.30.11.32.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 11:32:47 -0700 (PDT)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, marmarek@invisiblethingslab.com
Cc:     willy@infradead.org, akpm@linux-foundation.org,
        linux@armlinux.org.uk, linux-mm@kvack.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] xen/gntdev.c: Replace vm_map_pages() with vm_map_pages_zero()
Date:   Wed, 31 Jul 2019 00:04:56 +0530
Message-Id: <1564511696-4044-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

'commit df9bde015a72 ("xen/gntdev.c: convert to use vm_map_pages()")'
breaks gntdev driver. If vma->vm_pgoff > 0, vm_map_pages()
will:
 - use map->pages starting at vma->vm_pgoff instead of 0
 - verify map->count against vma_pages()+vma->vm_pgoff instead of just
   vma_pages().

In practice, this breaks using a single gntdev FD for mapping multiple
grants.

relevant strace output:
[pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
[pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7, 0) =
0x777f1211b000
[pid   857] ioctl(7, IOCTL_GNTDEV_SET_UNMAP_NOTIFY, 0x7ffd3407b710) = 0
[pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
[pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7,
0x1000) = -1 ENXIO (No such device or address)

details here:
https://github.com/QubesOS/qubes-issues/issues/5199

The reason is -> ( copying Marek's word from discussion)

vma->vm_pgoff is used as index passed to gntdev_find_map_index. It's
basically using this parameter for "which grant reference to map".
map struct returned by gntdev_find_map_index() describes just the pages
to be mapped. Specifically map->pages[0] should be mapped at
vma->vm_start, not vma->vm_start+vma->vm_pgoff*PAGE_SIZE.

When trying to map grant with index (aka vma->vm_pgoff) > 1,
__vm_map_pages() will refuse to map it because it will expect map->count
to be at least vma_pages(vma)+vma->vm_pgoff, while it is exactly
vma_pages(vma).

Converting vm_map_pages() to use vm_map_pages_zero() will fix the
problem.

Marek has tested and confirmed the same.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
 drivers/xen/gntdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4c339c7..a446a72 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1143,7 +1143,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto out_put_map;
 
 	if (!use_ptemod) {
-		err = vm_map_pages(vma, map->pages, map->count);
+		err = vm_map_pages_zero(vma, map->pages, map->count);
 		if (err)
 			goto out_put_map;
 	} else {
-- 
1.9.1

