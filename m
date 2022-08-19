Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C8359A3B4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354040AbiHSQv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354598AbiHSQvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ABC12C7F5;
        Fri, 19 Aug 2022 09:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 022E461864;
        Fri, 19 Aug 2022 16:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA634C433D6;
        Fri, 19 Aug 2022 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925307;
        bh=8GABC+rFRN2IOozQSIWeSogO1F9b7NmRyvI3OdajCNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgKeoEFKd3gcBjW7vD1Wq8zPbE83WnSaXDsf+6JaCxaayZp8AK1IJ8ijoQb4+Fxcf
         1reM9qtuNrEVA/Xc/SlnlWslSFIoXB3rb0VMKTKJn29v7zpW4MTb2xorovGEh4OHx1
         FroxO9wpZjjkBSQukEUzWLh265k8yFFPmRgJ6j/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 450/545] __follow_mount_rcu(): verify that mount_lock remains unchanged
Date:   Fri, 19 Aug 2022 17:43:40 +0200
Message-Id: <20220819153849.563763081@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 20aac6c60981f5bfacd66661d090d907bf1482f0 upstream.

Validate mount_lock seqcount as soon as we cross into mount in RCU
mode.  Sure, ->mnt_root is pinned and will remain so until we
do rcu_read_unlock() anyway, and we will eventually fail to unlazy if
the mount_lock had been touched, but we might run into a hard error
(e.g. -ENOENT) before trying to unlazy.  And it's possible to end
up with RCU pathwalk racing with rename() and umount() in a way
that would fail with -ENOENT while non-RCU pathwalk would've
succeeded with any timings.

Once upon a time we hadn't needed that, but analysis had been subtle,
brittle and went out of window as soon as RENAME_EXCHANGE had been
added.

It's narrow, hard to hit and won't get you anything other than
stray -ENOENT that could be arranged in much easier way with the
same priveleges, but it's a bug all the same.

Cc: stable@kernel.org
X-sky-is-falling: unlikely
Fixes: da1ce0670c14 "vfs: add cross-rename"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1348,6 +1348,8 @@ static bool __follow_mount_rcu(struct na
 				 * becoming unpinned.
 				 */
 				flags = dentry->d_flags;
+				if (read_seqretry(&mount_lock, nd->m_seq))
+					return false;
 				continue;
 			}
 			if (read_seqretry(&mount_lock, nd->m_seq))


