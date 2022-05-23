Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6A531D34
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbiEWR3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiEWR1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852B8AE56;
        Mon, 23 May 2022 10:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E4D61506;
        Mon, 23 May 2022 17:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ED3C385A9;
        Mon, 23 May 2022 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326037;
        bh=o5YtqxkUYupf5MqFxlK83h7HgWm6uI/kZfcY6w2ynMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUffCmb++Q+YJzUWqoXPFpEhyM0qYlugEquhOPJRphB+VzzATwQGdMoWx3O3iFXxU
         6a/hvNvkjTFe0aLtCja15ZKBiCFtR9ufKu1g18KOwcmCXjuffdycBTz77A1COgLGvw
         UNW594msfvRZVozdZMrFCAw7sDWvYuGOa1gpMQNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Thelen <gthelen@google.com>, Yu Liao <liaoyu15@huawei.com>
Subject: [PATCH 5.10 04/97] Revert "drm/i915/opregion: check port number bounds for SWSCI display power state"
Date:   Mon, 23 May 2022 19:05:08 +0200
Message-Id: <20220523165813.016509953@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

This reverts commit b84857c06ef9e72d09fadafdbb3ce9af64af954f.

5.10 stable contains 2 identical commits:
1. commit eb7bf11e8ef1 ("drm/i915/opregion: check port number bounds for SWSCI display power state")
2. commit b84857c06ef9 ("drm/i915/opregion: check port number bounds for SWSCI display power state")

Both commits add separate checks for the same condition. Revert the 2nd
redundant check to match upstream, which only has one check.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_opregion.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -376,21 +376,6 @@ int intel_opregion_notify_encoder(struct
 		return -EINVAL;
 	}
 
-	/*
-	 * The port numbering and mapping here is bizarre. The now-obsolete
-	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
-	 * special case, but port F and beyond are not. The functionality is
-	 * supposed to be obsolete for new platforms. Just bail out if the port
-	 * number is out of bounds after mapping.
-	 */
-	if (port > 4) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
-			    intel_encoder->base.base.id, intel_encoder->base.name,
-			    port_name(intel_encoder->port), port);
-		return -EINVAL;
-	}
-
 	if (!enable)
 		parm |= 4 << 8;
 


