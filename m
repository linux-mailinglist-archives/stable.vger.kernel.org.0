Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B22153810A
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbiE3OEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbiE3OCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28E68BD23;
        Mon, 30 May 2022 06:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC1E60F3B;
        Mon, 30 May 2022 13:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A25DC36AE3;
        Mon, 30 May 2022 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917988;
        bh=e4rQjDbcX7pYuLi/MagzF5WQm9G9+qVy7DrNZMANN00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDOThP3WmMlomyWdbvkFuD0yr3Y4BRpJ+8bUMvVYG5sWmcWRtvg/zlqSvE4WTd6lv
         O/vkLEBafJe2N0TjQUrZ1/TT0FGGlCMpYISY48Us4R30CGK3mJgMKgyjbZCiczyDxV
         OU/JPBWySHlBsZA3k30Ptvgre572Xmvyt22Jp8M6u1jvSEv8plLh8cGj5tefWWLZ8w
         mSl3l1UU6cD3Y8cBBCKOb7GdwsJeF7YvcxJMCd9R35147qHDMilKgbKZOhEICajA74
         pBKAWrUv6XFC4T9MER5EI3rE7jf7nulsB7ihEcwXfI3pwcWhM7rA3sKbLXYK6NtGv8
         L2IirKIKeoSSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, colin.king@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 029/109] ASoC: rsnd: care default case on rsnd_ssiu_busif_err_status_clear()
Date:   Mon, 30 May 2022 09:37:05 -0400
Message-Id: <20220530133825.1933431-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit b1384d4c95088d01f4266237faabf165d3d605fc ]

commit cfb7b8bf1e2d66 ("ASoC: rsnd: tidyup
rsnd_ssiu_busif_err_status_clear()") merged duplicate code, but it didn't
care about default case, and causes smatch warnings.

smatch warnings:
sound/soc/sh/rcar/ssiu.c:112 rsnd_ssiu_busif_err_status_clear() \
	error: uninitialized symbol 'offset'.
sound/soc/sh/rcar/ssiu.c:114 rsnd_ssiu_busif_err_status_clear() \
	error: uninitialized symbol 'shift'.

This patch cares it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87r15rgn6p.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ssiu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/ssiu.c b/sound/soc/sh/rcar/ssiu.c
index 0d8f97633dd2..138f95dd9f4a 100644
--- a/sound/soc/sh/rcar/ssiu.c
+++ b/sound/soc/sh/rcar/ssiu.c
@@ -102,6 +102,8 @@ bool rsnd_ssiu_busif_err_status_clear(struct rsnd_mod *mod)
 		shift  = 1;
 		offset = 1;
 		break;
+	default:
+		goto out;
 	}
 
 	for (i = 0; i < 4; i++) {
@@ -120,7 +122,7 @@ bool rsnd_ssiu_busif_err_status_clear(struct rsnd_mod *mod)
 		}
 		rsnd_mod_write(mod, reg, val);
 	}
-
+out:
 	return error;
 }
 
-- 
2.35.1

