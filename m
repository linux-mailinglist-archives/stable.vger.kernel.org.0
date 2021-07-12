Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F327A3C55D5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbhGLIML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353963AbhGLIDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91186145F;
        Mon, 12 Jul 2021 07:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076746;
        bh=K4wRohg7cY/fwn6n+fzVhzRCpLnCNoam6p2AAXfp8ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkelOGapWnxDZUpdX52bYw8RL2PSK1na2+2kEFXbpzsKHN1SXh1v59jYF1G0m2Cx0
         GEDrHHV5my8xcHBxKKTrUG3gl27QACQEi6JC77hrwGY97NtohRFU2O7u01wjRv7ZfI
         q9/KMzUW8nHozXocJzSJ9MzJ1ww0wYyTa5QR0pB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 749/800] selftests/sgx: remove checks for file execute permissions
Date:   Mon, 12 Jul 2021 08:12:52 +0200
Message-Id: <20210712061046.497212718@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 4896df9d53ae5521f3ce83751e828ad70bc65c80 ]

The SGX selftests can fail for a bunch of non-obvious reasons
like 'noexec' permissions on /dev (which is the default *EVERYWHERE*
it seems).

A new test mistakenly also looked for +x permission on the
/dev/sgx_enclave.  File execute permissions really only apply to
the ability of execve() to work on a file, *NOT* on the ability
for an application to map the file with PROT_EXEC.  SGX needs to
mmap(PROT_EXEC), but doesn't need to execve() the device file.

Remove the check.

Fixes: 4284f7acb78b ("selftests/sgx: Improve error detection and messages")
Reported-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-sgx@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/load.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index f441ac34b4d4..bae78c3263d9 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -150,16 +150,6 @@ bool encl_load(const char *path, struct encl *encl)
 		goto err;
 	}
 
-	/*
-	 * This just checks if the /dev file has these permission
-	 * bits set.  It does not check that the current user is
-	 * the owner or in the owning group.
-	 */
-	if (!(sb.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))) {
-		fprintf(stderr, "no execute permissions on device file %s\n", device_path);
-		goto err;
-	}
-
 	ptr = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, fd, 0);
 	if (ptr == (void *)-1) {
 		perror("mmap for read");
@@ -169,13 +159,13 @@ bool encl_load(const char *path, struct encl *encl)
 
 #define ERR_MSG \
 "mmap() succeeded for PROT_READ, but failed for PROT_EXEC.\n" \
-" Check that current user has execute permissions on %s and \n" \
-" that /dev does not have noexec set: mount | grep \"/dev .*noexec\"\n" \
+" Check that /dev does not have noexec set:\n" \
+" \tmount | grep \"/dev .*noexec\"\n" \
 " If so, remount it executable: mount -o remount,exec /dev\n\n"
 
 	ptr = mmap(NULL, PAGE_SIZE, PROT_EXEC, MAP_SHARED, fd, 0);
 	if (ptr == (void *)-1) {
-		fprintf(stderr, ERR_MSG, device_path);
+		fprintf(stderr, ERR_MSG);
 		goto err;
 	}
 	munmap(ptr, PAGE_SIZE);
-- 
2.30.2



