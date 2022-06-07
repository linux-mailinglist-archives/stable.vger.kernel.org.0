Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99A154096E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349871AbiFGSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349910AbiFGSAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B0814AA55;
        Tue,  7 Jun 2022 10:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87353616B4;
        Tue,  7 Jun 2022 17:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F983C385A5;
        Tue,  7 Jun 2022 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623733;
        bh=e4rQjDbcX7pYuLi/MagzF5WQm9G9+qVy7DrNZMANN00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsgd61P3/uBN3jAhl5IONLBYUmGuSv0R1h+PPx4TOobCvzithSKH6uiqjUVlFCM4A
         T9y8RqC7PQrQjira7Yn5I9ii1Mx8+3Pj8xuoVuNTjkvUl7JBdN0IBhLnvV2kJDsQSB
         XIno0MWa3ahCrZ0KkxU/gBZrIKi/9mMjy7DZGUR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/667] ASoC: rsnd: care default case on rsnd_ssiu_busif_err_status_clear()
Date:   Tue,  7 Jun 2022 18:55:36 +0200
Message-Id: <20220607164936.947486020@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



