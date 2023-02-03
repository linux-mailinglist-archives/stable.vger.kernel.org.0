Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB1689505
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjBCKPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbjBCKPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C789A820
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEA1861E4C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C618C4339B;
        Fri,  3 Feb 2023 10:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419348;
        bh=CeJ2r+/LSNxIsohXanKRY9uSKANAWJGw/9fWllbpYtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5MgEeaG2J4t5l1tPHq9DpgfwPZY98WSSR50V37AHc+1YSnj8Uy5tGyej2HfKyoqP
         HgCdxnXAHGpl9VxnIjOwGAOGhpArBKVvMWXM7frhGKTPPEGOm9WxaH3xENZqFHOS7B
         ++UaLmFUlk2gENhYYZVUM6XWvRzGxBggYRp/xRxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Dokyung Song <dokyungs@yonsei.ac.kr>,
        Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/62] wifi: brcmfmac: fix up incorrect 4.14.y backport for brcmf_fw_map_chip_to_name()
Date:   Fri,  3 Feb 2023 11:12:35 +0100
Message-Id: <20230203101014.663497180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit bc45aa1911bf699b9905f12414e3c1879d6b784f which is commit
81d17f6f3331f03c8eafdacea68ab773426c1e3c upstream, the return value of the
error condition needs to be reworked to return a real error and not NULL.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Dokyung Song <dokyungs@yonsei.ac.kr>
Cc: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Cc: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/Y8gccXXyE30sbPSg@dev-arch.thelio-3990X
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -574,7 +574,7 @@ int brcmf_fw_map_chip_to_name(u32 chip,
 
 	if (chiprev >= BITS_PER_TYPE(u32)) {
 		brcmf_err("Invalid chip revision %u\n", chiprev);
-		return NULL;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < table_size; i++) {


