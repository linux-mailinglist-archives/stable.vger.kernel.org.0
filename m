Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC46E63DDEF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiK3ScE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiK3ScD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B488D660
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B93B81CA1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF199C433D7;
        Wed, 30 Nov 2022 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833120;
        bh=S4p06cqLC8XNdf6CtljA4ROWONrhO9s1m1aT0bU5o+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAM1l5FJPsvcHziZXYc4HxY76saF3dzTtDZ/8IdWsNuG3Vp5lEXkbtBu3NAScpnfL
         rGWyNWePiVgk4wb6EJOVHRrccounS813nUdZPIqq4K3/NKfDjYKA4ETHsywNhJzMaH
         dpFgK/fhaUTYs/a3nhCnqHZC6EJYrlCI1HhMwr6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 157/162] btrfs: free btrfs_path before copying fspath to userspace
Date:   Wed, 30 Nov 2022 19:23:58 +0100
Message-Id: <20221130180532.731259343@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

commit 8cf96b409d9b3946ece58ced13f92d0f775b0442 upstream.

btrfs_ioctl_ino_to_path() frees the search path after the userspace copy
from the temp buffer @ipath->fspath. Which potentially can lead to a lock
splat warning.

Fix this by freeing the path before we copy it to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3879,6 +3879,8 @@ static long btrfs_ioctl_ino_to_path(stru
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   ipath->fspath, size);
 	if (ret) {


