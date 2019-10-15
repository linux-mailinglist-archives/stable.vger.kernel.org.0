Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F59D80EB
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfJOUZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 16:25:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36682 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfJOUZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 16:25:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id j11so10130712plk.3;
        Tue, 15 Oct 2019 13:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6sUvpr0WehID8pP80ZhvLsnSYvQFqygK8r5rIP0jlhs=;
        b=lFw2H/d04tmnSUjS0uTmjPBEjbFYOOyTyG77Xpn90x3mUDRTuX2S1ZORxoelbYIBEV
         LxjXWKMg2mT1TOerkntyXB/2ZFZHIs8BFe5kI+FprTdedjNGUj+2n7uylGLqklxo2V/U
         E5003/iZC5RxGhMo7oMubgy1yOIdZKNg0qb9XfcJB3hVcmMs8VICx7Ma9/mfDCTH14FL
         GuAdgFvyEazpfFYeMFcL75VcLxUMM/gxzL+pYE8rk1awzAP6j2VZIcDrcDgVbmKy5bOS
         L+zbTMbAPHo0cZ8DYmyZ7mgoLOHjK5vp2fwoOY95Rh1o+SCRFRc4Wo0JkvgzgqkHn2Zg
         02uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6sUvpr0WehID8pP80ZhvLsnSYvQFqygK8r5rIP0jlhs=;
        b=F4v3+MHVNPtilm1RWn0AYiBCi0gbpYlmNW8xexMVY0AGBqSPqnr2rh3+1ne4gf01YR
         ZllaUK0VxAM9MDhO/7bNoQWyCAMWopXfoNpI+jnNmZK1Q3suMvv5WRvMPSUgPhrOfDvF
         MBrud8k5mDvESA4GCjItPvZRhwZjrk/3aUpkaNNAPYmCs1/98XOFJBI8g4zvEJ2CyF4c
         lGbqxCwz67s/b4GKKtIL/7JwGROONpmIhdyglMhGAMnkqpJ8uWrNfcfw27voRM2hWDIb
         Xg6/2LDFW7Wl1bYSEj0l8Nl+pey2o33kjHRG1o2D93TZty23pznWyCsLqCzC6xLJ9aiy
         3Vmw==
X-Gm-Message-State: APjAAAXdiH15D/2zoaC9DjfcTMNfgGdu5nGl3fTsa5he+sWpq1jTv3/i
        DEtkB2/LZp0/ZezAA2/HBIg=
X-Google-Smtp-Source: APXvYqwtfk//M4xoUiQ5GTOjTRH/d8dzRFbzMN73Qrnf7vvxbxpNaMTZrjExHyKgYQcjHbM4zH32sg==
X-Received: by 2002:a17:902:b70f:: with SMTP id d15mr37719790pls.210.1571171108389;
        Tue, 15 Oct 2019 13:25:08 -0700 (PDT)
Received: from google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id u65sm18851477pgb.36.2019.10.15.13.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 13:25:07 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:25:05 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Chen Wandun <chenwandun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] zram: fix race between backing_dev_show and
 backing_dev_store
Message-ID: <20191015202505.GA246210@google.com>
References: <1571046839-16814-1-git-send-email-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571046839-16814-1-git-send-email-chenwandun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:53:59PM +0800, Chen Wandun wrote:
> From: Chenwandun <chenwandun@huawei.com>
> 
> CPU0:				       CPU1:
> backing_dev_show		       backing_dev_store
>     ......				   ......
>     file = zram->backing_dev;
>     down_read(&zram->init_lock);	   down_read(&zram->init_init_lock)
>     file_path(file, ...);		   zram->backing_dev = backing_dev;
>     up_read(&zram->init_lock);		   up_read(&zram->init_lock);
> 
> get the value of zram->backing_dev too early in backing_dev_show,
> that will result the value may be NULL at the begining, and not
> NULL later.
> 
> backtrace:
> [<ffffff8570e0f3ec>] d_path+0xcc/0x174
> [<ffffff8570decd90>] file_path+0x10/0x18
> [<ffffff85712f7630>] backing_dev_show+0x40/0xb4
> [<ffffff85712c776c>] dev_attr_show+0x20/0x54
> [<ffffff8570e835e4>] sysfs_kf_seq_show+0x9c/0x10c
> [<ffffff8570e82b98>] kernfs_seq_show+0x28/0x30
> [<ffffff8570e1c580>] seq_read+0x184/0x488
> [<ffffff8570e81ec4>] kernfs_fop_read+0x5c/0x1a4
> [<ffffff8570dee0fc>] __vfs_read+0x44/0x128
> [<ffffff8570dee310>] vfs_read+0xa0/0x138
> [<ffffff8570dee860>] SyS_read+0x54/0xb4
> 
> Signed-off-by: Chenwandun <chenwandun@huawei.com>

It should be stable material.
Cc: <stable@vger.kernel.org> [4.14+]
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!
