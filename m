Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9CA6E624A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjDRMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDRMb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4752C1024A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 568B9631C9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EFC433EF;
        Tue, 18 Apr 2023 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821037;
        bh=8yuQmf4c41uS0KiWGa06rUuUPSrGNFfZKE8qvMfZzGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fzifyu7TTHaBhT8+u/oYz/t1OCnhxbIXRXRngaE/GT7pUeXd0AL5QGzoHB57LdwSO
         KW0RhtRfkrUdmQ8eolt2matMhdIQtXMqkfhN4kVDKaE5lz7ioqgdEhlBsSDzx/i52o
         T1Ek2a9G9WPUd0h8jwWb6jcnxOPl0Shu1I7f9avc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.4 38/92] drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path
Date:   Tue, 18 Apr 2023 14:21:13 +0200
Message-Id: <20230418120306.170047286@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 764a2ab9eb56e1200083e771aab16186836edf1d upstream.

Make sure all bo->base.pages entries are either NULL or pointing to a
valid page before calling drm_gem_shmem_put_pages().

Reported-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210521093811.1018992-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -502,6 +502,7 @@ static int panfrost_mmu_map_fault_addr(s
 		if (IS_ERR(pages[i])) {
 			mutex_unlock(&bo->base.pages_lock);
 			ret = PTR_ERR(pages[i]);
+			pages[i] = NULL;
 			goto err_pages;
 		}
 	}


