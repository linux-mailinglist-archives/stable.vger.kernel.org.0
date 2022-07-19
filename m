Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19076579D8B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241941AbiGSMwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241843AbiGSMvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:51:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55A819C20;
        Tue, 19 Jul 2022 05:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A377B81B2B;
        Tue, 19 Jul 2022 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CA4C341C6;
        Tue, 19 Jul 2022 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233216;
        bh=gAKC4wPqb+HFPL9fJF7AbBtm70KZIt2VEwNXyMyrhn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RhJ/D8WTay4F6LR1yzNr5hxzwHJEWRbPkqOhUnfmdxUVslyj+dsV8fmVAG3cz3Fb
         VHX+f4JnVqZ3ZSpn66CNpDdt2D7AbMHhxWX8fkuACTex+QTUzTU8hSNVEEFhUdwmqH
         /UzykGJWESvwxYDPQt3Bkt8pjxTONEYnGDM6yMKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.18 029/231] drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error
Date:   Tue, 19 Jul 2022 13:51:54 +0200
Message-Id: <20220719114716.520551515@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit fb6e0637ab7ebd8e61fe24f4d663c4bae99cfa62 upstream.

When panfrost_mmu_map_fault_addr() fails, the BO's mapping should be
unreferenced and not the shmem object which backs the mapping.

Cc: stable@vger.kernel.org
Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200601.1884120-2-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -518,7 +518,7 @@ err_map:
 err_pages:
 	drm_gem_shmem_put_pages(&bo->base);
 err_bo:
-	drm_gem_object_put(&bo->base.base);
+	panfrost_gem_mapping_put(bomapping);
 	return ret;
 }
 


