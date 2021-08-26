Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64773F8DD9
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhHZSbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 14:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhHZSbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 14:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB17060FD7;
        Thu, 26 Aug 2021 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630002652;
        bh=h5ksNy9W7qfIY9z2jOPrHXLzTKv2T4Uc5gEdULxAi3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWXr4RXtPS7sBGpba08WKGlEZ2yNJhNz6AaQjN2bL7g8YqYn985/Q8Ztha6luFZnt
         4YYLCRiw1us3jx9pH7f/hpIgHUqVeSHRYsmEZmBpkdsUVNCQHdPxKFifZWE1KO9Mqt
         yiQa4+QRyV5sAnV6isG9QfyczGJ/Oi7nxEyT1VnwenXSKeAhONZxsyw+ax3fXNeFN2
         Jnm3mUVDkquix4ynsEs2892q2yaAUFN7cXUGhkpXJYancutFmLKmFSRHgTkLOv/e/+
         xC/oWCaGtR034OlV4ERN86DdIyZZhb+xvxrKnQEFSoLvUudc9mOaLgThg4NUO7kbWf
         XH5sz2Jshv7Ow==
Date:   Thu, 26 Aug 2021 14:30:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 5.10.y] bpf: Fix NULL pointer dereference in
 bpf_get_local_storage() helper
Message-ID: <YSfd2tZll1We6vse@sashalap>
References: <552c822eac5fb168f94570056ccd8a4b790db2bf.1629740134.git.sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <552c822eac5fb168f94570056ccd8a4b790db2bf.1629740134.git.sdf@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 23, 2021 at 10:36:46AM -0700, Stanislav Fomichev wrote:
>From: Yonghong Song <yhs@fb.com>
>
>commit b910eaaaa4b89976ef02e5d6448f3f73dc671d91 upstream.
>
>Jiri Olsa reported a bug ([1]) in kernel where cgroup local
>storage pointer may be NULL in bpf_get_local_storage() helper.
>There are two issues uncovered by this bug:
>  (1). kprobe or tracepoint prog incorrectly sets cgroup local storage
>       before prog run,
>  (2). due to change from preempt_disable to migrate_disable,
>       preemption is possible and percpu storage might be overwritten
>       by other tasks.
>
>This issue (1) is fixed in [2]. This patch tried to address issue (2).
>The following shows how things can go wrong:
>  task 1:   bpf_cgroup_storage_set() for percpu local storage
>         preemption happens
>  task 2:   bpf_cgroup_storage_set() for percpu local storage
>         preemption happens
>  task 1:   run bpf program
>
>task 1 will effectively use the percpu local storage setting by task 2
>which will be either NULL or incorrect ones.
>
>Instead of just one common local storage per cpu, this patch fixed
>the issue by permitting 8 local storages per cpu and each local
>storage is identified by a task_struct pointer. This way, we
>allow at most 8 nested preemption between bpf_cgroup_storage_set()
>and bpf_cgroup_storage_unset(). The percpu local storage slot
>is released (calling bpf_cgroup_storage_unset()) by the same task
>after bpf program finished running.
>bpf_test_run() is also fixed to use the new bpf_cgroup_storage_set()
>interface.
>
>The patch is tested on top of [2] with reproducer in [1].
>Without this patch, kernel will emit error in 2-3 minutes.
>With this patch, after one hour, still no error.
>
> [1] https://lore.kernel.org/bpf/CAKH8qBuXCfUz=w8L+Fj74OaUpbosO29niYwTki7e3Ag044_aww@mail.gmail.com/T
> [2] https://lore.kernel.org/bpf/20210309185028.3763817-1-yhs@fb.com
>
>Signed-off-by: Yonghong Song <yhs@fb.com>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>Acked-by: Roman Gushchin <guro@fb.com>
>Link: https://lore.kernel.org/bpf/20210323055146.3334476-1-yhs@fb.com
>Cc: <stable@vger.kernel.org> # 5.10.x
>Change-Id: I0bff719d0bfbaa819316de26391b4b2e4e60faed
>Signed-off-by: Stanislav Fomichev <sdf@google.com>

Queued up, thanks!

-- 
Thanks,
Sasha
