Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6533D5F2A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhGZPRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236768AbhGZPPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F27360F9F;
        Mon, 26 Jul 2021 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314780;
        bh=qNmkme/hzZvwmHvPudxMoe5eybR65lEqWdfOdiF6VZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oF0rnO3WU5FfgeOw0KZTd0lkX46/8KvQCtHV1aZ1KUyCsK3KePqS3H7dvnopbqpK2
         6HmYQwDRHvfBeQ129yeQhXOwDqRXMm0IBQedPgUjgIxct8ZyqEgxtvsCAEGiFHShaQ
         mOV8oyyi/Ed6pG45jSw3lLbzuB4msjolJWq1zvOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michel Lespinasse <walken@google.com>,
        Helge Deller <deller@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/120] proc: Avoid mixing integer types in mem_rw()
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153835.241319440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

[ Upstream commit d238692b4b9f2c36e35af4c6e6f6da36184aeb3e ]

Use size_t when capping the count argument received by mem_rw(). Since
count is size_t, using min_t(int, ...) can lead to a negative value
that will later be passed to access_remote_vm(), which can cause
unexpected behavior.

Since we are capping the value to at maximum PAGE_SIZE, the conversion
from size_t to int when passing it to access_remote_vm() as "len"
shouldn't be a problem.

Link: https://lkml.kernel.org/r/20210512125215.3348316-1-marcelo.cerri@canonical.com
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Souza Cascardo <cascardo@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 317a0762fc5f..e3f10c110b74 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -835,7 +835,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
 
 	while (count > 0) {
-		int this_len = min_t(int, count, PAGE_SIZE);
+		size_t this_len = min_t(size_t, count, PAGE_SIZE);
 
 		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
-- 
2.30.2



