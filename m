Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0252603E19
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiJSJKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiJSJIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488F02EF5E;
        Wed, 19 Oct 2022 02:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D130661838;
        Wed, 19 Oct 2022 08:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA91AC433C1;
        Wed, 19 Oct 2022 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169964;
        bh=HJDN//PAUPr5qeuWQTD76jRmZZf65242mBt/Nyf+xQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igIpOlMeGRXbBSPlHCpi293vR/qkKFdrLrGgW8pH5xFGMmhWcVc2ynQlqsaqNnpDX
         pDYLx9jM/7mFIxLNrlPLyzhhBhRdmbyJ56IBEYXrCME++mVbJ7tQlPE/y5Ge8eLrTT
         wKrmZnoo44NTrE1FC6BHvK+pcCQG1YlrunLvgX/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Lee <jerrylee@qnap.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 448/862] ext4: continue to expand file system when the target size doesnt reach
Date:   Wed, 19 Oct 2022 10:28:55 +0200
Message-Id: <20221019083309.767133515@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Lee 李修賢 <jerrylee@qnap.com>

commit df3cb754d13d2cd5490db9b8d536311f8413a92e upstream.

When expanding a file system from (16TiB-2MiB) to 18TiB, the operation
exits early which leads to result inconsistency between resize2fs and
Ext4 kernel driver.

=== before ===
○ → resize2fs /dev/mapper/thin
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/mapper/thin is mounted on /mnt/test; on-line resizing required
old_desc_blocks = 2048, new_desc_blocks = 2304
The filesystem on /dev/mapper/thin is now 4831837696 (4k) blocks long.

[  865.186308] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[  912.091502] dm-4: detected capacity change from 34359738368 to 38654705664
[  970.030550] dm-5: detected capacity change from 34359734272 to 38654701568
[ 1000.012751] EXT4-fs (dm-5): resizing filesystem from 4294966784 to 4831837696 blocks
[ 1000.012878] EXT4-fs (dm-5): resized filesystem to 4294967296

=== after ===
[  129.104898] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[  143.773630] dm-4: detected capacity change from 34359738368 to 38654705664
[  198.203246] dm-5: detected capacity change from 34359734272 to 38654701568
[  207.918603] EXT4-fs (dm-5): resizing filesystem from 4294966784 to 4831837696 blocks
[  207.918754] EXT4-fs (dm-5): resizing filesystem from 4294967296 to 4831837696 blocks
[  207.918758] EXT4-fs (dm-5): Converting file system to meta_bg
[  207.918790] EXT4-fs (dm-5): resizing filesystem from 4294967296 to 4831837696 blocks
[  221.454050] EXT4-fs (dm-5): resized to 4658298880 blocks
[  227.634613] EXT4-fs (dm-5): resized filesystem to 4831837696

Signed-off-by: Jerry Lee <jerrylee@qnap.com>
Link: https://lore.kernel.org/r/PU1PR04MB22635E739BD21150DC182AC6A18C9@PU1PR04MB2263.apcprd04.prod.outlook.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2122,7 +2122,7 @@ retry:
 			goto out;
 	}
 
-	if (ext4_blocks_count(es) == n_blocks_count)
+	if (ext4_blocks_count(es) == n_blocks_count && n_blocks_count_retry == 0)
 		goto out;
 
 	err = ext4_alloc_flex_bg_array(sb, n_group + 1);


