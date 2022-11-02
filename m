Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4467615907
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiKBDDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKBDDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:03:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4623386
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1163B82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661D3C433C1;
        Wed,  2 Nov 2022 03:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358174;
        bh=MYO6+27ePbqq6hpmsxR5W7v7z2MKoSbkEld0rN59l2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/QSwOPdPzYYsEhuQdf7QY+hyHXVXAiBxlFmXnCzrh/X+L6Xq/IOTzpPKV7AItcuW
         xvRhyQHhPHQ+JC01cBk3xB44/uXJD7M/4zup3c7f0kbiYcmNsaRs+dH7MVMQBuQwbs
         x9aJe6c32vKbe6KltBcd4zyQnjS5uaojmrjNZdN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 054/132] ethtool: eeprom: fix null-deref on genl_info in dump
Date:   Wed,  2 Nov 2022 03:32:40 +0100
Message-Id: <20221102022101.033569066@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 9d9effca9d7d7cf6341182a7c5cabcbd6fa28063 upstream.

The similar fix as commit 46cdedf2a0fa ("ethtool: pse-pd: fix null-deref on
genl_info in dump") is also needed for ethtool eeprom.

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1c94bb8ea03f..49c0a2a77f02 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -124,7 +124,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret)
 		goto err_free;
 
-	ret = get_module_eeprom_by_page(dev, &page_data, info->extack);
+	ret = get_module_eeprom_by_page(dev, &page_data, info ? info->extack : NULL);
 	if (ret < 0)
 		goto err_ops;
 
-- 
2.38.1



