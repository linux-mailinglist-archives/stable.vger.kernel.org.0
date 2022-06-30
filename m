Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027FD561C04
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiF3Nvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiF3NvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C20D37A03;
        Thu, 30 Jun 2022 06:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E6962005;
        Thu, 30 Jun 2022 13:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC06FC34115;
        Thu, 30 Jun 2022 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596950;
        bh=oCbBNzQ7H7CJAOIyXRH136dBBNXqajI5X04Of4eAtTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aol36U6d0SWtxOWamxRi01AulBsAI8eaW4RcKZGM6/Ewv/gM0tU88wLXH8QIQPxbC
         zB9tdTOyMm4hPxuEN/37T5f+u2Bq4S1fQloCb0p63XMYP/L51PFkYUdLaCjTrsHoXM
         YKipvjWXTdZkM8FQfWXBgL5nCrovMfk4OdS4dQVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/35] x86/xen: Remove undefined behavior in setup_features()
Date:   Thu, 30 Jun 2022 15:46:21 +0200
Message-Id: <20220630133232.744912833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
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
index d7d34fdfc993..f466f776604f 100644
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -28,6 +28,6 @@ void xen_setup_features(void)
 		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
 			break;
 		for (j = 0; j < 32; j++)
-			xen_features[i * 32 + j] = !!(fi.submap & 1<<j);
+			xen_features[i * 32 + j] = !!(fi.submap & 1U << j);
 	}
 }
-- 
2.35.1



