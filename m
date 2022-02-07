Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4064ABC1A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384868AbiBGLa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiBGLXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB94C0401C0;
        Mon,  7 Feb 2022 03:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEC3EB80EC3;
        Mon,  7 Feb 2022 11:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F557C004E1;
        Mon,  7 Feb 2022 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232990;
        bh=yyjs4xP38S6pltTHny3dYs+0bVDofK7LasEUo8BHNSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3acLb4Y1Y4KaUHsqnjDaDsdzkPgeJKoPIF+GAT6WP+qxUtHUii4rtOnbwr3klhAr
         tq81Eal7AJwX2p5puRDoHcKfzihDAV4Jixg5FKJtwxnKrcNsJmQR6RQVpksF32pGtr
         mxvp4hLq4pJewQPF/uGzfDyj3/f58Xd5raVLN2u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yutian Yang <nglaive@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        shenwenbo@zju.edu.cn, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 24/74] memcg: charge fs_context and legacy_fs_context
Date:   Mon,  7 Feb 2022 12:06:22 +0100
Message-Id: <20220207103758.031431111@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yutian Yang <nglaive@gmail.com>

commit bb902cb47cf93b33cd92b3b7a4019330a03ef57f upstream.

This patch adds accounting flags to fs_context and legacy_fs_context
allocation sites so that kernel could correctly charge these objects.

We have written a PoC to demonstrate the effect of the missing-charging
bugs.  The PoC takes around 1,200MB unaccounted memory, while it is
charged for only 362MB memory usage.  We evaluate the PoC on QEMU x86_64
v5.2.90 + Linux kernel v5.10.19 + Debian buster.  All the limitations
including ulimits and sysctl variables are set as default.  Specifically,
the hard NOFILE limit and nr_open in sysctl are both 1,048,576.

/*------------------------- POC code ----------------------------*/

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/file.h>
#include <time.h>
#include <sys/wait.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <linux/mount.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define STACK_SIZE (8 * 1024)
#ifndef __NR_fsopen
#define __NR_fsopen 430
#endif
static inline int fsopen(const char *fs_name, unsigned int flags)
{
        return syscall(__NR_fsopen, fs_name, flags);
}

static char thread_stack[512][STACK_SIZE];

int thread_fn(void* arg)
{
  for (int i = 0; i< 800000; ++i) {
    int fsfd = fsopen("nfs", FSOPEN_CLOEXEC);
    if (fsfd == -1) {
      errExit("fsopen");
    }
  }
  while(1);
  return 0;
}

int main(int argc, char *argv[]) {
  int thread_pid;
  for (int i = 0; i < 1; ++i) {
    thread_pid = clone(thread_fn, thread_stack[i] + STACK_SIZE, \
      SIGCHLD, NULL);
  }
  while(1);
  return 0;
}

/*-------------------------- end --------------------------------*/

Link: https://lkml.kernel.org/r/1626517201-24086-1-git-send-email-nglaive@gmail.com
Signed-off-by: Yutian Yang <nglaive@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <shenwenbo@zju.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs_context.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -231,7 +231,7 @@ static struct fs_context *alloc_fs_conte
 	struct fs_context *fc;
 	int ret = -ENOMEM;
 
-	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
+	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc)
 		return ERR_PTR(-ENOMEM);
 
@@ -631,7 +631,7 @@ const struct fs_context_operations legac
  */
 static int legacy_init_fs_context(struct fs_context *fc)
 {
-	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL);
+	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc->fs_private)
 		return -ENOMEM;
 	fc->ops = &legacy_fs_context_ops;


