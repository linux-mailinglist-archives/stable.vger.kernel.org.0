Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605D06C162F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjCTPDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjCTPC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:02:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1BE2D149
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E6BB80EBE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7452BC433EF;
        Mon, 20 Mar 2023 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324284;
        bh=XyUhfPhNEkwt8xo0Wmx2PNebzxIeLjlrgrO9/ksGCQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNstYbmLrHbY9Lg8BK6pcciGyex6HAC15NP4eXV9Y4ZJoE25YD5KzwxobnPQoF3ZR
         VImuHVE9YxkFS6ioizTdAmNhSFcUMXCa9VsfeeEbyqVsE/mo0S4wj3Et7v/3ZKX0rd
         DylQsePC1fYjTPiqIbHhyoDrrVjlgbGjGsKwB2mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <yujie.liu@intel.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 02/36] fs: sysfs_emit_at: Remove PAGE_SIZE alignment check
Date:   Mon, 20 Mar 2023 15:54:28 +0100
Message-Id: <20230320145424.287346352@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>

From: Eric Biggers <ebiggers@google.com>

[No upstream commit because this fixes a bug in a backport.]

Before upstream commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)") which went into v5.4, kmalloc did
*not* always guarantee that PAGE_SIZE allocations are PAGE_SIZE-aligned.

Upstream commit 2efc459d06f1 ("sysfs: Add sysfs_emit and sysfs_emit_at
to format sysfs output") added two WARN()s that trigger when PAGE_SIZE
allocations are not PAGE_SIZE-aligned.  This was backported to old
kernels that don't guarantee PAGE_SIZE alignment.

Commit 10ddfb495232 ("fs: sysfs_emit: Remove PAGE_SIZE alignment check")
in 4.19.y, and its equivalent in 4.14.y and 4.9.y, tried to fix this
bug.  However, only it handled sysfs_emit(), not sysfs_emit_at().

Fix it in sysfs_emit_at() too.

A reproducer is to build the kernel with the following options:

	CONFIG_SLUB=y
	CONFIG_SLUB_DEBUG=y
	CONFIG_SLUB_DEBUG_ON=y
	CONFIG_PM=y
	CONFIG_SUSPEND=y
	CONFIG_PM_WAKELOCKS=y

Then run:

	echo foo > /sys/power/wake_lock && cat /sys/power/wake_lock

Fixes: cb1f69d53ac8 ("sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202303141634.1e64fd76-yujie.liu@intel.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -599,7 +599,7 @@ int sysfs_emit_at(char *buf, int at, con
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf) || at < 0 || at >= PAGE_SIZE,
+	if (WARN(!buf || at < 0 || at >= PAGE_SIZE,
 		 "invalid sysfs_emit_at: buf:%p at:%d\n", buf, at))
 		return 0;
 


