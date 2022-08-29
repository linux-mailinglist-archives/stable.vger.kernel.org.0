Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED5B5A4B7B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiH2MVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiH2MVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:21:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC7B58514;
        Mon, 29 Aug 2022 05:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D0CFB80EF8;
        Mon, 29 Aug 2022 11:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80320C433D6;
        Mon, 29 Aug 2022 11:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771781;
        bh=SNbqdDvO4C3RnGT26RP42Bqyg58JufuWY1q4hM5xNks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKeqI+AxpI7j1lzaul2oBH0R+j7+WZhQMHyJWtzqZ3JSadKmZEyfxf+yh/pYv7KgD
         XzWFLLe2hvsX6G9yfrFlLQjLhaR0aONcFSWgn8xU4zg0GOBQcqfz6dwO+ORKMZ7XIS
         /uyYdyhgnenyFbaDFiT1mnZFZ7mb+eo9kQ+GTpr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Greiner <samuel@balkonien.org>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 096/158] btrfs: add info when mount fails due to stale replace target
Date:   Mon, 29 Aug 2022 12:59:06 +0200
Message-Id: <20220829105813.099292808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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


