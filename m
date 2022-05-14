Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05C45270FB
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiENMJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 08:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiENMJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 08:09:11 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7A7F29;
        Sat, 14 May 2022 05:09:10 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 202so9830630pgc.9;
        Sat, 14 May 2022 05:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Go1aD/L4/NwaeqwABKS0DOpnE/e7XYIGVtitFbk6RI=;
        b=cr9B1ubSgoeNa8HWa7DlBZUE2aIGzxa/fMzmsqxGuFWTN4UmNNvz857LoKZijhKS73
         W94vlm1Qry889tH1VHyyOFrX9JT8eFwG7MhxKo7FjHVUfcF+BBtheAs1gHMHk6j0gu9E
         WfdXuX0nSe3jFm/zdabCkUyZfJ8LT0VlVWPqNfZ0F3EJSARY0f7g4rLV6NTdVGhVYN2/
         QMSMwR1GRa57XLDVSV8QRD5YEgvTzLvvY4JcwFLoVZSgzs4Bk3tepYCIUupebUYD42LT
         Xot6pF1h0QXPDL2eB6OEQMDAf7NNzC7Pt6sogOdxstMVGSigs/T26LlTQ1MwZFllXfQ5
         8ZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Go1aD/L4/NwaeqwABKS0DOpnE/e7XYIGVtitFbk6RI=;
        b=ekBX7ujU6jMSv6uFX2zzXLSKPRACK2oLtvlfz3GRNqsjWYGW+3CI59h29dKlmgxWXl
         xf45MWPrKtMj8UUWweI/w+XauBjOT/DCXHi7xIpp69O/mtXHnVwZ2vUjHINjIDJ7n6BP
         h4Lr/CVbP51FozzTM4WiDtLzeMjbX7B78Yoq08+c0r86WrO1v0eGYcaF9/tUSuuwGDk3
         BMTFEPOs7QOR6iZbdSNeTq6AMvKR8Emgv0LstrQzQdae0+E4X4fTx7OszLoYksZguyXM
         f2PAEWbE4Ki3yx+HMYaQJ2CkQYxZ9NMhR8RXJNvn+kh8oMXhYd1Yej9oWm7KNFjfR+TM
         321Q==
X-Gm-Message-State: AOAM530+l39JfWrW5DEV5DgyvRgv3G0h7f8a3H8JyBDqma3zv2xt61vJ
        JEr2J9UFxjzpWZSrtcy4YXU6gL0lphw=
X-Google-Smtp-Source: ABdhPJxIFGUTGYOAyPcmNz7UCTfE17jXAclddbJBz9rYIifOloe2Yp+ZX4La1h+1ilezeoi/436n6A==
X-Received: by 2002:a63:8841:0:b0:3db:2e5f:1271 with SMTP id l62-20020a638841000000b003db2e5f1271mr7824710pgd.233.1652530150033;
        Sat, 14 May 2022 05:09:10 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id z4-20020a62d104000000b0050dc7628184sm3528728pfg.94.2022.05.14.05.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 05:09:09 -0700 (PDT)
Date:   Sat, 14 May 2022 17:39:04 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v3 1/5] ext4: fix memory leak in
 parse_apply_sb_mount_options()
Message-ID: <20220514120904.xbbfyne32lp47t2p@riteshh-domain>
References: <20220513231605.175121-1-ebiggers@kernel.org>
 <20220513231605.175121-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513231605.175121-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/05/13 04:16PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> If processing the on-disk mount options fails after any memory was
> allocated in the ext4_fs_context, e.g. s_qf_names, then this memory is
> leaked.  Fix this by calling ext4_fc_free() instead of kfree() directly.

Thanks for splitting the patch. It becomes an easy backport.

>
> Reproducer:
>
>     mkfs.ext4 -F /dev/vdc
>     tune2fs /dev/vdc -E mount_opts=usrjquota=file
>     echo clear > /sys/kernel/debug/kmemleak
>     mount /dev/vdc /vdc
>     echo scan > /sys/kernel/debug/kmemleak
>     sleep 5
>     echo scan > /sys/kernel/debug/kmemleak
>     cat /sys/kernel/debug/kmemleak

Tested this and as you mentioned this patch fixes the memory leak with
s_qf_names in note_qf_name().

tune2fs 1.46.5 (30-Dec-2021)
Setting extended default mount options to 'usrjquota=file'
unreferenced object 0xffff8881126b9a50 (size 8):
  comm "mount", pid 1475, jiffies 4294829180 (age 48.670s)
  hex dump (first 8 bytes):
    66 69 6c 65 00 6b 6b a5                          file.kk.
  backtrace:
    [<ffffffff8153b09d>] __kmalloc_track_caller+0x17d/0x2f0
    [<ffffffff8149b7e8>] kmemdup_nul+0x28/0x70
    [<ffffffff81753a75>] note_qf_name.isra.0+0x95/0x180
    [<ffffffff817548a8>] ext4_parse_param+0xd48/0x11c0
    [<ffffffff8175a131>] ext4_fill_super+0x1cc1/0x6260
    [<ffffffff8155edce>] get_tree_bdev+0x24e/0x3a0
    [<ffffffff81740355>] ext4_get_tree+0x15/0x20
    [<ffffffff8155d3a2>] vfs_get_tree+0x52/0x140
    [<ffffffff815a2048>] path_mount+0x3f8/0xf30
    [<ffffffff815a2c52>] do_mount+0xd2/0xf0
    [<ffffffff815a2e4a>] __x64_sys_mount+0xca/0x110
    [<ffffffff82e6674b>] do_syscall_64+0x3b/0x90
    [<ffffffff8300007c>] entry_SYSCALL_64_after_hwframe+0x44/0xae


Feel free to add by -

Tested-by: Ritesh Harjani <ritesh.list@gmail.com>

-ritesh

>
> Fixes: 7edfd85b1ffd ("ext4: Completely separate options parsing and sb setup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/ext4/super.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1466fbdbc8e34..60fa2f2623e07 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2625,8 +2625,10 @@ static int parse_apply_sb_mount_options(struct super_block *sb,
>  	ret = ext4_apply_options(fc, sb);
>
>  out_free:
> -	kfree(s_ctx);
> -	kfree(fc);
> +	if (fc) {
> +		ext4_fc_free(fc);
> +		kfree(fc);
> +	}
>  	kfree(s_mount_opts);
>  	return ret;
>  }
> --
> 2.36.1
>
>
>
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
