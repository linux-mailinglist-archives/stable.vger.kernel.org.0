Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57A11577F4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgBJMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgBJMkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:18 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4119620733;
        Mon, 10 Feb 2020 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338418;
        bh=kmQVuxoiX5ikHORHDfl8KXgDzSS6R5KWecgoJhjI3B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqzGMY807fPZzTL0BrzC4CQQuyC5IGnxlooLE4b0zB5GE1osnTUGoGXjxOKskqAaj
         ebKS4VUYLBuUlhOyfAiBcVk/lYav2K7Zs98ZQjSTurAYtU+svMEFG8DmIOuERXt7AX
         JKIDrGEV7tuAKkP1LxfNCBLQMKqcoKdd0d1P7RXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.5 134/367] f2fs: fix dcache lookup of !casefolded directories
Date:   Mon, 10 Feb 2020 04:30:47 -0800
Message-Id: <20200210122437.232045429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 5515eae647426169e4b7969271fb207881eba7f6 upstream.

Do the name comparison for non-casefolded directories correctly.

This is analogous to ext4's commit 66883da1eee8 ("ext4: fix dcache
lookup of !casefolded directories").

Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -1073,7 +1073,7 @@ static int f2fs_d_compare(const struct d
 	if (!IS_CASEFOLDED(dentry->d_parent->d_inode)) {
 		if (len != name->len)
 			return -1;
-		return memcmp(str, name, len);
+		return memcmp(str, name->name, len);
 	}
 
 	return f2fs_ci_compare(dentry->d_parent->d_inode, name, &qstr, false);


