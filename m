Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77965D9A7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbjADQ0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239798AbjADQ0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853D61ADAF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED61617A6
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241A3C433EF;
        Wed,  4 Jan 2023 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849604;
        bh=uq4+5aO999whfevOG+qpcsDAxGIZXeVu4VCQo0w85Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYDCg7P8sS9odeN4tBCJv6TuX7CpuyNcpe6wZa6Ceyo5QOT9JKd50EyVQdo9GSfyh
         rumd1KbHtzTp6dnMN6JONGK6mSb9MafgNwcBQPNpjeP0xHJeH+Ah9PK7wJtzMB8nv/
         XjGjmphiDt+eHHcIoBdwmCKEXUHwIjPs2BNuyBkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.0 159/177] ext4: dont return EINVAL from GETFSUUID when reporting UUID length
Date:   Wed,  4 Jan 2023 17:07:30 +0100
Message-Id: <20230104160512.490963133@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit b76abb5157468756163fe7e3431c9fe32cba57ca upstream.

If userspace calls this ioctl with fsu_length (the length of the
fsuuid.fsu_uuid array) set to zero, ext4 copies the desired uuid length
out to userspace.  The kernel call returned a result from a valid input,
so the return value here should be zero, not EINVAL.

While we're at it, fix the copy_to_user call to make it clear that we're
only copying out fsu_len.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Link: https://lore.kernel.org/r/166811138914.327006.9241306894437166566.stgit@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1157,9 +1157,10 @@ static int ext4_ioctl_getuuid(struct ext
 
 	if (fsuuid.fsu_len == 0) {
 		fsuuid.fsu_len = UUID_SIZE;
-		if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid.fsu_len)))
+		if (copy_to_user(&ufsuuid->fsu_len, &fsuuid.fsu_len,
+					sizeof(fsuuid.fsu_len)))
 			return -EFAULT;
-		return -EINVAL;
+		return 0;
 	}
 
 	if (fsuuid.fsu_len < UUID_SIZE || fsuuid.fsu_flags != 0)


