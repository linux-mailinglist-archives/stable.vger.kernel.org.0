Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC855C827
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbiF0Lsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiF0Ls3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18151BF46;
        Mon, 27 Jun 2022 04:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C293EB81133;
        Mon, 27 Jun 2022 11:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33763C3411D;
        Mon, 27 Jun 2022 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330095;
        bh=U+Rg92FEYewgN3rsnB9jAB+CU0+j+dvaLs9T3nZDteI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1TW9jzvLsyOcntgy5CAyB1G+lFisLvrs2Um3H4WrJjj8ki1p6UsS+MG5YlPgHosA
         PFyBm3cHcg7WBYz0mpg+T+8yO2MWaLtgoy4E9Ky1/nIWMzXScIgDraMIq6XZfXS0qG
         Neoo30o2LHsp3n8glskCG9EEBUFKt5vIVwodlnxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 081/181] x86/xen: Remove undefined behavior in setup_features()
Date:   Mon, 27 Jun 2022 13:20:54 +0200
Message-Id: <20220627111946.910028305@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Grall <jgrall@amazon.com>

[ Upstream commit ecb6237fa397b7b810d798ad19322eca466dbab1 ]

1 << 31 is undefined. So switch to 1U << 31.

Fixes: 5ead97c84fa7 ("xen: Core Xen implementation")
Signed-off-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220617103037.57828-1-julien@xen.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/features.c b/drivers/xen/features.c
index 7b591443833c..87f1828d40d5 100644
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -42,7 +42,7 @@ void xen_setup_features(void)
 		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
 			break;
 		for (j = 0; j < 32; j++)
-			xen_features[i * 32 + j] = !!(fi.submap & 1<<j);
+			xen_features[i * 32 + j] = !!(fi.submap & 1U << j);
 	}
 
 	if (xen_pv_domain()) {
-- 
2.35.1



