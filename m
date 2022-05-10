Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519985219C0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbiEJNvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244896AbiEJNrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4BF1C9AC7;
        Tue, 10 May 2022 06:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19868615C8;
        Tue, 10 May 2022 13:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111B0C385C2;
        Tue, 10 May 2022 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189548;
        bh=jFNsAr8q+Gwibdcr8AbpN4HVIGa3UxHaF27fE5URDyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uw09+/XpGcwIe34y9MoqNDEYykZ9NBQ5UqTyfrVdntZIiZAQxzLaM4AKlBrFB1MCV
         M7ctzXxpiHAl630Obuy8/yQ9O3tYcmZydNL7gJa7fIoI6RjG5vMSR77h1BxWhN39K5
         Na8DBKG9K7cJZ3dfOYloRk2zwh8lpFA0Vz284U9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 045/135] ASoC: soc-ops: fix error handling
Date:   Tue, 10 May 2022 15:07:07 +0200
Message-Id: <20220510130741.690464759@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit eb5773201b1c5d603424bd21f161c8c2d1075b42 upstream.

cppcheck throws the following warning:

sound/soc/soc-ops.c:461:8: style: Variable 'ret' is assigned a value
that is never used. [unreadVariable]
   ret = err;
       ^

This seems to be a missing change in the return value.

Fixes: 7f3d90a351968 ("ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_sx()")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220421162328.302017-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -461,7 +461,7 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 			ret = err;
 		}
 	}
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_volsw_sx);
 


