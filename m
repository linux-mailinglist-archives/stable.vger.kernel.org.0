Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A53767C4
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhEGPRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:17:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhEGPRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620400571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKfG4ipjhpjE8gWugYntFJwhsZ4EbLAHn7ALSOwInSM=;
        b=apzSlrhsynDLQFaz03MoIikuTzUMQH+VFfnh4jbyOjxxWL64U8EBrq+hAowKU0QeizaVMK
        H5h8d1tbJ/Do3PaxAdppYqzwMOWPA6azq7xSZtc0XpRYpWhymRj8m4adnJyhNguq5a4ZgK
        1qcc1TWUzcnBtqD3H4BkQtQVvd1gCtE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-3YWJWmVDOCGRbULT_GeJmA-1; Fri, 07 May 2021 11:16:09 -0400
X-MC-Unique: 3YWJWmVDOCGRbULT_GeJmA-1
Received: by mail-pg1-f197.google.com with SMTP id t2-20020a6344420000b02901fc26d75405so5582568pgk.20
        for <stable@vger.kernel.org>; Fri, 07 May 2021 08:16:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKfG4ipjhpjE8gWugYntFJwhsZ4EbLAHn7ALSOwInSM=;
        b=cEf/g84uPQnKYCQG5DX7mOVqyX2FHmieAUFVFIM6hdmwaaspnkX0JdAJfEfvnGnUyy
         s45m4lncVgJ/RLAR/Qm75LOYG9HAWTrafjKUTiTtXeSkAkodoANzUTyeM4i4N4+ig3bG
         0Ol1kYs5MqCaPUIdxkf5n5NRBleCBiJrts2NAqQ1DEzV4aHOVFWHmvdh22EhgIfi3C/n
         XDqJHpgTW2l8QvvGnUOBNZhAEakb/b4H3zJ2OlqTxqAaOoIicMfslmD+sAMl1DtXQCWJ
         qct/TDCyuFuI4W7NV+Dfxkvbsy97HOQNsaJhudnXbJq+944b+1s2PIctbw8g6VRsZOGd
         3JFg==
X-Gm-Message-State: AOAM530YhPktLJ6sc6gzyld0snwCSVri+R9y5NqQ1aiDIZcDWqwnJLI5
        HYy8YNp0/nBLvSmfDVwrPTqTfSPvmgkb0VryJ0XEuWMy6Wrv8dtEsWibcR3jn4hCt9xazBN0gef
        6krqSd3hzJaOvrrko
X-Received: by 2002:a17:90a:1b62:: with SMTP id q89mr24365324pjq.141.1620400568643;
        Fri, 07 May 2021 08:16:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXHizozEko/PdFJEJDgIjbnF6NgJaGcBVORjGNlCO9EDUgbPGBpJyP1+gU8DfNz2V59FQDag==
X-Received: by 2002:a17:90a:1b62:: with SMTP id q89mr24365297pjq.141.1620400568360;
        Fri, 07 May 2021 08:16:08 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i24sm4890851pfd.35.2021.05.07.08.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 08:16:07 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Gao Xiang <xiang@kernel.org>
Subject: [PATCH 4.19.y] erofs: add unsupported inode i_format check
Date:   Fri,  7 May 2021 23:15:45 +0800
Message-Id: <20210507151545.235017-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <162039576612327@kroah.com>
References: <162039576612327@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <xiang@kernel.org>

commit 24a806d849c0b0c1d0cd6a6b93ba4ae4c0ec9f08 upstream.

If any unknown i_format fields are set (may be of some new incompat
inode features), mark such inode as unsupported.

Just in case of any new incompat i_format fields added in the future.

Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: <stable@vger.kernel.org> # 4.19+
[ Gao Xiang: Manually backport to 4.19.y due to trivial conflicts. ]
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
Hi Greg,

Please consider this backport patch for 4.19 staging erofs.
(btw, I use xiang@kernel.org instead of @redhat.com here since
 I'll shift to Alibaba in weeks...)

Thanks,
Gao Xiang

 drivers/staging/erofs/erofs_fs.h | 3 +++
 drivers/staging/erofs/inode.c    | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index 7677da889f12..38f15e3d8ebb 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -71,6 +71,9 @@ enum {
 #define EROFS_I_VERSION_BIT             0
 __EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
 
+#define EROFS_I_ALL	\
+	((1 << (EROFS_I_DATA_MAPPING_BIT + EROFS_I_DATA_MAPPING_BITS)) - 1)
+
 struct erofs_inode_v1 {
 /*  0 */__le16 i_advise;
 
diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index a43abd530cc1..02398c7eb4a4 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -48,6 +48,12 @@ static struct page *read_inode(struct inode *inode, unsigned int *ofs)
 	v1 = page_address(page) + *ofs;
 	ifmt = le16_to_cpu(v1->i_advise);
 
+	if (ifmt & ~EROFS_I_ALL) {
+		errln("unsupported i_format %u of nid %llu", ifmt, vi->nid);
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	vi->data_mapping_mode = __inode_data_mapping(ifmt);
 	if (unlikely(vi->data_mapping_mode >= EROFS_INODE_LAYOUT_MAX)) {
 		errln("unknown data mapping mode %u of nid %llu",
-- 
2.27.0

