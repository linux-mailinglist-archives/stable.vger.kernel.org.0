Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46C5FD38C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 05:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJMDaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 23:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJMDaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 23:30:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E303A36798
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 20:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665631817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3T0uviWdqqvBZkhNynVvFATk5ZBg/+hkQ9GrVsBjsas=;
        b=d2x/pa68ausdhhCO0XY0yLr0JxQjuSTjd+ocb62kqsptW5EQo0vK8uMCTg+Mpf1TBWUWdE
        7rAWJyxG2fEU8UXnF7lcL6vM6Z0f+s7ERInWCnN7jBou4TlQEpH6fnHd8Oq+m2INZ5W2Fp
        4CLS3QmHYNkwqQ4VYAMYbOeaUVUJKh4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-mWwcYLbyOuWEtMW8zTctfA-1; Wed, 12 Oct 2022 23:30:14 -0400
X-MC-Unique: mWwcYLbyOuWEtMW8zTctfA-1
Received: by mail-pf1-f200.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so507663pff.0
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 20:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:in-reply-to:mime-version:user-agent:date
         :message-id:cc:references:to:from:subject:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3T0uviWdqqvBZkhNynVvFATk5ZBg/+hkQ9GrVsBjsas=;
        b=ZzAdnNaojrrOpUMMwFEe3JeYKdwjE+g+R/YzDerYObed3xeCOuM/l1at6KNcbTVp9V
         cFh04Xi0e3y69/aJV+hc5vCGZ/NIf41N7htluBTQHAgvbFfK+V1pNYCSGTyaHP0YA/4T
         uDl114L376ajNc/bSAJdWNOzj8VrPgNd7FFTsTL8kxQpqc8Gvw251zg+WM9SjkWwzkUg
         xvIWUHah6PVdmY9gqPCVlzLBepWqCx10U4lB9CUU2Q/PThsI1FMfmkbWpngd9A23KJ7v
         5QdOdd323U4Q6u8TgcX+6csisgdCC9323wZ0M91RzcpLQJXYmK44dN0tFlIEgLlBpOI5
         pDOA==
X-Gm-Message-State: ACrzQf1uUjglJqzZmRNTTjzzaVQmn4PmRF9h8Aa5Xs+vpZN/ptxz1JMp
        BR+8PLlYEXsT4GnmHAy62mpONAzxu4zeKVnNrjdj99XjTgbUNp1K+g8BfaYG6A7v/lWMUJB0gtt
        3NdTytsQBxi0StuX1
X-Received: by 2002:a63:2483:0:b0:461:ab67:ccfb with SMTP id k125-20020a632483000000b00461ab67ccfbmr17452291pgk.341.1665631813265;
        Wed, 12 Oct 2022 20:30:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7WBhS3PTOZc7AWOmku3lU0+KPaNH1P5zst/8BVkxGvXCNawIELQvPiosf6VJQRts74K+8e+A==
X-Received: by 2002:a63:2483:0:b0:461:ab67:ccfb with SMTP id k125-20020a632483000000b00461ab67ccfbmr17452275pgk.341.1665631812783;
        Wed, 12 Oct 2022 20:30:12 -0700 (PDT)
Received: from [10.72.12.247] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w7-20020a623007000000b005637e5d7770sm594100pfw.219.2022.10.12.20.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 20:30:11 -0700 (PDT)
Subject: Re: ceph: don't truncate file in atomic_open
From:   Xiubo Li <xiubli@redhat.com>
To:     stable@vger.kernel.org
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
 <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Venky Shankar <vshankar@redhat.com>
Message-ID: <ead853ef-172f-04e3-8a5b-ad5816b589a0@redhat.com>
Date:   Thu, 13 Oct 2022 11:30:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------3DF54AA713D5E8DA7D7AC547"
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Maintainers:

This is one very important bug fixing patch needed to be backported for 
ceph.

I have attached the patches based one the latest branches[1] of 4.9.y, 
4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y and 5.19.y.

This patch is simple and the conflict is trivial.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

Thanks!

- Xiubo



On 12/10/2022 09:51, Xiubo Li wrote:
> Hi Maitainers
>
> This patch is a fix in kceph module and should be backported to any 
> affected stable old kernels. And the original patch missed tagging 
> stable and got merged already months ago:
>
> commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832
> Author: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Date:   Fri Jul 1 10:52:27 2022 +0800
>
>     ceph: don't truncate file in atomic_open
>
>     Clear O_TRUNC from the flags sent in the MDS create request.
>
>     `atomic_open' is called before permission check. We should not do any
>     modification to the file here. The caller will do the truncation
>     afterward.
>
>     Fixes: 124e68e74099 ("ceph: file operations")
>     Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>     Reviewed-by: Xiubo Li <xiubli@redhat.com>
>     Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>
>
> Just a single patch.
>
> I am not very sure this is the correct way to do this, if anything 
> else I need to do to backport this to old kernels please let me know.
>
> Thanks!
>
> - Xiubo
>
>
>
> On 01/07/2022 10:52, Hu Weiwen wrote:
>> Clear O_TRUNC from the flags sent in the MDS create request.
>>
>> `atomic_open' is called before permission check. We should not do any
>> modification to the file here. The caller will do the truncation
>> afterward.
>>
>> Fixes: 124e68e74099 ("ceph: file operations")
>> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> ---
>> rebased onto ceph_client repo testing branch
>>
>>   fs/ceph/file.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 296fd1c7ece8..289e66e9cbb0 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -745,6 +745,11 @@ int ceph_atomic_open(struct inode *dir, struct 
>> dentry *dentry,
>>       err = ceph_wait_on_conflict_unlink(dentry);
>>       if (err)
>>           return err;
>> +    /*
>> +     * Do not truncate the file, since atomic_open is called before the
>> +     * permission check. The caller will do the truncation afterward.
>> +     */
>> +    flags &= ~O_TRUNC;
>>     retry:
>>       if (flags & O_CREAT) {
>> @@ -836,9 +841,7 @@ int ceph_atomic_open(struct inode *dir, struct 
>> dentry *dentry,
>>       set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>>       req->r_new_inode = new_inode;
>>       new_inode = NULL;
>> -    err = ceph_mdsc_do_request(mdsc,
>> -                   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
>> -                   req);
>> +    err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, 
>> req);
>>       if (err == -ENOENT) {
>>           dentry = ceph_handle_snapdir(req, dentry);
>>           if (IS_ERR(dentry)) {

--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="4.9.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="4.9.patch"

From 54677a489cce48b6477042f7e843c9c45af475a3 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 10:33:07 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 4.9 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e818344a052c..e6bf3cd8fae0 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -354,6 +354,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	err = ceph_init_dentry(dentry);
 	if (err < 0)
 		return err;
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
 
 	if (flags & O_CREAT) {
 		err = ceph_pre_init_acls(dir, &mode, &acls);
@@ -384,9 +389,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
        req->r_args.open.mask = cpu_to_le32(mask);
 
 	req->r_locked_dir = dir;           /* caller holds dir->i_mutex */
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="4.14.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="4.14.patch"

From e435a506cd5846839c3981316752d13a15662d94 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 10:58:51 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 4.14 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1f873034f469..ddfa6ce3a0fb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -381,6 +381,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		err = ceph_pre_init_acls(dir, &mode, &acls);
 		if (err < 0)
@@ -411,9 +417,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="4.19.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="4.19.patch"

From 7846c7a8083c6355dbf0713811f2e405791b315b Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 11:04:52 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 4.19 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4ce2752c8b71..95d7906fb9ea 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -446,6 +446,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -478,9 +484,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="5.4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="5.4.patch"

From ebce1c991e59c57684782c9e506bc474918ee882 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 11:08:15 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 5.4 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index aa1eac6d89f2..83122fc5f813 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -452,6 +452,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -490,9 +496,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="5.10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="5.10.patch"

From db49cff7e45b4884657e9932f069ce9ad7d63978 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 10:51:19 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 5.10 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 93d986856f1c..943655e36a79 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -703,6 +703,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -769,9 +775,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="5.15.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="5.15.patch"

From 3524a8ab33573375a14a3d5608501598ad26e007 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 11:12:23 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 5.15 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e34d52df4a13..53bffda3c76c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -703,6 +703,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -770,9 +776,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547
Content-Type: text/x-patch; charset=UTF-8;
 name="5.19.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="5.19.patch"

From ea2af51ef3c67bbf34855cd4d5c95437600047e5 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 13 Oct 2022 11:15:18 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

[ Upstream commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832]

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 5.19 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index da59e836a06e..a43e40138a3b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -740,6 +740,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -807,9 +813,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {
-- 
2.31.1


--------------3DF54AA713D5E8DA7D7AC547--

