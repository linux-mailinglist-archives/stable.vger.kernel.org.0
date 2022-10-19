Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A55603E2F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiJSJLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiJSJJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA472940;
        Wed, 19 Oct 2022 02:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C768617E2;
        Wed, 19 Oct 2022 08:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62347C433C1;
        Wed, 19 Oct 2022 08:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169998;
        bh=TTsckvmflagtafRn2JFd/70xMuypHyk4u8pTivsTen4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4IMHnwylJXpW35T21gq5yAFOz0GMf5A6z65o1lA16sR01U8SIirNYxT/8hWkuov8
         f/9bQ0FKHICykahHDV6Hwuwn2nXNcP3oZGGoQOc57XiXfE7q/K0oli5595oQEothQ0
         Kt7+7ZSWkec9vFxnpLn4oZCkHgcLtIMtjISbMGjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 481/862] HID: uclogic: Fix warning in uclogic_rdesc_template_apply
Date:   Wed, 19 Oct 2022 10:29:28 +0200
Message-Id: <20221019083311.204721778@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 609174edeb758d1e2d713e7ab4e09ea8d45aa4f7 ]

Building with Sparse enabled prints this warning:

    warning: incorrect type in assignment (different base types)
        expected signed int x
        got restricted __le32 [usertype]

Cast the return value of cpu_to_le32() to fix the warning.

Fixes: 08177f4 ("HID: uclogic: merge hid-huion driver in hid-uclogic")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-rdesc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-rdesc.c b/drivers/hid/hid-uclogic-rdesc.c
index 3d68e8b0784d..81ca22398ed5 100644
--- a/drivers/hid/hid-uclogic-rdesc.c
+++ b/drivers/hid/hid-uclogic-rdesc.c
@@ -1113,7 +1113,7 @@ __u8 *uclogic_rdesc_template_apply(const __u8 *template_ptr,
 		    memcmp(p, pen_head, sizeof(pen_head)) == 0 &&
 		    p[sizeof(pen_head)] < param_num) {
 			v = param_list[p[sizeof(pen_head)]];
-			put_unaligned(cpu_to_le32(v), (s32 *)p);
+			put_unaligned((__force u32)cpu_to_le32(v), (s32 *)p);
 			p += sizeof(pen_head) + 1;
 		} else if (memcmp(p, btn_head, sizeof(btn_head)) == 0 &&
 			   p[sizeof(btn_head)] < param_num) {
-- 
2.35.1



