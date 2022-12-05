Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80229643456
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiLETo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiLETod (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:44:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CED42C13D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27922612FE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D108C433D6;
        Mon,  5 Dec 2022 19:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269302;
        bh=oih++l+q2/nAYqIvClf3BALvjC51Aulfi4fPs65ZRq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5BiErypsX11zT245jMzaJUnd3WMXY5NfRYmatLPdguea+k0RBlI5IBtrHgyWcwr7
         bvbkiZ0EEhAWJ8PJGDZv30nVbtymipLpv4JXvwKzA5J85N0jrtaGjM5N6xmGhGqW9L
         FNyuVdkArf/UsPEfVPtxhz2flUV7AOKzTtlcF2gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 077/153] btrfs: free btrfs_path before copying subvol info to userspace
Date:   Mon,  5 Dec 2022 20:10:01 +0100
Message-Id: <20221205190810.934115217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

commit 013c1c5585ebcfb19c88efe79063d0463b1b6159 upstream.

btrfs_ioctl_get_subvol_info() frees the search path after the userspace
copy from the temp buffer @subvol_info. This can lead to a lock splat
warning.

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
@@ -2824,6 +2824,8 @@ static int btrfs_ioctl_get_subvol_info(s
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
 		ret = -EFAULT;
 


