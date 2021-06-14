Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3EB3A6311
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhFNLJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235275AbhFNLHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26B0661927;
        Mon, 14 Jun 2021 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667534;
        bh=BowvD/eSCy3QX3Vc3LZAqN1yb6cnkXLJ8emSXKqQH6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJpKvXegYwxuLxMM8wlypnGq7Aha06QneTAu7OKMeeHHeIhqre1xUW+u0bBhMxR/D
         gn/8FxqGY8rG3mSxkEP2Qn0AgPF6rEzxjQcs4654Mkr4hdovOMnlMrWVXYcvhCKXT8
         LiGM5qvbtYibRvBK2IP4rp3NxV4HecFYgnVjLpfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 107/131] tools/bootconfig: Fix error return code in apply_xbc()
Date:   Mon, 14 Jun 2021 12:27:48 +0200
Message-Id: <20210614102656.640062962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit e8ba0b2b64126381643bb50df3556b139a60545a upstream.

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Link: https://lkml.kernel.org/r/20210508034216.2277-1-thunder.leizhen@huawei.com

Fixes: a995e6bc0524 ("tools/bootconfig: Fix to check the write failure correctly")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -399,6 +399,7 @@ static int apply_xbc(const char *path, c
 	}
 	/* TODO: Ensure the @path is initramfs/initrd image */
 	if (fstat(fd, &stat) < 0) {
+		ret = -errno;
 		pr_err("Failed to get the size of %s\n", path);
 		goto out;
 	}


