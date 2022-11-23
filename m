Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338B2635441
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbiKWJDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiKWJDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:03:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2246FA70A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EEAEB81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF478C433C1;
        Wed, 23 Nov 2022 09:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194184;
        bh=qN2kHtrKdNxXqy5f+2fE+D32x9gwI09D/dhNa7yXKrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fD0he6/2KjFmaMwH1plD9A4xk/es4vBDGgdzzzKew8iMB2v2pEzOlclfLEqXgqEA5
         qmrpEqdrj0kINp/CtLI03EZGqXHheNgrXm0cR3c6PDo7dpjqh4Nawsc6uJka7qw+Mw
         GPo9hEffJ3yQCsCgRzdFYbP3U0rJjHJqMujiRgdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawkins Jiawei <yin31149@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        "chenxiaosong (A)" <chenxiaosong2@huawei.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 88/88] ntfs: check overflow when iterating ATTR_RECORDs
Date:   Wed, 23 Nov 2022 09:51:25 +0100
Message-Id: <20221123084551.744086524@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Hawkins Jiawei <yin31149@gmail.com>

commit 63095f4f3af59322bea984a6ae44337439348fe0 upstream.

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find().
Because the ATTR_RECORDs are next to each other, kernel can get the next
ATTR_RECORD from end address of current ATTR_RECORD, through current
ATTR_RECORD length field.

The problem is that during iteration, when kernel calculates the end
address of current ATTR_RECORD, kernel may trigger an integer overflow bug
in executing `a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))`.  This
may wrap, leading to a forever iteration on 32bit systems.

This patch solves it by adding some checks on calculating end address
of current ATTR_RECORD during iteration.

Link: https://lkml.kernel.org/r/20220831160935.3409-4-yin31149@gmail.com
Link: https://lore.kernel.org/all/20220827105842.GM2030@kadam/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: chenxiaosong (A) <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -631,6 +631,14 @@ static int ntfs_attr_find(const ATTR_TYP
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*


