Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E36D0A87
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjC3P6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjC3P6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:58:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6B9A7
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680191835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sP9rqjignnWh2VSPIiMl4HPMQh9/IMP3JUMCK79G4dM=;
        b=RdtugMfMVsk9A/nF3Gb3lM1Zdt/KrsUxOCUlQx1Jvbue8RL7jLzC5qp0YGeBPFp58iz9qq
        kY8EktRFg7pccTTYtt0RBr9rvAvDYNtcCLoZ0JGRoEwEK0xqguarlpRKLayYiYfhIeYr+G
        SXXzXcZU0zmagoqBFcaleCmeCP4KTkE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-OzSDnyiDNR6DJiEY9tsdBg-1; Thu, 30 Mar 2023 11:57:14 -0400
X-MC-Unique: OzSDnyiDNR6DJiEY9tsdBg-1
Received: by mail-qv1-f69.google.com with SMTP id j15-20020a0cc34f000000b005c824064b10so8456338qvi.17
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680191832; x=1682783832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sP9rqjignnWh2VSPIiMl4HPMQh9/IMP3JUMCK79G4dM=;
        b=rbaZ1CVeRSGgYcdgFuCZfeJPWAbVnM3CH/xlHji3VarB7TxZMvVTnZi4SE6vqeXVPW
         aV6L+CNG17B7QwsuYeBxmdzrR/87WexNeSrNIERlJYSHnyynij8J68o11cWCborZ2S53
         ndYBXfJPyNnMuq8OOsuN7m2dSlYhuV7keEnmfWQMx7TX7t5COU1Sq+dqLsQRf4w7/sQY
         J1AuciBJTe1LI5y6nTtZ5S//RiLWl5Lgby9Zc5ajJzgaO2zl93aR5OMVMe7jBahpFZ6u
         zU9Y+PLUpQ/bEQbsMtfyWbo7LpEHCMWIV0YH+VsRf56GiUFxaHdNGPlhG6/UZcC+0hRN
         0opw==
X-Gm-Message-State: AO0yUKXNzFSUlr9GO+bZ8hHgzFIvPnBZ1mAsKKjD2IOxdMJXcWpNPvtW
        Jg1Nh+EVhr98EK3I3+Jc6h73aX3UNkRgyjVIShRq2BX76mPgMB7OnXiAnSJ0rxJJyHk3nAIE4pU
        pa5NRWAP2+VDNOODb
X-Received: by 2002:a05:622a:1981:b0:3dc:483f:9c82 with SMTP id u1-20020a05622a198100b003dc483f9c82mr36684503qtc.0.1680191832426;
        Thu, 30 Mar 2023 08:57:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set+XjaORt6GiFu74wzWerLNgGw4I0eI596quziToVBJF2U76yQS3mN30JraI0EQ6rxzmNnxCxA==
X-Received: by 2002:a05:622a:1981:b0:3dc:483f:9c82 with SMTP id u1-20020a05622a198100b003dc483f9c82mr36684482qtc.0.1680191832185;
        Thu, 30 Mar 2023 08:57:12 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a0d4a00b0074281812276sm13059380qkl.97.2023.03.30.08.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:57:10 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized features"
Date:   Thu, 30 Mar 2023 11:56:39 -0400
Message-Id: <20230330155707.3106228-2-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230330155707.3106228-1-peterx@redhat.com>
References: <20230330155707.3106228-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a proposal to revert commit 914eedcb9ba0ff53c33808.

I found this when writting a simple UFFDIO_API test to be the first unit
test in this set.  Two things breaks with the commit:

  - UFFDIO_API check was lost and missing.  According to man page, the
  kernel should reject ioctl(UFFDIO_API) if uffdio_api.api != 0xaa.  This
  check is needed if the api version will be extended in the future, or
  user app won't be able to identify which is a new kernel.

  - Feature flags checks were removed, which means UFFDIO_API with a
  feature that does not exist will also succeed.  According to the man
  page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
  unknown features passed in.

Link: https://lore.kernel.org/r/20220722201513.1624158-1-axelrasmussen@google.com
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 fs/userfaultfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 8395605790f6..3b2a41c330e6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1977,8 +1977,10 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	/* Ignore unsupported features (userspace built against newer kernel) */
-	features = uffdio_api.features & UFFD_API_FEATURES;
+	features = uffdio_api.features;
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;
-- 
2.39.1

