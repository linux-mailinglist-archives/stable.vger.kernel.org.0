Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554476330D5
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 00:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiKUXmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 18:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiKUXmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 18:42:15 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB405DDF8E
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 15:41:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b29so12737759pfp.13
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 15:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zZc5xOP0xJFdkWXLW4Eh/g4pOZDZTjhdnyoqBFnt7HE=;
        b=jNx+HyVlbe/WRUrPdLAtxuIfOIMsgVI4ZaDCOO44XHmIolfTb+INLlJKz8tdLq+nqS
         J3IbGMH3IFSwq4Dfs85xCc21Gz7CgRkDgfNjLpcRUm8YIKFId9K0951jzYNemy+bY0vU
         mfTMwsOnG1epdDm84gswuKxBCblcJcAf0GlElKhqMJExgupt3aFgNAur5R2ocPLXScin
         mcNPmdUUpm2ikx4BJjBRMAfD1LOiJz7utyg5AmNvJnnXDpBcrfp40W23Nq5rR4IlofYo
         AfUEPweAnBMqsGrsakOiWUSPQ+ZL1mUlmsG+WX0OXoi8VI30SMj10JY2V8Fm4SAlmI/1
         uvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zZc5xOP0xJFdkWXLW4Eh/g4pOZDZTjhdnyoqBFnt7HE=;
        b=2njgmY7blf2gwJ/aDvHZQuavivDx5rtoBYtZvUcjgqGBzd+0UiYxSnYdeGBHeZmdnU
         JhE3xZ2vi3szMINO6HiOnKDVlaYGl6HUYq3XVbDAHeVu4yhxDrJsth5y9W55bVanHpp+
         T9Rdb/ZiHUwlm7rbN5XBf5e+6WPASwuAS1hTkkgDXjHsFSiF3DnSzC6ZJ3f/2nAp0ppM
         SXmBLeap5dYnndnD2WmlTzwLRlcbX+JRSJvQI1ld+cbg7m9ftNRyp9aI5XdeG3Ehc4ur
         PeNh1/ziiTwElPxVdppCzFt8C/FWVoElfVZQ/ntM5NeQ3yGXIeePfkj+JbmlT4twudnC
         /Ldw==
X-Gm-Message-State: ANoB5pmpXlJIBSYP4jmeOumNQYy0/jQROtQOm9mbXvcJt5aQLj+kShK+
        jqh9/ubHOJ2JZBRwyMDAJqCl06mbVzToJLTaPWUJ
X-Google-Smtp-Source: AA0mqf5sBQNs28sOBqrnhm1swUcszLklYtHexIa7tffAXM23323DKBFj1U6ylewxwYn+kM0hFFlZjc7knH3ByZlnilU=
X-Received: by 2002:a63:1f63:0:b0:460:ec46:3645 with SMTP id
 q35-20020a631f63000000b00460ec463645mr20336089pgm.92.1669074088835; Mon, 21
 Nov 2022 15:41:28 -0800 (PST)
MIME-Version: 1.0
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com> <20221110094639.3086409-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20221110094639.3086409-2-roberto.sassu@huaweicloud.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Nov 2022 18:41:17 -0500
Message-ID: <CAHC9VhQ9WftDrF1R--ZYJXOv-YbVU-Pr1Ob_deDwEWm8OcQ-TA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] reiserfs: Add missing calls to reiserfs_security_free()
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 4:47 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
> during inode creation") defined reiserfs_security_free() to free the name
> and value of a security xattr allocated by the active LSM through
> security_old_inode_init_security(). However, this function is not called
> in the reiserfs code.
>
> Thus, add a call to reiserfs_security_free() whenever
> reiserfs_security_init() is called, and initialize value to NULL, to avoid
> to call kfree() on an uninitialized pointer.
>
> Finally, remove the kfree() for the xattr name, as it is not allocated
> anymore.
>
> Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
> Cc: stable@vger.kernel.org
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: Mimi Zohar <zohar@linux.ibm.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  fs/reiserfs/namei.c          | 4 ++++
>  fs/reiserfs/xattr_security.c | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)

If I'm understanding this patch correctly, this is a standalone
bugfix, right?  Any reason this shouldn't be merged now, independent
of the rest of patches in this patchset?

> diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
> index 3d7a35d6a18b..b916859992ec 100644
> --- a/fs/reiserfs/namei.c
> +++ b/fs/reiserfs/namei.c
> @@ -696,6 +696,7 @@ static int reiserfs_create(struct user_namespace *mnt_userns, struct inode *dir,
>
>  out_failed:
>         reiserfs_write_unlock(dir->i_sb);
> +       reiserfs_security_free(&security);
>         return retval;
>  }
>
> @@ -779,6 +780,7 @@ static int reiserfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>
>  out_failed:
>         reiserfs_write_unlock(dir->i_sb);
> +       reiserfs_security_free(&security);
>         return retval;
>  }
>
> @@ -878,6 +880,7 @@ static int reiserfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>         retval = journal_end(&th);
>  out_failed:
>         reiserfs_write_unlock(dir->i_sb);
> +       reiserfs_security_free(&security);
>         return retval;
>  }
>
> @@ -1194,6 +1197,7 @@ static int reiserfs_symlink(struct user_namespace *mnt_userns,
>         retval = journal_end(&th);
>  out_failed:
>         reiserfs_write_unlock(parent_dir->i_sb);
> +       reiserfs_security_free(&security);
>         return retval;
>  }
>
> diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
> index 8965c8e5e172..857a65b05726 100644
> --- a/fs/reiserfs/xattr_security.c
> +++ b/fs/reiserfs/xattr_security.c
> @@ -50,6 +50,7 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
>         int error;
>
>         sec->name = NULL;
> +       sec->value = NULL;
>
>         /* Don't add selinux attributes on xattrs - they'll never get used */
>         if (IS_PRIVATE(dir))
> @@ -95,7 +96,6 @@ int reiserfs_security_write(struct reiserfs_transaction_handle *th,
>
>  void reiserfs_security_free(struct reiserfs_security_handle *sec)
>  {
> -       kfree(sec->name);
>         kfree(sec->value);
>         sec->name = NULL;
>         sec->value = NULL;
> --
> 2.25.1
>


-- 
paul-moore.com
