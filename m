Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B6E6E646C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjDRMtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDRMtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F061546D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3138D633CF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2F0C433D2;
        Tue, 18 Apr 2023 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822132;
        bh=88B838DTdlpDW2SpNu5skgxEB44SPoNUziSs1+nBFws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzY33mJbcGT3/WjtyrhP7gztFIC8013rpRw/kgmk7oV2S+00hqKKwO/Sn8cr6gpE5
         xVSkA3tOBADcS0GJAmI8ZXbsjHG28Cxx/SNh9TAKQE4iyVo7p9ygsYnAwS0LmEMGU9
         2Cq9VUjArYt+CkNZGREHdj0VjhZE7bFyq/X4Kj9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 033/139] RDMA/irdma: Increase iWARP CM default rexmit count
Date:   Tue, 18 Apr 2023 14:21:38 +0200
Message-Id: <20230418120314.894225448@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8385a875c9eecc429b2f72970efcbb0e5cb5b547 ]

When running perftest with large number of connections in iWARP mode, the
passive side could be slow to respond. Increase the rexmit counter default
to allow scaling connections.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230315145231.931-4-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/cm.h b/drivers/infiniband/hw/irdma/cm.h
index 19c284975fc7c..7feadb3e1eda3 100644
--- a/drivers/infiniband/hw/irdma/cm.h
+++ b/drivers/infiniband/hw/irdma/cm.h
@@ -41,7 +41,7 @@
 #define TCP_OPTIONS_PADDING	3
 
 #define IRDMA_DEFAULT_RETRYS	64
-#define IRDMA_DEFAULT_RETRANS	8
+#define IRDMA_DEFAULT_RETRANS	32
 #define IRDMA_DEFAULT_TTL		0x40
 #define IRDMA_DEFAULT_RTT_VAR		6
 #define IRDMA_DEFAULT_SS_THRESH		0x3fffffff
-- 
2.39.2



