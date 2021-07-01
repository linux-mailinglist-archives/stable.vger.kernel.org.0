Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F403B9657
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 21:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhGATGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 15:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhGATGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 15:06:34 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9132C061764
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 12:04:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p8so9561318wrr.1
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 12:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2mF4CgjTyVudbD7ygUEiLBglI08H8gi6QxxHLGYQMtY=;
        b=JApAqMj51pCad99Ly6MbX6uIm6u/ASo23XSiY4bD/b7ixZANyP6IfKW8fehwSt7iHc
         ZNylONgcerC6b6n1tAznwEc+95hd2F57hVWRQqPnUuEBRV+ZP/8gRNPYqX/U6QIfWPjc
         klOepB2Sc8RwXMHGtJ8i45qFgEPvdictR+ZqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2mF4CgjTyVudbD7ygUEiLBglI08H8gi6QxxHLGYQMtY=;
        b=QeRGO00f2NQfpv8qEtj2zdLsIOlctddUWUZ2+SNyCJyehdGO5YaFD4vhczw5U5vQxD
         uwrhDK1zfkeErwAEV4ZT5G3GYuxsFJaivDy9pASNEACh5FxeKl+Y6dem2G6LaEQDXTF5
         5hXnKKCuKxDEtWzZRBWpqDB7dF2xCaAf02s2B+g1jlAAMgVpRXjB8OKoHZ75paVosclm
         9e6DhoODgTYsFfMLtXHvtYPljBYCSrAxHMYDNrb6lRQVPiJLEIVR8ltsbuknDeQr1gKg
         ujjfE1DSkk7ODKrDECrly+Kgr+zGAkk4i0RCyOvoWAA29yi0RMLdY/oEh9y3d/n1dWAv
         yhmQ==
X-Gm-Message-State: AOAM531PKJ1xyLSlEzBSL8sQ/96tSRmAO69zJdMhQ0qZnv06IDSSqB+H
        TnuqFSeVrRGNVkFO1SEmVuR/vw==
X-Google-Smtp-Source: ABdhPJzdfRjxbtK4ANx7iJYWsxqGu9wGcDrjrIvmFRQ68knYS49hWOqe8dLxygcSZKTSUkIG8jrjzw==
X-Received: by 2002:a05:6000:18ca:: with SMTP id w10mr1342572wrq.55.1625166242211;
        Thu, 01 Jul 2021 12:04:02 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:63de:dd93:20be:f460])
        by smtp.gmail.com with ESMTPSA id u12sm822458wrr.40.2021.07.01.12.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 12:04:01 -0700 (PDT)
Date:   Thu, 1 Jul 2021 20:04:00 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, flrncrmr@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Message-ID: <YN4RoCAWq5SMXmaN@chrisdown.name>
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
 <20210611004024.2925-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210611004024.2925-1-namjae.jeon@samsung.com>
User-Agent: Mutt/2.1 (4b100969) (2021-06-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Namjae Jeon writes:
>The compatibility issue between linux exfat and exfat of some camera
>company was reported from Florian. In their exfat, if the number of files
>exceeds any limit, the DataLength in stream entry of the directory is
>no longer updated. So some files created from camera does not show in
>linux exfat. because linux exfat doesn't allow that cpos becomes larger
>than DataLength of stream entry. This patch check DataLength in stream
>entry only if the type is ALLOC_NO_FAT_CHAIN and add the check ensure
>that dentry offset does not exceed max dentries size(256 MB) to avoid
>the circular FAT chain issue.
>
>Fixes: ca06197382bd ("exfat: add directory operations")
>Cc: stable@vger.kernel.org # v5.9
>Reported-by: Florian Cramer <flrncrmr@gmail.com>
>Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
>Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>

Tested-by: Chris Down <chris@chrisdown.name>

Thanks, I came across this while debugging why directories produced on my Fuji 
X-T4 were truncated at 2^12 dentries.

If the other report was also Fuji, maybe this is worth asking them to fix in 
firmware?

>---
> fs/exfat/dir.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
>index c4523648472a..f4e4d8d9894d 100644
>--- a/fs/exfat/dir.c
>+++ b/fs/exfat/dir.c
>@@ -63,7 +63,7 @@ static void exfat_get_uniname_from_ext_entry(struct super_block *sb,
> static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_entry *dir_entry)
> {
> 	int i, dentries_per_clu, dentries_per_clu_bits = 0, num_ext;
>-	unsigned int type, clu_offset;
>+	unsigned int type, clu_offset, max_dentries;
> 	sector_t sector;
> 	struct exfat_chain dir, clu;
> 	struct exfat_uni_name uni_name;
>@@ -86,6 +86,8 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
>
> 	dentries_per_clu = sbi->dentries_per_clu;
> 	dentries_per_clu_bits = ilog2(dentries_per_clu);
>+	max_dentries = (unsigned int)min_t(u64, MAX_EXFAT_DENTRIES,
>+					   (u64)sbi->num_clusters << dentries_per_clu_bits);
>
> 	clu_offset = dentry >> dentries_per_clu_bits;
> 	exfat_chain_dup(&clu, &dir);
>@@ -109,7 +111,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
> 		}
> 	}
>
>-	while (clu.dir != EXFAT_EOF_CLUSTER) {
>+	while (clu.dir != EXFAT_EOF_CLUSTER && dentry < max_dentries) {
> 		i = dentry & (dentries_per_clu - 1);
>
> 		for ( ; i < dentries_per_clu; i++, dentry++) {
>@@ -245,7 +247,7 @@ static int exfat_iterate(struct file *filp, struct dir_context *ctx)
> 	if (err)
> 		goto unlock;
> get_new:
>-	if (cpos >= i_size_read(inode))
>+	if (ei->flags == ALLOC_NO_FAT_CHAIN && cpos >= i_size_read(inode))
> 		goto end_of_dir;
>
> 	err = exfat_readdir(inode, &cpos, &de);
>-- 
>2.17.1
>
