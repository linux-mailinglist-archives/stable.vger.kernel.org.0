Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0E95AAF74
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiIBMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiIBMhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:37:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD76582B;
        Fri,  2 Sep 2022 05:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C29D7B82AA0;
        Fri,  2 Sep 2022 12:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A2AC433C1;
        Fri,  2 Sep 2022 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121702;
        bh=zNWRUZADOgj+xnYc4FqfxSrVRPcHNXVyJfRGwVPcYK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc+UacfzIW3DyGxmd3fLp9VUMYiY7rsL251NMV9ToSOuIkUd5rzIqLL03s+6qbJRP
         6B7N7Qn7fiHK1n5VwtuPJ/WlMQg1RFE2Cd2SHpJJJfIi3C2YUlVHV/CZ+/2NVTYepO
         mOWuPrQfMfr2w6bgEnHGRekq0nj6ZEV+ygr5zBjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Greiner <samuel@balkonien.org>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 38/77] btrfs: add info when mount fails due to stale replace target
Date:   Fri,  2 Sep 2022 14:18:47 +0200
Message-Id: <20220902121404.916620561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -125,7 +125,7 @@ no_valid_dev_replace_entry_found:
 		if (btrfs_find_device(fs_info->fs_devices,
 				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL, false)) {
 			btrfs_err(fs_info,
-			"replace devid present without an active replace item");
+"replace without active item, run 'device scan --forget' on the target device");
 			ret = -EUCLEAN;
 		} else {
 			dev_replace->srcdev = NULL;


