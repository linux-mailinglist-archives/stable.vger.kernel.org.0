Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0794C6BB26E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjCOMgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjCOMf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6852A0B32
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A5DB81E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DABDC433EF;
        Wed, 15 Mar 2023 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883692;
        bh=LfnVXaZHJarVpu2QSBKIG9RKXVGF8e3mBnm3yQ86NWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UflZlxQsHhdKGRVG1Qd/QJ44dSSY7qzaIsSIxcZgFoFazQSWq19brlbIQpiHLjeuK
         5gxqMBstFubjdfGXGPT0nOJbJnhzPVcLKePr8HoYtFPrl4VyLi5H9z8juB1zsznnuS
         F7nC9pURujHa79nv+zQQKBWWMVBYKTeYcJvLdgXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrien Moulin <amoulin@corp.free.fr>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/143] net: tls: fix device-offloaded sendpage straddling records
Date:   Wed, 15 Mar 2023 13:13:02 +0100
Message-Id: <20230315115743.431324096@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e539a105f947b9db470fec39fe91d85fe737a432 ]

Adrien reports that incorrect data is transmitted when a single
page straddles multiple records. We would transmit the same
data in all iterations of the loop.

Reported-by: Adrien Moulin <amoulin@corp.free.fr>
Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
Tested-by: Adrien Moulin <amoulin@corp.free.fr>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20230304192610.3818098-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc250..a7cc4f9faac28 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,8 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+
+			iter_offset.offset += copy;
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
-- 
2.39.2



