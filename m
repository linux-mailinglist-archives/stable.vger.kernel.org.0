Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A600F6E63CA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjDRMn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjDRMnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44699146EF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D48FF63352
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5562C433D2;
        Tue, 18 Apr 2023 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821794;
        bh=aXSOuYvmTIaGUJwOusY2pcfU4RwwyLNCWcxY7NsZPKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SMM0m979i06sT+TsaU85umXYbMntrGbf2C0L8iveJ79TamqYCW9W1dpcHRTGmayt
         sZkO56i81URLI6629yX8GAjmh7MjxDVTNzVKzWWGYDCCVJ0lKy/iidrFsOI6C1gJG6
         Hb7rIb4RYZ4RWFN94yM9mpQZoK25PMv4R2IMC1N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sasha Finkelstein <fnkl.kernel@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 014/134] bluetooth: btbcm: Fix logic error in forming the board name.
Date:   Tue, 18 Apr 2023 14:21:10 +0200
Message-Id: <20230418120313.497009672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

commit b76abe4648c1acc791a207e7c08d1719eb9f4ea8 upstream.

This patch fixes an incorrect loop exit condition in code that replaces
'/' symbols in the board name. There might also be a memory corruption
issue here, but it is unlikely to be a real problem.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btbcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -511,7 +511,7 @@ static const char *btbcm_get_board_name(
 	len = strlen(tmp) + 1;
 	board_type = devm_kzalloc(dev, len, GFP_KERNEL);
 	strscpy(board_type, tmp, len);
-	for (i = 0; i < board_type[i]; i++) {
+	for (i = 0; i < len; i++) {
 		if (board_type[i] == '/')
 			board_type[i] = '-';
 	}


