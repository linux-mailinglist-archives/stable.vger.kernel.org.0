Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934AA3D6110
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhGZP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237820AbhGZPZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8396F60C41;
        Mon, 26 Jul 2021 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315576;
        bh=wf1OluGBlGsXEEba9/0Ca9aRMkh363c7DOZPWAQGin0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoBAxQaZKiKJbWg62hm0cyIjsjItPDGAman8lQmZ3qJi61Ic32TpxdeAe65xWzhC+
         D4qmOYDVR5MSwcsiL7TZA0LWIWpq+IfR+Jn5zyxPh663J9zbAYU80alx51dIyvmbiS
         2cK2Jn+YkU66ggybQTo96MY6cFFP+PCQMgdBEymA=
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
Subject: [PATCH 5.10 105/167] proc: Avoid mixing integer types in mem_rw()
Date:   Mon, 26 Jul 2021 17:38:58 +0200
Message-Id: <20210726153842.924190553@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index df9b17dd92cb..5d52aea8d7e7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -855,7 +855,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
 
 	while (count > 0) {
-		int this_len = min_t(int, count, PAGE_SIZE);
+		size_t this_len = min_t(size_t, count, PAGE_SIZE);
 
 		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
-- 
2.30.2



