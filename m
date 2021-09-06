Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E93C401B97
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbhIFM6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242607AbhIFM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0409361039;
        Mon,  6 Sep 2021 12:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933009;
        bh=iprgAoh1OvLLxlWYO7UmW3j7TzBZhhcCXbdNFYV+JV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPH1iO5r4bfSFVAYcw6FMUnzKBEYTr9wrGSjdWayyW7UZOPpDdCteOun3YNyOF3aq
         r6mgOq4l3cXLl+sq9kXoIk/3d49CgPWde0e2wjDSwSbmWMTCwjv2Y6ObOnNtOuo9K2
         mHBVP9XrYrN/lOBXXGdnv/LAeD6htW9GCSDOQK24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/29] Revert "cred: add missing return error code when set_cred_ucounts() failed"
Date:   Mon,  6 Sep 2021 14:55:22 +0200
Message-Id: <20210906125450.027579655@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0855952ed4f1a6861fbb0e5d684efd447d7347c9 which is
commit 5e6b8a50a7cec5686ee2c4bda1d49899c79a7eae upstream.

The "original" commit 905ae01c4ae2 ("Add a reference to ucounts for each
cred"), should not have been applied to the 5.10.y tree, so revert it,
and the follow-on fixup patches as well.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/r/87v93k4bl6.fsf@disp2133
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -372,8 +372,7 @@ int copy_creds(struct task_struct *p, un
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
-		ret = set_cred_ucounts(new);
-		if (ret < 0)
+		if (set_cred_ucounts(new) < 0)
 			goto error_put;
 	}
 


