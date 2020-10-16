Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DDC29091C
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410538AbgJPQCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410536AbgJPQCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:02:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F46C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:02:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b23so1715114pgb.3
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i8vLa7j2VsDkihuVMSn79b97TmtiaDu9FOviID5/RNw=;
        b=VamWPnULoc5uN441DwQoQC09fRhq7hPFijWfq04eist9vbM2ltT8/Z/AN7TZc8MRjC
         MVsbBA/UQ46Vft4UDLFTdFLxB6C7U2r1o/S26R+d9VC7s9ZorZaPMnAxHuBMBTJCEU1+
         o5RhDTm9UL3aDRNf6b4BEYHGBBknzeCalwTZlh9s7hygZTh4KjUVdvSjBtDta3LBT+Io
         6zsqtBKPLgVC+5vjQZoINPE/KmRMxuRQU8SMTsOi/PvDur11JYE9fiXe3NrUQhD7F8eA
         PKbjvV7pDPV7POM1pSgagAl+VDZGO9hV2Z/S7xE638cP53Z6paPQJGZX9KKzRkhJX2M+
         qU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i8vLa7j2VsDkihuVMSn79b97TmtiaDu9FOviID5/RNw=;
        b=B+rMI2Y9NL5hiYFAiY6VCdjalEcxGjm/7uH24UKq3JqEbX3BLgxj+g2rBDBSCt8cKo
         V/0cvJaPo0XJ0lePD3Nj3hTePawTtdRa4jnN8YrIDPCcz1BvCh/VcAlIStJS1L48bH/u
         yckZMwxgWHkEaEv3u79yZRvrv5BUqya8wTn8098jjHW8kNoEND3nIC8zSjx2n/HWJQkn
         nkkQY8DlwV831tPNLvju8/sjWpmscN2QfW53xXblvhaZ0ZJs/N4i3eHlsAgTWbs4QAZe
         lHTbFR/5d23UohrRHMyfGdSRvAxcFONvr8YlTbdE0BymV/bdQLn/0nr5dXTI7OwG8/cJ
         rJVA==
X-Gm-Message-State: AOAM531hhzk6m5wOtPTWhuZNJ/pXSdy8uz96RPUr/vAsfVqMxkQigqfg
        3DzyiLnspeTpMtK4ZiUodx30bIHImCV8yxRK
X-Google-Smtp-Source: ABdhPJzq1kkRCgy0cHxOLRhHiIM4SQBx+NP8BnV7qY4DHX/c9Tb4YNXnDz92UOfwuXhEWwgJ5+pseQ==
X-Received: by 2002:aa7:9483:0:b029:155:cde2:f719 with SMTP id z3-20020aa794830000b0290155cde2f719mr4640360pfk.31.1602864162762;
        Fri, 16 Oct 2020 09:02:42 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 11/18] io-wq: assign NUMA node locality if appropriate
Date:   Fri, 16 Oct 2020 10:02:17 -0600
Message-Id: <20201016160224.1575329-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There was an assumption that kthread_create_on_node() would properly set
NUMA affinities in terms of CPUs allowed, but it doesn't. Make sure we
do this when creating an io-wq context on NUMA.

Cc: stable@vger.kernel.org
Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0a182f1333e8..149fd2f0927e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -676,6 +676,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		kfree(worker);
 		return false;
 	}
+	kthread_bind_mask(worker->task, cpumask_of_node(wqe->node));
 
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
-- 
2.28.0

