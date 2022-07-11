Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0639056FAF3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiGKJYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiGKJXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCF5BE31;
        Mon, 11 Jul 2022 02:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10516121F;
        Mon, 11 Jul 2022 09:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCDAC34115;
        Mon, 11 Jul 2022 09:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530831;
        bh=SKoJobLuXWL5FRX92QKZJyelch0U0Zzj/8c/a3u1sTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlv2r9V2rOhT/aDKaPBfi2n954tgaMP3JsIPHmDj93nqbVR70S5AY5nxsjyeyxNXc
         3Es7DoPlhhEWAo+C7jaiXdI0kbqMBmPLIPgMrJSf6OV0gMF7HBpycagEjZfr9LSv5c
         LICjO3B3srhXTAxlQkNuM2kCwPDZOZxB2av/Ll+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 18/55] memregion: Fix memregion_free() fallback definition
Date:   Mon, 11 Jul 2022 11:07:06 +0200
Message-Id: <20220711090542.303296560@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

commit f50974eee5c4a5de1e4f1a3d873099f170df25f8 upstream.

In the CONFIG_MEMREGION=n case, memregion_free() is meant to be a static
inline. 0day reports:

    In file included from drivers/cxl/core/port.c:4:
    include/linux/memregion.h:19:6: warning: no previous prototype for
    function 'memregion_free' [-Wmissing-prototypes]

Mark memregion_free() static.

Fixes: 33dd70752cd7 ("lib: Uplevel the pmem "region" ida to a global allocator")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/165601455171.4042645.3350844271068713515.stgit@dwillia2-xfh
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memregion.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -16,7 +16,7 @@ static inline int memregion_alloc(gfp_t
 {
 	return -ENOMEM;
 }
-void memregion_free(int id)
+static inline void memregion_free(int id)
 {
 }
 #endif


