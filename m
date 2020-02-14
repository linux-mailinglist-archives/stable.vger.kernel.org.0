Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4615EA4E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392087AbgBNQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:13:02 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35884 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392081AbgBNQNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:13:01 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so8516092iln.3;
        Fri, 14 Feb 2020 08:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tru5BVtvUUHwF9L4n2LzvkBikf8TVB+wPmv1il/Kbiw=;
        b=YtDHcyQ7/drC81j189K+7GmxipiqS58b042hM9wqUEX3aiKE7zS4ar/e+IDo7KplnD
         pASzM99itx4iIfzVW0mnnaEIwBKmu+fDmJOkv3tcOBzJu2a4L9XhvI3gjFfQtfjATHq0
         Sx0IzSCYyAkN8A1sgKHvU7dPDL6zcSaI9Mn68TokhPGLnOdsles0vmeFgnANYd4QswjZ
         uUhQR2jTBVnZuFdtJoIyC9ep8KY7d1ZLP+k/olJum6kcWXFXYamE8y7ciNNnH8suRGqu
         HsjZdGXD94Xjt7if5lKFcYpOVx3qJSUr6U2jehBu67EqaUU80SC1tpSDxLETv02l4EO+
         GPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tru5BVtvUUHwF9L4n2LzvkBikf8TVB+wPmv1il/Kbiw=;
        b=InXHRFszGN36rP955gNy0VA0LpWc2m5VBEXgD9K80hAMs3qyIUuT7SB+qBXPI2ntZ9
         CgX24W6+7E0fyLlqiI8ROu+ucESSrjhmrBSeT9fuS8Tj7ty+zvemKT1NeJCjJCy10rYF
         6406lRL7cWbbcWbvNdn7M1OmQRBez65+ZH0H0D0sJtxw0SRWTy89LQu2VsWJwSmKq7Qe
         srWMPTRMR0frFYpaP+fkryGUH2RDReIk+XasIDOYWj+7L00SBcQpBm7oVb2I/MgyQwkR
         7x46GfUIldALY8Lc0hQmcjVGgxPgGqfFfcKDZGYC8fsQBBXb6YJPHxVF7QtgN9FZyjo9
         m2EQ==
X-Gm-Message-State: APjAAAXdPwbJVRoNg3c5RVcF06llNaPNzcVv5/LBV41qEyyfuZ633X9t
        9akHJOYrRf7/BXj3Tbd+jMx0F2is8sjLXVXbnfbvcf1x3xc=
X-Google-Smtp-Source: APXvYqywcHOcSxacA5FXFO+W3pBMQq+b0476sXTpYu0Qio+kD495JaPBlcmn7DsRtWkYV98V0oDQR3iyI0gWyhPJbTQ=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr3444298ilq.215.1581696780580;
 Fri, 14 Feb 2020 08:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-487-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-487-sashal@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 14 Feb 2020 17:13:21 +0100
Message-ID: <CAOi1vP9h-Wx16AuUp4AZaF1THnFan0VFFQhx_r05+2CcyDyKAQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 487/542] ceph: remove the extra slashes in the
 server path
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 4:59 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> [ Upstream commit 4fbc0c711b2464ee1551850b85002faae0b775d5 ]
>
> It's possible to pass the mount helper a server path that has more
> than one contiguous slash character. For example:
>
>   $ mount -t ceph 192.168.195.165:40176:/// /mnt/cephfs/
>
> In the MDS server side the extra slashes of the server path will be
> treated as snap dir, and then we can get the following debug logs:
>
>   ceph:  mount opening path //
>   ceph:  open_root_inode opening '//'
>   ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
>   ceph:  alloc_inode 00000000dc4ca00b
>   ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffffffffffffff ino 1
>   ceph:  get_inode on 1=1.ffffffffffffffff got 00000000dc4ca00b
>
> And then when creating any new file or directory under the mount
> point, we can hit the following BUG_ON in ceph_fill_trace():
>
>   BUG_ON(ceph_snap(dir) != dvino.snap);
>
> Have the client ignore the extra slashes in the server path when
> mounting. This will also canonicalize the path, so that identical mounts
> can be consilidated.
>
> 1) "//mydir1///mydir//"
> 2) "/mydir1/mydir"
> 3) "/mydir1/mydir/"
>
> Regardless of the internal treatment of these paths, the kernel still
> stores the original string including the leading '/' for presentation
> to userland.
>
> URL: https://tracker.ceph.com/issues/42771
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ceph/super.c | 122 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 102 insertions(+), 20 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 430dcf329723a..112927dbd2f20 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -107,7 +107,6 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>         return 0;
>  }
>
> -
>  static int ceph_sync_fs(struct super_block *sb, int wait)
>  {
>         struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> @@ -211,7 +210,6 @@ struct ceph_parse_opts_ctx {
>
>  /*
>   * Parse the source parameter.  Distinguish the server list from the path.
> - * Internally we do not include the leading '/' in the path.
>   *
>   * The source will look like:
>   *     <server_spec>[,<server_spec>...]:[<path>]
> @@ -232,12 +230,15 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>
>         dev_name_end = strchr(dev_name, '/');
>         if (dev_name_end) {
> -               if (strlen(dev_name_end) > 1) {
> -                       kfree(fsopt->server_path);
> -                       fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
> -                       if (!fsopt->server_path)
> -                               return -ENOMEM;
> -               }
> +               kfree(fsopt->server_path);
> +
> +               /*
> +                * The server_path will include the whole chars from userland
> +                * including the leading '/'.
> +                */
> +               fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
> +               if (!fsopt->server_path)
> +                       return -ENOMEM;
>         } else {
>                 dev_name_end = dev_name + strlen(dev_name);
>         }
> @@ -461,6 +462,73 @@ static int strcmp_null(const char *s1, const char *s2)
>         return strcmp(s1, s2);
>  }
>
> +/**
> + * path_remove_extra_slash - Remove the extra slashes in the server path
> + * @server_path: the server path and could be NULL
> + *
> + * Return NULL if the path is NULL or only consists of "/", or a string
> + * without any extra slashes including the leading slash(es) and the
> + * slash(es) at the end of the server path, such as:
> + * "//dir1////dir2///" --> "dir1/dir2"
> + */
> +static char *path_remove_extra_slash(const char *server_path)
> +{
> +       const char *path = server_path;
> +       const char *cur, *end;
> +       char *buf, *p;
> +       int len;
> +
> +       /* if the server path is omitted */
> +       if (!path)
> +               return NULL;
> +
> +       /* remove all the leading slashes */
> +       while (*path == '/')
> +               path++;
> +
> +       /* if the server path only consists of slashes */
> +       if (*path == '\0')
> +               return NULL;
> +
> +       len = strlen(path);
> +
> +       buf = kmalloc(len + 1, GFP_KERNEL);
> +       if (!buf)
> +               return ERR_PTR(-ENOMEM);
> +
> +       end = path + len;
> +       p = buf;
> +       do {
> +               cur = strchr(path, '/');
> +               if (!cur)
> +                       cur = end;
> +
> +               len = cur - path;
> +
> +               /* including one '/' */
> +               if (cur != end)
> +                       len += 1;
> +
> +               memcpy(p, path, len);
> +               p += len;
> +
> +               while (cur <= end && *cur == '/')
> +                       cur++;
> +               path = cur;
> +       } while (path < end);
> +
> +       *p = '\0';
> +
> +       /*
> +        * remove the last slash if there has and just to make sure that
> +        * we will get something like "dir1/dir2"
> +        */
> +       if (*(--p) == '/')
> +               *p = '\0';
> +
> +       return buf;
> +}
> +
>  static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>                                  struct ceph_options *new_opt,
>                                  struct ceph_fs_client *fsc)
> @@ -468,6 +536,7 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>         struct ceph_mount_options *fsopt1 = new_fsopt;
>         struct ceph_mount_options *fsopt2 = fsc->mount_options;
>         int ofs = offsetof(struct ceph_mount_options, snapdir_name);
> +       char *p1, *p2;
>         int ret;
>
>         ret = memcmp(fsopt1, fsopt2, ofs);
> @@ -480,9 +549,21 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>         ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
>         if (ret)
>                 return ret;
> -       ret = strcmp_null(fsopt1->server_path, fsopt2->server_path);
> +
> +       p1 = path_remove_extra_slash(fsopt1->server_path);
> +       if (IS_ERR(p1))
> +               return PTR_ERR(p1);
> +       p2 = path_remove_extra_slash(fsopt2->server_path);
> +       if (IS_ERR(p2)) {
> +               kfree(p1);
> +               return PTR_ERR(p2);
> +       }
> +       ret = strcmp_null(p1, p2);
> +       kfree(p1);
> +       kfree(p2);
>         if (ret)
>                 return ret;
> +
>         ret = strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
>         if (ret)
>                 return ret;
> @@ -788,7 +869,6 @@ static void destroy_caches(void)
>         ceph_fscache_unregister();
>  }
>
> -
>  /*
>   * ceph_umount_begin - initiate forced umount.  Tear down down the
>   * mount, skipping steps that may hang while waiting for server(s).
> @@ -868,9 +948,6 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
>         return root;
>  }
>
> -
> -
> -
>  /*
>   * mount: join the ceph cluster, and open root directory.
>   */
> @@ -885,7 +962,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>         mutex_lock(&fsc->client->mount_mutex);
>
>         if (!fsc->sb->s_root) {
> -               const char *path;
> +               const char *path, *p;
>                 err = __ceph_open_session(fsc->client, started);
>                 if (err < 0)
>                         goto out;
> @@ -897,17 +974,22 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>                                 goto out;
>                 }
>
> -               if (!fsc->mount_options->server_path) {
> -                       path = "";
> -                       dout("mount opening path \\t\n");
> -               } else {
> -                       path = fsc->mount_options->server_path + 1;
> -                       dout("mount opening path %s\n", path);
> +               p = path_remove_extra_slash(fsc->mount_options->server_path);
> +               if (IS_ERR(p)) {
> +                       err = PTR_ERR(p);
> +                       goto out;
>                 }
> +               /* if the server path is omitted or just consists of '/' */
> +               if (!p)
> +                       path = "";
> +               else
> +                       path = p;
> +               dout("mount opening path '%s'\n", path);
>
>                 ceph_fs_debugfs_init(fsc);
>
>                 root = open_root_dentry(fsc, path, started);
> +               kfree(p);
>                 if (IS_ERR(root)) {
>                         err = PTR_ERR(root);
>                         goto out;

Hi Sasha,

This commit is buggy, the fix should land in 5.6-rc2.  Please drop it
for now -- it would need to be taken together with "ceph: canonicalize
server path in place" or not backported at all.

Thanks,

                Ilya
