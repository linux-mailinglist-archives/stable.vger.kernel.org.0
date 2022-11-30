Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5063DEFD
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiK3Smn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiK3Sm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:42:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3FF99F05
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8223C61D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F953C433D7;
        Wed, 30 Nov 2022 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833747;
        bh=vWMEbVvNdHPubew5vTnqpn02m4SxoFtJfnZgLzQzJmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a12OHUVbg/PE5ftegw2sQ4907CdhWSam+vrAaxyPBUILeuY4LjaY7fG/ff26WE2YC
         Hw0kPt3/slosBHqUkno00OEUAlSPXba3MY+xEaEFdkRZdqBkhvXCxRKrFGkAt/nzXK
         /w63iniFgXPqZ78xzfpYTWyw17lR9nQFjvZavTqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 197/206] btrfs: free btrfs_path before copying fspath to userspace
Date:   Wed, 30 Nov 2022 19:24:09 +0100
Message-Id: <20221130180538.030923703@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
@@ -3892,6 +3892,8 @@ static long btrfs_ioctl_ino_to_path(stru
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   ipath->fspath, size);
 	if (ret) {


