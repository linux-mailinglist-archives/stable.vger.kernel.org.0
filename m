Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3386D540135
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 16:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiFGOXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 10:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245383AbiFGOXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 10:23:07 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9A5C847
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 07:23:05 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 257EMspE087009;
        Tue, 7 Jun 2022 23:22:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Tue, 07 Jun 2022 23:22:54 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 257EMmYc086975
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 7 Jun 2022 23:22:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <919294bc-a718-b936-9cc8-69e494912eeb@I-love.SAKURA.ne.jp>
Date:   Tue, 7 Jun 2022 23:22:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] tomoyo: fix handling of path{1,2}.parent.* conditions
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     tomoyo-dev-en@lists.osdn.me
References: <20220607122716.1704591-1-brauner@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20220607122716.1704591-1-brauner@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/06/07 21:27, Christian Brauner wrote:
> When path conditions are specified tomoyo tries to retrieve information about
> the parent dentry. It currently assumes that the parent dentry is always
> reachable from the child dentry's mount. This assumption is wrong when
> bind-mounts are in play:

Thank you for a patch, but I consider that current behavior is correct.

> file read /foo/file1 path1.parent.uid=12

The path{1,2}.* and path{1,2}.parent.* conditions use inode's attributes.
That is, these conditions are independent with pathname reachability.

---------- Initialization ----------
# mkdir -p /foo /bar
# touch /foo/file1 /bar/file2
# chown 100 /foo
# chown 200 /foo/file1
# chown 300 /bar
# chown 400 /bar/file2

---------- Before doing bind mount ----------
# cat /foo/file1 /bar/file2

---------- Access log of before doing bind mount ----------
#2022/06/07 13:47:14# profile=2 mode=permissive granted=no (global-pid=2757) task={ pid=2757 ppid=2690 uid=0 gid=0 euid=0 egid=0 suid=0 sgid=0 fsuid=0 fsgid=0 } path1={ uid=200 gid=0 ino=2501389 major=8 minor=1 perm=0644 type=file } path1.parent={ uid=100 gid=0 ino=2501384 perm=0755 }
<kernel> /usr/sbin/sshd /usr/bin/bash /usr/bin/cat
file read /foo/file1
#2022/06/07 13:47:14# profile=2 mode=permissive granted=no (global-pid=2757) task={ pid=2757 ppid=2690 uid=0 gid=0 euid=0 egid=0 suid=0 sgid=0 fsuid=0 fsgid=0 } path1={ uid=400 gid=0 ino=273557228 major=8 minor=1 perm=0644 type=file } path1.parent={ uid=300 gid=0 ino=273557227 perm=0755 }
<kernel> /usr/sbin/sshd /usr/bin/bash /usr/bin/cat
file read /bar/file2

---------- After doing bind mount ----------
# mount --bind /bar/file2 /foo/file1
# cat /foo/file1 /bar/file2

---------- Access log of after doing bind mount ----------
#2022/06/07 13:48:46# profile=2 mode=permissive granted=no (global-pid=2773) task={ pid=2773 ppid=2690 uid=0 gid=0 euid=0 egid=0 suid=0 sgid=0 fsuid=0 fsgid=0 } path1={ uid=400 gid=0 ino=273557228 major=8 minor=1 perm=0644 type=file } path1.parent={ uid=300 gid=0 ino=273557227 perm=0755 }
<kernel> /usr/sbin/sshd /usr/bin/bash /usr/bin/cat
file read /foo/file1
#2022/06/07 13:48:46# profile=2 mode=permissive granted=no (global-pid=2773) task={ pid=2773 ppid=2690 uid=0 gid=0 euid=0 egid=0 suid=0 sgid=0 fsuid=0 fsgid=0 } path1={ uid=400 gid=0 ino=273557228 major=8 minor=1 perm=0644 type=file } path1.parent={ uid=300 gid=0 ino=273557227 perm=0755 }
<kernel> /usr/sbin/sshd /usr/bin/bash /usr/bin/cat
file read /bar/file2

