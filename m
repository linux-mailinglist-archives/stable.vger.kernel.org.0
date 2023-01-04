Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E42B65D8B2
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbjADQRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbjADQRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:17:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC63391
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09AA6178F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C5AC433F0;
        Wed,  4 Jan 2023 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849026;
        bh=JJGv0wlS+fGh1ux34YOoC2Y6fy/IDkf1dboYub3X51c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVHhuVwr8ysfPo4Vqk7SesCveHLqYkh9cGU44bk1k4KD8a/zvAe3VtfyHqkpf2AyZ
         KWQDWg7V/BHsH35Zfmy+Te1jljn7wmZtvx+eRpVisE8wo/uhOGiXZ+XBX56OY0aoFm
         Pk3VrYCORgIh/aGvoICGPJ6QgdAOlvLjMCdC6CLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.0 052/177] dm cache: set needs_check flag after aborting metadata
Date:   Wed,  4 Jan 2023 17:05:43 +0100
Message-Id: <20230104160509.222862338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

commit 6b9973861cb2e96dcd0bb0f1baddc5c034207c5c upstream.

Otherwise the commit that will be aborted will be associated with the
metadata objects that will be torn down.  Must write needs_check flag
to metadata with a reset block manager.

Found through code-inspection (and compared against dm-thin.c).

Cc: stable@vger.kernel.org
Fixes: 028ae9f76f29 ("dm cache: add fail io mode and needs_check flag")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -907,16 +907,16 @@ static void abort_transaction(struct cac
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return;
 
-	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
-		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
-		set_cache_mode(cache, CM_FAIL);
-	}
-
 	DMERR_LIMIT("%s: aborting current metadata transaction", dev_name);
 	if (dm_cache_metadata_abort(cache->cmd)) {
 		DMERR("%s: failed to abort metadata transaction", dev_name);
 		set_cache_mode(cache, CM_FAIL);
 	}
+
+	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
+		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
+		set_cache_mode(cache, CM_FAIL);
+	}
 }
 
 static void metadata_operation_failed(struct cache *cache, const char *op, int r)


