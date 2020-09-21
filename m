Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53483273046
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgIURDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:03:49 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34456 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgIURDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 13:03:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id v23so11756222ljd.1;
        Mon, 21 Sep 2020 10:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KRR0d26+lv+hpyLyR4lyNxvuZiKRKv6y1J0EbtzU4fs=;
        b=HJDhBE+JFPp8761gfXeYtvss4ex9MFlICXq6cD3167plWPOFgSq4C+B8NwF2YNOuem
         UA2jydxTFIGqIFm0+PVlXDlWba9y3xhr0nB+gAvXFqbv0tP6Om1nOrNGuPWg0BsNsx/L
         xAg5bbEEEA8YeNz+2lD7RXnj3Z2Bec+RAagTDuMt3lCs8P2cXF3Us0jIXu7DRiIO49tZ
         HipGOKsemBAgeDFiJXyxz1iskH+R68BdrWUUnTewQJJ63J2nZ9zDKEhE6TCo/MLM5dYl
         +XJq9kyLWDiJwyZVq6znkaAq0J4qHqYShRJgelVhg783StQiBhcGDh+AbiLanLswEu9f
         hP3w==
X-Gm-Message-State: AOAM531yCOOZai+xq1HznoISGPdEtvozXXEhLc5v/6jv6fX1wnDRmG/i
        59FPIM3dOy8V3fOeuV8PWYjpsOr0GMQ=
X-Google-Smtp-Source: ABdhPJyj34Eo5V5MdpVrUQr3VVHHcLF52RGw9/hT3G8Uf4YvrPZ45oWx1pweV5nDeUmDPYkNreb8Qw==
X-Received: by 2002:a2e:9218:: with SMTP id k24mr198643ljg.306.1600707825427;
        Mon, 21 Sep 2020 10:03:45 -0700 (PDT)
Received: from green.intra.ispras.ru (winnie.ispras.ru. [83.149.199.91])
        by smtp.googlemail.com with ESMTPSA id c22sm2689992lff.202.2020.09.21.10.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 10:03:44 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     David Sterba <dsterba@suse.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()
Date:   Mon, 21 Sep 2020 20:03:35 +0300
Message-Id: <20200921170336.82643-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

btrfs_ioctl_send() used open-coded kvzalloc implementation earlier.
The code was accidentally replaced with kzalloc() call [1]. Restore
the original code by using kvzalloc() to allocate sctx->clone_roots.

[1] https://patchwork.kernel.org/patch/9757891/#20529627

Cc: stable@vger.kernel.org
Fixes: 818e010bf9d0 ("btrfs: replace opencoded kvzalloc with the helper")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d9813a5b075a..c874ddda6252 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7181,7 +7181,7 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 
 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
 
-	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);
+	sctx->clone_roots = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.26.2

