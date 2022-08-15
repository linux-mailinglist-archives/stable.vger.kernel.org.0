Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587FF59477C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245599AbiHOXNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245715AbiHOXMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:12:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7BF4DB0C;
        Mon, 15 Aug 2022 13:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99C04CE12C3;
        Mon, 15 Aug 2022 20:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8AAC433D7;
        Mon, 15 Aug 2022 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593627;
        bh=NeiVTxAhI6nx6NjJa+fD0XlyRj4AyPMiZ3D5AsiipeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooYuRksgowJjXg19BevQrInGcSXbAji9JEpeKpnYMvAjnWsq54sNyYWU2tj505D6v
         SAAM9lhawbyX9JjfnmsCtzbu3phumxiqOC1q9kL0ZvEu5tE/Xv8bdUzBergTT6Wsg7
         WIGuOtEDj0A++qmoFAw9HzCtufhK9QPNgWI8pvZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.18 0978/1095] __follow_mount_rcu(): verify that mount_lock remains unchanged
Date:   Mon, 15 Aug 2022 20:06:17 +0200
Message-Id: <20220815180509.584528994@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -1511,6 +1511,8 @@ static bool __follow_mount_rcu(struct na
 				 * becoming unpinned.
 				 */
 				flags = dentry->d_flags;
+				if (read_seqretry(&mount_lock, nd->m_seq))
+					return false;
 				continue;
 			}
 			if (read_seqretry(&mount_lock, nd->m_seq))


