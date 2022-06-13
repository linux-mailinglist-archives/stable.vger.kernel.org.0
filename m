Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3CE548E08
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377080AbiFMNZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377119AbiFMNYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488206BFDC;
        Mon, 13 Jun 2022 04:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1B860FA3;
        Mon, 13 Jun 2022 11:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A265C34114;
        Mon, 13 Jun 2022 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119440;
        bh=s398Cp7zEvqbBmtiyhUOl25lcGQe79LIm4J2yWQtLYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoiOgMN2kjIlyB3I0I0ZiSNuupIMYZ5K6VXukLFcftkG7ILCEdKwTVtdjfHWX/Jv8
         MgIRrQAItbRnTgTPuTMisBNpvqzADx9uAmI+fDEPKS7re8LXtFpTmLPR6DXcoIC3Hi
         jvkwHqjw5Q9k9cEKBLuDnZAUfzaSOxEe0+QIJv0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Michael Straube <straube.linux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 016/339] staging: r8188eu: fix struct rt_firmware_hdr
Date:   Mon, 13 Jun 2022 12:07:21 +0200
Message-Id: <20220613094927.001744128@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Straube <straube.linux@gmail.com>

[ Upstream commit fbfdc1b6f80abc40cb1f7bac68248b899754d8be ]

The size of struct rt_firmware_hdr is 36 bytes.

$ pahole -C rt_firmware_hdr drivers/staging/r8188eu/r8188eu.o
struct rt_firmware_hdr {
        __le16                     Signature;            /*     0     2 */
        u8                         Category;             /*     2     1 */
        u8                         Function;             /*     3     1 */
        __le16                     Version;              /*     4     2 */
        u8                         Subversion;           /*     6     1 */

        /* XXX 1 byte hole, try to pack */

        u16                        Rsvd1;                /*     8     2 */
        u8                         Month;                /*    10     1 */
        u8                         Date;                 /*    11     1 */
        u8                         Hour;                 /*    12     1 */
        u8                         Minute;               /*    13     1 */
        __le16                     RamCodeSize;          /*    14     2 */
        u8                         Foundry;              /*    16     1 */
        u8                         Rsvd2;                /*    17     1 */

        /* XXX 2 bytes hole, try to pack */

        __le32                     SvnIdx;               /*    20     4 */
        u32                        Rsvd3;                /*    24     4 */
        u32                        Rsvd4;                /*    28     4 */
        u32                        Rsvd5;                /*    32     4 */

        /* size: 36, cachelines: 1, members: 17 */
        /* sum members: 33, holes: 2, sum holes: 3 */
        /* last cacheline: 36 bytes */
};

But the header in the firmware file is only 32 bytes long.

The hexdump of rtl8188eufw.bin shows that the field Rsvd1 should be u8
instead of __le16.

OFFSET      rtl8188eufw.bin
-----------------------------------------------------------
0x00000000  E1 88 10 00 0B 00 01 00 01 21 11 27 30 36 00 00
0x00000010  2D 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0x00000000  E1 88 10 00 0B 00 01  00     01     21    11    27 30 36 00 00
                              ^   ^      ^      ^     ^     ^
                     Subversion   Rsvd1  Month  Date  Hour  Minute

With the change of field Rsvd1 from __le16 to u8 the structure has the
correct size 32.

$ pahole -C rt_firmware_hdr drivers/staging/r8188eu/r8188eu.o
struct rt_firmware_hdr {
        __le16                     Signature;            /*     0     2 */
        u8                         Category;             /*     2     1 */
        u8                         Function;             /*     3     1 */
        __le16                     Version;              /*     4     2 */
        u8                         Subversion;           /*     6     1 */
        u8                         Rsvd1;                /*     7     1 */
        u8                         Month;                /*     8     1 */
        u8                         Date;                 /*     9     1 */
        u8                         Hour;                 /*    10     1 */
        u8                         Minute;               /*    11     1 */
        __le16                     RamCodeSize;          /*    12     2 */
        u8                         Foundry;              /*    14     1 */
        u8                         Rsvd2;                /*    15     1 */
        __le32                     SvnIdx;               /*    16     4 */
        u32                        Rsvd3;                /*    20     4 */
        u32                        Rsvd4;                /*    24     4 */
        u32                        Rsvd5;                /*    28     4 */

        /* size: 32, cachelines: 1, members: 17 */
        /* last cacheline: 32 bytes */

The wrong size had no effect because the header size is hardcoded to
32 where it is used in the code and the fields after Subversion are
not used.

Fixes: 7884fc0a1473 ("staging: r8188eu: introduce new include dir for RTL8188eu driver")
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Link: https://lore.kernel.org/r/20220417175441.13830-2-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/core/rtw_fw.c b/drivers/staging/r8188eu/core/rtw_fw.c
index 625d186c3647..ce431d8ffea0 100644
--- a/drivers/staging/r8188eu/core/rtw_fw.c
+++ b/drivers/staging/r8188eu/core/rtw_fw.c
@@ -29,7 +29,7 @@ struct rt_firmware_hdr {
 					 *  FW for different conditions */
 	__le16		Version;	/*  FW Version */
 	u8		Subversion;	/*  FW Subversion, default 0x00 */
-	u16		Rsvd1;
+	u8		Rsvd1;
 
 	/*  LONG WORD 1 ---- */
 	u8		Month;	/*  Release time Month field */
-- 
2.35.1



