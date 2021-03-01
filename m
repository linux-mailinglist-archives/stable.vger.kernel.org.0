Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E743B328DBB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhCATQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241143AbhCATMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C416D65312;
        Mon,  1 Mar 2021 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620583;
        bh=+0yWCGYX/eWleYB0xPjxvLFpfpYXEb8nti+BkNJmvRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkYxdB197TrOal4HYWZrzIxr6keqyh9TOTO/qJMo4QboOxoxpalWikvA5Nnzb/vgO
         K+IZmmqNTCeSmeUFdxEfghaCYBpQP/1Qhe7TDV7+/xXbTdRwqaFXlWjr+UXXiPxYo5
         iUV1wwKz9mwu71o2G4ljpA8Mn6n0h/JGOf3RqcTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 165/775] net: ipa: initialize all resources
Date:   Mon,  1 Mar 2021 17:05:33 +0100
Message-Id: <20210301161209.793436218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 25c5a7e89b1de80f4b04ad5365b2e05fefd92279 ]

We configure the minimum and maximum number of various types of IPA
resources in ipa_resource_config().  It iterates over resource types
in the configuration data and assigns resource limits to each
resource group for each type.

Unfortunately, we are repeatedly initializing the resource data for
the first type, rather than initializing each of the types whose
limits are specified.

Fix this bug.

Fixes: 4a0d7579d466e ("net: ipa: avoid going past end of resource group array")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 84bb8ae927252..eb1c8396bcdd9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -581,10 +581,10 @@ ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 		return -EINVAL;
 
 	for (i = 0; i < data->resource_src_count; i++)
-		ipa_resource_config_src(ipa, data->resource_src);
+		ipa_resource_config_src(ipa, &data->resource_src[i]);
 
 	for (i = 0; i < data->resource_dst_count; i++)
-		ipa_resource_config_dst(ipa, data->resource_dst);
+		ipa_resource_config_dst(ipa, &data->resource_dst[i]);
 
 	return 0;
 }
-- 
2.27.0



