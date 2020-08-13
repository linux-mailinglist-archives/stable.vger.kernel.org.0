Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082362431F7
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 03:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMBNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 21:13:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54669 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHMBNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 21:13:46 -0400
Received: from fsav103.sakura.ne.jp (fsav103.sakura.ne.jp [27.133.134.230])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 07D1DSvP094667;
        Thu, 13 Aug 2020 10:13:28 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav103.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav103.sakura.ne.jp);
 Thu, 13 Aug 2020 10:13:28 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav103.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 07D1DRUL094663
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 13 Aug 2020 10:13:28 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
References: <20200810031915.2209658-1-ming.lei@redhat.com>
 <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
 <20200810162331.GA2215158@T590>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <4ec1b96f-b23c-6f9c-2dc1-8c3d47689a77@i-love.sakura.ne.jp>
Date:   Thu, 13 Aug 2020 10:13:27 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810162331.GA2215158@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/08/11 1:23, Ming Lei wrote:
> The same behavior can be observed on v4.8 too, both v4.8 and v4.18
> includes 1bdc76aea115. If you apply the fix against v4.8, you can
> observe the same behavior too.

(...snipped...)

> I think this new issue may be introduced between v4.18 and v5.8.

Bisection reported that both problems ("infinite busy loop lockup" and "premature splice() return") became
visible since commit a194dfe6e6f6f720 ("pipe: Rearrange sequence in pipe_write() to preallocate slot").

Therefore, although the bug might have been existed since commit 1bdc76aea115 ("iov_iter: use bvec iterator
to implement iterate_bvec()"), we need to apply your patch to 5.5+ only.

----- test case -----

#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[])
{
        static char buffer[4096];
        const int fd = open("/tmp/testfile", O_WRONLY | O_CREAT, 0600);
        int pipe_fd[2] = { EOF, EOF };
        pipe(pipe_fd);
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'a', sizeof(buffer));
        if (argc > 1)
                write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'b', sizeof(buffer));
        if (argc > 1)
                write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'c', sizeof(buffer));
        if (argc > 1)
                write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'd', sizeof(buffer));
        if (argc > 1)
                write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        splice(pipe_fd[0], NULL, fd, NULL, 65536, 0);
        return 0;
}

----- bisect log -----

# bad: [e42617b825f8073569da76dc4510bfa019b1c35a] Linux 5.5-rc1
# good: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
# good: [4d856f72c10ecb060868ed10ff1b1453943fc6c8] Linux 5.3
# good: [0ecfebd2b52404ae0c54a878c872bb93363ada36] Linux 5.2
# good: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
# good: [1c163f4c7b3f621efff9b28a47abb36f7378d783] Linux 5.0
git bisect start 'v5.5-rc1' 'v5.4' 'v5.3' 'v5.2' 'v5.1' 'v5.0' '--' 'fs/splice.c' 'fs/pipe.c' 'include/linux/splice.h' 'include/linux/pipe_fs_i.h'
# bad: [8f868d68d335a17923dffb6858f8e9b656424699] pipe: Fix missing mask update after pipe_wait()
git bisect bad 8f868d68d335a17923dffb6858f8e9b656424699
# bad: [a194dfe6e6f6f7205eea850a420f2bc6a1541209] pipe: Rearrange sequence in pipe_write() to preallocate slot
git bisect bad a194dfe6e6f6f7205eea850a420f2bc6a1541209
# good: [6718b6f855a0b4962d54bd625be2718cb820cec6] pipe: Allow pipes to have kernel-reserved slots
git bisect good 6718b6f855a0b4962d54bd625be2718cb820cec6
# good: [8446487feba988a92e7649c60367510f0b0445a8] pipe: Conditionalise wakeup in pipe_read()
git bisect good 8446487feba988a92e7649c60367510f0b0445a8
# first bad commit: [a194dfe6e6f6f7205eea850a420f2bc6a1541209] pipe: Rearrange sequence in pipe_write() to preallocate slot

