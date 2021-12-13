Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ACB47294B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbhLMKTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbhLMKOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD146C08ED84;
        Mon, 13 Dec 2021 01:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61033B80E0C;
        Mon, 13 Dec 2021 09:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DB0C34601;
        Mon, 13 Dec 2021 09:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389310;
        bh=+Djn/3BEkd6UZGefbb8zDB8OGVDMZDaJu1Osml+P4aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tz2xB/Kd1QfVOIRAUOR2/RM0GhJdw5+TqO/SICdpydyJT+A6U1r/DunDFcdmHOd3z
         FEUWgeZJ9T8OgJUEWe9NDgRNGOgaAccQkCATF7H0kBU8xj04uDHUPRHzR5Jbq5jnhU
         m+CviqeSiR1SCpemtBsctSMz+5LCjmtwWTDDbSnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 054/171] net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering
Date:   Mon, 13 Dec 2021 10:29:29 +0100
Message-Id: <20211213092946.905613066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

commit e8b1d7698038e76363859fb47ae0a262080646f5 upstream.

Avoid a memory leak if there is not a CPU port defined.

Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during init and teardown")
Addresses-Coverity-ID: 1492897 ("Resource leak")
Addresses-Coverity-ID: 1492899 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20211209110538.11585-1-jose.exposito89@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -290,8 +290,11 @@ static int felix_setup_mmio_filtering(st
 		}
 	}
 
-	if (cpu < 0)
+	if (cpu < 0) {
+		kfree(tagging_rule);
+		kfree(redirect_rule);
 		return -EINVAL;
+	}
 
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);


