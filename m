Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027D65A49D1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiH2LaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiH2L3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62EA7AC03;
        Mon, 29 Aug 2022 04:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9957661200;
        Mon, 29 Aug 2022 11:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A66C433C1;
        Mon, 29 Aug 2022 11:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771377;
        bh=SNbqdDvO4C3RnGT26RP42Bqyg58JufuWY1q4hM5xNks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU35eAUNfbgtlOmT9nyux5fSpe5hvi6XMVeV0hWArXNXqTwxXYduYl7vJgpKu3qOs
         UPKBmJ7ar+yVxz/iWxsPmOaWfCMnQLZ/Toe2hFcru/w/Nhcb6B7Te8hTWgKUabe0d1
         t1lgQNmx4nOgB0L6ju9P/+00aLRbVWy+dAWtmw+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Greiner <samuel@balkonien.org>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 097/136] btrfs: add info when mount fails due to stale replace target
Date:   Mon, 29 Aug 2022 12:59:24 +0200
Message-Id: <20220829105808.652303504@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

commit f2c3bec215694fb8bc0ef5010f2a758d1906fc2d upstream.

If the replace target device reappears after the suspended replace is
cancelled, it blocks the mount operation as it can't find the matching
replace-item in the metadata. As shown below,

   BTRFS error (device sda5): replace devid present without an active replace item

To overcome this situation, the user can run the command

   btrfs device scan --forget <replace target device>

and try the mount command again. And also, to avoid repeating the issue,
superblock on the devid=0 must be wiped.

   wipefs -a device-path-to-devid=0.

This patch adds some info when this situation occurs.

Reported-by: Samuel Greiner <samuel@balkonien.org>
Link: https://lore.kernel.org/linux-btrfs/b4f62b10-b295-26ea-71f9-9a5c9299d42c@balkonien.org/T/
CC: stable@vger.kernel.org # 5.0+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -165,7 +165,7 @@ no_valid_dev_replace_entry_found:
 		 */
 		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
-			"replace devid present without an active replace item");
+"replace without active item, run 'device scan --forget' on the target device");
 			ret = -EUCLEAN;
 		} else {
 			dev_replace->srcdev = NULL;


