Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E2615858
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKBCuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiKBCuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220D61F9CD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1097617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A663C433D6;
        Wed,  2 Nov 2022 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357402;
        bh=0Wm2kfcjQxhzSRT7cdIl2vtAJtEKxeApRMIRgBalmn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAXP7r9v9svrpQ98qF93zC5iUqDBO4EgCBiCQ3iQqRbc4imlSPxUPll31IkGvu40A
         mUhLsF0OnR9fxPPAqm1YYrzUadMU3mjPvWOaa6ZiYGGOFUiNxUNO3MIrIHMfievQBJ
         zV0BeX4sZm1PpIAXaLCXiRESJKC9nRo2l3Km3D9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Poirier <bpoirier@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 164/240] selftests: net: Fix netdev name mismatch in cleanup
Date:   Wed,  2 Nov 2022 03:32:19 +0100
Message-Id: <20221102022115.091060985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit b2c0921b926ca69cc399eb356162f35340598112 ]

lag_lib.sh creates the interfaces dummy1 and dummy2 whereas
dev_addr_lists.sh:destroy() deletes the interfaces dummy0 and dummy1. Fix
the mismatch in names.

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
index 9684163949f0..33913112d5ca 100755
--- a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -18,7 +18,7 @@ source "$lib_dir"/lag_lib.sh
 
 destroy()
 {
-	local ifnames=(dummy0 dummy1 team0 mv0)
+	local ifnames=(dummy1 dummy2 team0 mv0)
 	local ifname
 
 	for ifname in "${ifnames[@]}"; do
-- 
2.35.1



