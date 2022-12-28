Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ADA658094
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiL1QSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiL1QRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FFE13E3D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49757B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47AC433D2;
        Wed, 28 Dec 2022 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244192;
        bh=XfUw6PyYJpxjAdrmcyQVFb7XdAjV8j8X6jiNVwyqxL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tp7yVFAu+VqeXBmZYKJV3er32s21pF3xLOM9Helq5kAwO5KDBCTQwC6BRikd7GXwv
         7pBJP3MPppRI8AIITi2Z2sV+vcjeKa9u31HK8CT8Z1UUaDyW1yJJ61Pz4fMVL6N4ju
         7hJyFZjFhRNsbxTqrHsxmtR8o4UGFaPsZOdsH1dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0666/1073] drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_timeout_handler
Date:   Wed, 28 Dec 2022 15:37:34 +0100
Message-Id: <20221228144346.132671599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit ce8cc75c7419ad54cb99437543a54c97c7446db5 ]

The rtw_join_timeout_handler() is a timer handler that
runs in atomic context, but it could call msleep().
As a result, the sleep-in-atomic-context bug will happen.
The process is shown below:

     (atomic context)
rtw_join_timeout_handler
 _rtw_join_timeout_handler
  rtw_do_join
   rtw_select_and_join_from_scanned_queue
    rtw_indicate_disconnect
     rtw_lps_ctrl_wk_cmd
      lps_ctrl_wk_hdl
       LPS_Leave
        LPS_RF_ON_check
         msleep //sleep in atomic context

Fix by removing msleep() and replacing with mdelay().

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20221018083424.79741-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_pwrctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/core/rtw_pwrctrl.c b/drivers/staging/r8188eu/core/rtw_pwrctrl.c
index 10550bd2c16d..abfd14bfd5fb 100644
--- a/drivers/staging/r8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/r8188eu/core/rtw_pwrctrl.c
@@ -273,7 +273,7 @@ static s32 LPS_RF_ON_check(struct adapter *padapter, u32 delay_ms)
 			err = -1;
 			break;
 		}
-		msleep(1);
+		mdelay(1);
 	}
 
 	return err;
-- 
2.35.1



