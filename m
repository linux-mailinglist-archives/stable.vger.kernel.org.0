Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7AF4FD962
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353251AbiDLHdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355521AbiDLH1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E88F4EA2E;
        Tue, 12 Apr 2022 00:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAFB616B3;
        Tue, 12 Apr 2022 07:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC52FC385A1;
        Tue, 12 Apr 2022 07:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747264;
        bh=Jc8pgUnbZ/NjC/Hkh90e39VVKCwDKbAPR4E0Lwf2MiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGDel+mcFdBDfdXD7/lMwjuQ0dGVzKub17cMKKzRxO4BZnci57tu/BdN7ri83yx0p
         6asPeIEUgHxTrh+aoR2KA6GAw9LZbFqZi9X55OSafs2oYbjSSLVtiYn52EDMwQGI1E
         V6iWcgmOhxIjPT9o2MmAHmVvHraA6VAyAAtGIMDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 017/343] drm/edid: remove non_desktop quirk for HPN-3515 and LEN-B800.
Date:   Tue, 12 Apr 2022 08:27:15 +0200
Message-Id: <20220412062951.602588791@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <philipp.zabel@gmail.com>

[ Upstream commit 50dc95d561a2552b0d76a9f91b38005195bf2974 ]

Now that there is support for the Microsoft VSDB for HMDs, remove the
non-desktop quirk for two devices that are verified to contain it in
their EDID: HPN-3515 and LEN-B800.
Presumably most of the other Windows Mixed Reality headsets contain it
as well, but there are ACR-7FCE and SEC-5194 devices without it.

Tested with LEN-B800.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220123101653.147333-2-philipp.zabel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b8f5419e514a..a71b82668a98 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -212,9 +212,7 @@ static const struct edid_quirk {
 
 	/* Windows Mixed Reality Headsets */
 	EDID_QUIRK('A', 'C', 'R', 0x7fce, EDID_QUIRK_NON_DESKTOP),
-	EDID_QUIRK('H', 'P', 'N', 0x3515, EDID_QUIRK_NON_DESKTOP),
 	EDID_QUIRK('L', 'E', 'N', 0x0408, EDID_QUIRK_NON_DESKTOP),
-	EDID_QUIRK('L', 'E', 'N', 0xb800, EDID_QUIRK_NON_DESKTOP),
 	EDID_QUIRK('F', 'U', 'J', 0x1970, EDID_QUIRK_NON_DESKTOP),
 	EDID_QUIRK('D', 'E', 'L', 0x7fce, EDID_QUIRK_NON_DESKTOP),
 	EDID_QUIRK('S', 'E', 'C', 0x144a, EDID_QUIRK_NON_DESKTOP),
-- 
2.35.1



