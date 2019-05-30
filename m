Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5644F2EBCC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbfE3DQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbfE3DQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD252449A;
        Thu, 30 May 2019 03:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186168;
        bh=YlPrh8K80E/Ugmg5D1lT+uJVwaWCaWzq3kBRQR+V0F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0BorF/84yal8Xb78erMdws7QlmkjpYfJ/s/e2Dz7pUlVp4e8yjVX2YLhYNAMh8pK
         Aevf9kCq09b7sugrarQMd5aFNiot8ivvq+hY0eW+rE6D6Bsdlygd6HcI+mFOUCKA1I
         A5E9WW9Zc5KcQztHn7q/LUXDPsAMis9BgkGAujsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tobin C. Harding" <tobin@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 021/276] btrfs: sysfs: Fix error path kobject memory leak
Date:   Wed, 29 May 2019 20:02:59 -0700
Message-Id: <20190530030525.458287378@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobin C. Harding <tobin@kernel.org>

commit 450ff8348808a89cc27436771aa05c2b90c0eef1 upstream.

If a call to kobject_init_and_add() fails we must call kobject_put()
otherwise we leak memory.

Calling kobject_put() when kobject_init_and_add() fails drops the
refcount back to 0 and calls the ktype release method (which in turn
calls the percpu destroy and kfree).

Add call to kobject_put() in the error path of call to
kobject_init_and_add().

Cc: stable@vger.kernel.org # v4.4+
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3911,8 +3911,7 @@ static int create_space_info(struct btrf
 				    info->space_info_kobj, "%s",
 				    alloc_name(space_info->flags));
 	if (ret) {
-		percpu_counter_destroy(&space_info->total_bytes_pinned);
-		kfree(space_info);
+		kobject_put(&space_info->kobj);
 		return ret;
 	}
 


