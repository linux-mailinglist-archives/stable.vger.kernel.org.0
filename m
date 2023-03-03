Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E64B6AA295
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjCCVs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjCCVsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:48:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1158969CEB;
        Fri,  3 Mar 2023 13:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50042B81A1D;
        Fri,  3 Mar 2023 21:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43159C4339C;
        Fri,  3 Mar 2023 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879882;
        bh=TRw9amU/+JqhoI9/AQoHw150q/Jlc/dyANFOAetvZtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irB0G8mBo+sQuPlAyX0sH8JgDjGflrOZfMJsjYtYwLrgf4EFrTwQl2Gy7hVdnw8R+
         bfdtxUQLs65IXIBMJgx6cGZzIFvnguB9ykbO8YRrrbr9nkkJ3FrE7OIpWEgMyNqX+P
         Am7EboK9CmiCjkoQ1EF0ZX5DEmx5zppWFnZ3BKkNEAdjbZie6nV91wCEtjk/MgEdNI
         OAj06F5Zxm55WqEN5yLXsYCp4rJ8BTChmk7rbbgRHg4xCs0GrBWL79jWEXW42JQ+A3
         5spZxnGl1nE2WYKMFXmGsT5ve3XyC8rOU3Th2v4pYZBRKBzSdqi0WFfB67TExPB65C
         dId3ue13AvorQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 6.1 40/60] USB: ene_usb6250: Allocate enough memory for full object
Date:   Fri,  3 Mar 2023 16:42:54 -0500
Message-Id: <20230303214315.1447666-40-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ce33e64c1788912976b61314b56935abd4bc97ef ]

The allocation of PageBuffer is 512 bytes in size, but the dereferencing
of struct ms_bootblock_idi (also size 512) happens at a calculated offset
within the allocation, which means the object could potentially extend
beyond the end of the allocation. Avoid this case by just allocating
enough space to catch any accesses beyond the end. Seen with GCC 13:

../drivers/usb/storage/ene_ub6250.c: In function 'ms_lib_process_bootblock':
../drivers/usb/storage/ene_ub6250.c:1050:44: warning: array subscript 'struct ms_bootblock_idi[0]' is partly outside array bounds of 'unsigned char[512]' [-Warray-bounds=]
 1050 |                         if (le16_to_cpu(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
      |                                            ^~
../include/uapi/linux/byteorder/little_endian.h:37:51: note: in definition of macro '__le16_to_cpu'
   37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
      |                                                   ^
../drivers/usb/storage/ene_ub6250.c:1050:29: note: in expansion of macro 'le16_to_cpu'
 1050 |                         if (le16_to_cpu(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
      |                             ^~~~~~~~~~~
In file included from ../drivers/usb/storage/ene_ub6250.c:5:
In function 'kmalloc',
    inlined from 'ms_lib_process_bootblock' at ../drivers/usb/storage/ene_ub6250.c:942:15:
../include/linux/slab.h:580:24: note: at offset [256, 512] into object of size 512 allocated by 'kmalloc_trace'
  580 |                 return kmalloc_trace(
      |                        ^~~~~~~~~~~~~~
  581 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  582 |                                 flags, size);
      |                                 ~~~~~~~~~~~~

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230204183546.never.849-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/ene_ub6250.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 6012603f3630e..97c66c0d91f4d 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -939,7 +939,7 @@ static int ms_lib_process_bootblock(struct us_data *us, u16 PhyBlock, u8 *PageDa
 	struct ms_lib_type_extdat ExtraData;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer = kzalloc(MS_BYTES_PER_PAGE * 2, GFP_KERNEL);
 	if (PageBuffer == NULL)
 		return (u32)-1;
 
-- 
2.39.2

