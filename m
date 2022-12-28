Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C741657FA4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiL1QHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiL1QHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703B91122
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DBC460D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB00DC433D2;
        Wed, 28 Dec 2022 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243616;
        bh=8dHz68H1Uj+xaR1T8ByyvWjIaz529nGW+h/QHX9DYLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj5noK/lRy3RUz8HesXSyMwyRNHLcFPB2rBpCBskO3Bwbhhzw3949h20xHjqVbMpA
         eieT+WJN5LKjKel0MOaGg84qbdzKa8MFb35YUnqNe7CBXZlQK6V/4kp0KKLY8FQ2Au
         /JR3q3ZgzB6cojg+GFEvMWEXYPFq5rDGmrF4JU6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0522/1146] wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
Date:   Wed, 28 Dec 2022 15:34:21 +0100
Message-Id: <20221228144344.352361873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit dd469a754afdb782ba3033cee102147493dc39f4 ]

This struct is used to access a sequence of bytes received from the
wifi chip. It must not have any padding bytes between the members.

This doesn't change anything on my system, possibly because currently
none of the members need more than byte alignment.

Fixes: b2b43b7837ba ("rtl8xxxu: Initial functionality to handle C2H events for 8723bu")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1a270918-da22-ff5f-29fc-7855f740c5ba@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 782b089a2e1b..1ba66b8f70c9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1190,7 +1190,7 @@ struct rtl8723bu_c2h {
 			u8 bw;
 		} __packed ra_report;
 	};
-};
+} __packed;
 
 struct rtl8xxxu_fileops;
 
-- 
2.35.1



