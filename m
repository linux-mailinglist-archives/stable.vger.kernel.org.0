Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0063D53CEB9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345203AbiFCRqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345419AbiFCRpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:45:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B386A562C9;
        Fri,  3 Jun 2022 10:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E7FB823B0;
        Fri,  3 Jun 2022 17:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92322C385A9;
        Fri,  3 Jun 2022 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278188;
        bh=iPOD9cBIGaL31sCMFKggP2a5oP8aJPGCy6oGbeLLb/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WYb1BAiIGfoHnQfvsod98HiC+S8SSTh0m6Y8aFmdjjwCfvafa6rbI+3tJrq7Dc75
         zZIPdEhxU/CbSMnDTtUWAL9OV57CQpkmBZhbY+pD63eM2P0lmXK9EF33Myk8B0U9sM
         +QbfHhZso/Jl6xSoG43ies8sjJ5+EkGVAwh9DnYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 24/30] dm verity: set DM_TARGET_IMMUTABLE feature flag
Date:   Fri,  3 Jun 2022 19:39:52 +0200
Message-Id: <20220603173815.803602103@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
References: <20220603173815.088143764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sarthak Kukreti <sarthakkukreti@google.com>

commit 4caae58406f8ceb741603eee460d79bacca9b1b5 upstream.

The device-mapper framework provides a mechanism to mark targets as
immutable (and hence fail table reloads that try to change the target
type). Add the DM_TARGET_IMMUTABLE flag to the dm-verity target's
feature flags to prevent switching the verity target with a different
target type.

Fixes: a4ffc152198e ("dm: add verity target")
Cc: stable@vger.kernel.org
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1176,6 +1176,7 @@ bad:
 
 static struct target_type verity_target = {
 	.name		= "verity",
+	.features	= DM_TARGET_IMMUTABLE,
 	.version	= {1, 4, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,


