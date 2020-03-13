Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9015B18503A
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 21:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCMUYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 16:24:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37178 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 16:24:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id 6so13719382wre.4
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 13:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9rZmXdTWd9f0ePIZx+QrXIJkyVkIFjODOPXoxfSpFtc=;
        b=B/b8VBIKsLMM9i3L2szc07BbRhs/ccJckCGNIJ0Xor8Cmio2bwzX6ixsCs78FPfzwq
         ZE5f//Y1xuf0X9iYAg5reB/tkfGKy/CFTuFZhcVeIjxW8x5CbxqJ+gfT9u6OOJnmPF6Y
         cuSIhJFtgXQh8rXg1K5ASi/F3yRHq6C6vKdRXuhT/g2JdDBa7J1t7l8xokmQjdgylEhx
         or30DtGzsFcQBYUOsKgQwVUiGcmgK2fBQITTghk63pb8lubRR/5wJKqdyx3SoxUjiotR
         axG5rsys3c6iZohSHPwHeE/r9TcVVbZHcWZdY83EXwl0DoMwYZ5MPocVI3/piEyMvP2v
         gdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9rZmXdTWd9f0ePIZx+QrXIJkyVkIFjODOPXoxfSpFtc=;
        b=Yu61Q0+TCds/MWZIpCMlIlIfRgtosa9/pSaTgnAcdDdzHWDkUyie3pBUsaRszjrEMZ
         6tLXXo36+G1736xv7pDaoli4tJXD4joavRfwtNS7UYQ5CCbO0K8Dv5QpTH3PAtUCKADA
         TFyU4+I9jBq2xHfvl80p4FBUYmMJ1vGSBcPfNcjfqd0/KIWhRGJf70SukX3lCE76VHyN
         /X1fePfJA6CZEJcFhHoxZGB3fpjM8u6ZS+XRy4P5Ec7KLkUcmozCIz7T0rZTqat7n5zo
         Uda78zV//EiEdKScL40eJyEFzNVE3LKGH3IExE11/7jk8tXKuVZtKQ1Hq5YA7By1ehE8
         MIvQ==
X-Gm-Message-State: ANhLgQ0UM5LWTZnSxXG7U+KLp40N9kU63SWpK64ymvNHEljcyO+/kErB
        FlZ1UPTYDtnzX6OqYeYLfEfLAvT+zsd5QA==
X-Google-Smtp-Source: ADFU+vsQbf9kngOOgPp1khhjPXZRBtp/QZ5v1vIQZmp7BZutGCaVe591L2BeyCC5NKpGbteiruAaHg==
X-Received: by 2002:adf:fa4c:: with SMTP id y12mr11939887wrr.392.1584131093336;
        Fri, 13 Mar 2020 13:24:53 -0700 (PDT)
Received: from ntb.Speedport_W_921V_1_46_000 (p57AF9474.dip0.t-ipconnect.de. [87.175.148.116])
        by smtp.googlemail.com with ESMTPSA id b141sm19193421wme.2.2020.03.13.13.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:24:52 -0700 (PDT)
From:   Petr Malat <oss@malat.biz>
To:     stable@vger.kernel.org, security@kernel.org
Cc:     Petr Malat <oss@malat.biz>
Subject: [PATCH] NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array
Date:   Fri, 13 Mar 2020 21:24:43 +0100
Message-Id: <20200313202443.2539-1-oss@malat.biz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Array is mapped by nfs_readdir_get_array(), the further kmap is a result
of a bad merge and should be removed.

This resource leakage can be exploited for DoS by receptively reading
a content of a directory on NFS (e.g. by running ls).

Fixes: 67a56e9743171 ("NFS: Fix memory leaks and corruption in readdir")
Signed-off-by: Petr Malat <oss@malat.biz>
---
 fs/nfs/dir.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c2665d920cf8..2517fcd423b6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		goto out_label_free;
 	}
 
-	array = kmap(page);
-
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
 		goto out_release_array;
-- 
2.20.1

